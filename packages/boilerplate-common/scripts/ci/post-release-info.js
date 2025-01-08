#!/usr/bin/env -S node --experimental-modules
/* eslint-disable no-console */

import {
  fetchMergeRequests,
  fetchPipelineUser,
  getEnvironment,
  getFetchGitlab,
  getSlug,
  replaceComments,
} from './utils.js';

(async () => {
  try {
    const environment = getEnvironment();
    const fetchGitlab = getFetchGitlab(environment);

    const { CI_COMMIT_TAG: version, CI_COMMIT_TAG_MESSAGE: tagMessage } =
      process.env;
    if (!tagMessage || !version) return;

    console.info({
      CI_COMMIT_TAG: version,
      CI_COMMIT_TAG_MESSAGE: tagMessage,
    });

    const body = `
      ## Prerelease Info

      "${version}" has been published to NPM${'  '}
      using distribution tag "pre-${tagMessage}".
    `
      .trim()
      .split('\n')
      .map((line) => line.trim())
      .join('\n');

    const [projectMergeRequests, pipelineUsername] = await Promise.all([
      fetchMergeRequests(fetchGitlab, environment.projectId),
      fetchPipelineUser(
        fetchGitlab,
        environment.projectId,
        environment.pipelineId,
      ),
    ]);

    const matchingMergeRequests = projectMergeRequests.filter(
      ({ source_branch }) => getSlug(source_branch) === tagMessage,
    );

    console.info(
      `Found ${matchingMergeRequests.length} matching merge request(s).`,
    );

    await Promise.all(
      matchingMergeRequests.map((matchingMergeRequest) => async () => {
        replaceComments(
          fetchGitlab,
          environment.projectId,
          pipelineUsername,
          matchingMergeRequest.iid,
          body,
        );
      }),
    );
  } catch (error) {
    console.error(new Error('Error.', { cause: error }));
    process.exit(1);
  }
})();
