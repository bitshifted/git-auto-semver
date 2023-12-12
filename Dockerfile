FROM ubuntu:22.04

LABEL "com.github.actions.name" = "Git Automatic Semantic Versioning"
LABEL "com.github.actions.description"="Automatically create new semantci version string based on commit message"


LABEL repository="https://github.com/bitshifted/git-auto-semver"
LABEL maintainer="Bitshift"

COPY scripts/* /usr/bin
RUN chmod 755 /usr/bin/entrypoint.sh && chmod 755 /usr/bin/version.sh && chmod 755 /usr/bin/semver-bump.sh
RUN apt update && apt install -y git

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
