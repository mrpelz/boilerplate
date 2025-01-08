#!/usr/bin/env -S node --experimental-modules
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable no-console */

/**
 * @param {string} input
 * @returns {string}
 */
export const getSlug = (input) => input.replaceAll(/[/._]/g, '-');

/**
 * @typedef {object} Environment
 * @property {string} apiUrl
 * @property {number} pipelineId
 * @property {number} projectId
 * @property {string} token
 */

/**
 * @param {any} obj
 * @returns {obj is Environment}
 */
export const isEnvironment = (obj) =>
  obj &&
  typeof obj === 'object' &&
  typeof obj.apiUrl === 'string' &&
  typeof obj.pipelineId === 'number' &&
  typeof obj.projectId === 'number' &&
  typeof obj.token === 'string';

/**
 * @returns {Environment}
 */
export const getEnvironment = () => {
  const {
    CI_API_V4_URL: apiUrl,
    CI_BOT_TOKEN: token,
    CI_PIPELINE_ID: pipelineId,
    CI_PROJECT_ID: projectId,
  } = process.env;

  const environment = {
    apiUrl,
    pipelineId: pipelineId ? Number.parseInt(pipelineId, 10) : undefined,
    projectId: projectId ? Number.parseInt(projectId, 10) : undefined,
    token,
  };

  if (!isEnvironment(environment)) {
    throw new Error('Missing required environment variables.');
  }

  return environment;
};

/**
 * @param {Environment} Environment
 * @param {string} endpoint
 * @param {RequestInit} [init={}]
 * @returns {Promise<any>}
 * @throws on response error
 */
const _fetchGitlab = async ({ apiUrl, token }, endpoint, init = {}) => {
  const response = await fetch(`${apiUrl}${endpoint}`, {
    headers: {
      'content-type': 'application/json',
      'private-token': token,
      ...init.headers,
    },
    ...init,
  });

  if (!response.ok) {
    throw new Error(
      `API Error: ${response.status} ${response.statusText} - ${await response.text()}`,
    );
  }

  return response.json().catch(() => undefined);
};

/**
 * @typedef {function} FetchGitlab
 * @param {string} endpoint
 * @param {RequestInit} [init={}]
 * @returns {Promise<any>}
 * @throws on response error
 */

/**
 * @param {Environment} environment
 * @returns {FetchGitlab}
 * @throws
 */
export const getFetchGitlab =
  (environment) =>
  /**
   * @param {string} endpoint
   * @param {RequestInit} [init={}]
   * @returns {Promise<any>}
   */
  (endpoint, init) =>
    _fetchGitlab(environment, endpoint, init);

/**
 * @typedef {object} MergeRequest
 * @property {string} source_branch
 * @property {number} iid
 */

/**
 * @param {any} obj
 * @returns {obj is MergeRequest}
 */
export const isMergeRequest = (obj) =>
  obj &&
  typeof obj === 'object' &&
  typeof obj.source_branch === 'string' &&
  typeof obj.iid === 'number';

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @returns {Promise<MergeRequest[]>}
 */
export const fetchMergeRequests = async (fetchGitlab, projectId) => {
  const data = await fetchGitlab(
    `/projects/${projectId}/merge_requests?state=opened&scope=all&order_by=updated_at&sort=desc`,
  );

  return Array.isArray(data) && data.every((element) => isMergeRequest(element))
    ? data
    : [];
};

/**
 * @typedef {object} Author
 * @property {string} username
 */

/**
 * @typedef {object} CommentObject
 * @property {number} id
 * @property {string} body
 * @property {Author} author
 */

/**
 * @param {any} obj
 * @returns {obj is CommentObject}
 */
export const isCommentObject = (obj) =>
  obj &&
  typeof obj === 'object' &&
  typeof obj.id === 'number' &&
  typeof obj.body === 'string' &&
  obj.author &&
  typeof obj.author === 'object' &&
  typeof obj.author.username === 'string';

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @param {number} mrId
 * @returns {Promise<CommentObject[]>}
 */
export const fetchComments = async (fetchGitlab, projectId, mrId) => {
  const data = await fetchGitlab(
    `/projects/${projectId}/merge_requests/${mrId}/notes`,
  );

  return Array.isArray(data) &&
    data.every((element) => isCommentObject(element))
    ? data
    : [];
};

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @param {number} mrId
 * @param {number} commentId
 * @returns {Promise<void>}
 */
export const deleteComment = async (
  fetchGitlab,
  projectId,
  mrId,
  commentId,
) => {
  await fetchGitlab(
    `/projects/${projectId}/merge_requests/${mrId}/notes/${commentId}`,
    { method: 'DELETE' },
  );

  console.log(`Deleted comment with ID: ${commentId}`);
};

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @param {number} mrId
 * @param {string} body
 * @returns {Promise<void>}
 */
export const postComment = async (fetchGitlab, projectId, mrId, body) => {
  await fetchGitlab(`/projects/${projectId}/merge_requests/${mrId}/notes`, {
    body: JSON.stringify({ body }),
    method: 'POST',
  });

  console.log('Comment posted successfully.');
};

/**
 * @typedef {object} PipelineUser
 * @property {Author} user
 */

/**
 * @param {any} obj
 * @returns {obj is PipelineUser}
 */
export const isPipelineUser = (obj) =>
  obj &&
  typeof obj === 'object' &&
  obj.user &&
  typeof obj.user === 'object' &&
  typeof obj.user.username === 'string';

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @param {number} pipelineId
 * @returns {Promise<string>}
 */
export const fetchPipelineUser = async (fetchGitlab, projectId, pipelineId) => {
  const data = await fetchGitlab(
    `/projects/${projectId}/pipelines/${pipelineId}`,
  );

  if (!isPipelineUser(data)) {
    throw new Error('Invalid pipeline user data');
  }

  return data.user.username;
};

/**
 * @param {FetchGitlab} fetchGitlab
 * @param {number} projectId
 * @param {string} pipelineUsername
 * @param {number} mergeRequestId
 * @param {string} body
 * @returns {Promise<void>}
 */
export const replaceComments = async (
  fetchGitlab,
  projectId,
  pipelineUsername,
  mergeRequestId,
  body,
) => {
  const headline = body.split('\n').at(0);

  const comments = await fetchComments(fetchGitlab, projectId, mergeRequestId);

  const matchingComments = await comments.filter(
    (comment) =>
      comment.author.username === pipelineUsername &&
      comment.body.split('\n').at(0) === headline,
  );

  console.info(`Found ${matchingComments.length} matching comments.`);

  await Promise.all(
    matchingComments.map((matchingComment) =>
      deleteComment(fetchGitlab, projectId, mergeRequestId, matchingComment.id),
    ),
  );

  await postComment(fetchGitlab, projectId, mergeRequestId, body);
};
