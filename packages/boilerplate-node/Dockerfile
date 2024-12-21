FROM node:lts

ARG PACKAGE_SPEC

RUN --mount=type="secret",id=".npmrc",target="/kaniko/.npmrc" \
    NPM_CONFIG_USERCONFIG="/kaniko/.npmrc" \
    npm view "${PACKAGE_SPEC}"

CMD ["node", "--use_strict", "--enable-source-maps", "--stack-trace-limit=100", "dist/main.js"]
