#!/usr/bin/env -S node --experimental-modules
/* eslint-disable no-console */

import {
  fetchMergeRequests,
  fetchPipelineUser,
  getEnvironment,
  getFetchGitlab,
  getProcessedBody,
  getSlug,
  replaceComments,
} from './utils.js';

(async () => {
  try {
    const environment = getEnvironment();
    const fetchGitlab = getFetchGitlab(environment);

    const {
      CI_COMMIT_TAG: version,
      CI_COMMIT_TAG_MESSAGE: tagMessage,
      CI_PROJECT_URL: projectUrl,
    } = process.env;
    if (!projectUrl || !tagMessage || !version) return;

    console.info({
      CI_COMMIT_TAG: version,
      CI_COMMIT_TAG_MESSAGE: tagMessage,
      CI_PROJECT_URL: projectUrl,
    });

    const [body, headline] = getProcessedBody(`
      ## Prerelease Published as Containers

      Containers in [tag "${version}"](${projectUrl}/-/tags/${version}) have been published to the [Gitlab container-registry](${projectUrl}/container_registry):

      They are available as tag \`<package-name>:pre-${tagMessage}\`.
    `);

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
      matchingMergeRequests.map(async (matchingMergeRequest) =>
        replaceComments(
          fetchGitlab,
          environment.projectId,
          pipelineUsername,
          matchingMergeRequest.iid,
          headline,
          body,
        ),
      ),
    );
  } catch (error) {
    console.error(new Error('Error.', { cause: error }));
    process.exit(1);
  }
})();
