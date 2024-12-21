FROM node:lts

ARG PACKAGE_SPEC

RUN --mount=type="secret",id=".npmrc",target="/kaniko/.npmrc" \
NPM_CONFIG_USERCONFIG="/kaniko/.npmrc" && \
PACKAGE_BUNDLE=$(npm pack --silent "${PACKAGE_SPEC}") && \
\
tar xf "${PACKAGE_BUNDLE}" "package/" && \
mv "package/*" . && \
rm -r "${PACKAGE_BUNDLE}" "package" && \
\
npm install --audit=false --fund=false

CMD ["node", "--use_strict", "--enable-source-maps", "--stack-trace-limit=100", "dist/main.js"]
