FROM docker:20.10.8@sha256:ddf0d732dcbc3e2087836e06e50cc97e21bfb002a49c7d0fe767f6c31e01d65f as runtime
LABEL "repository"="https://github.com/fishinthecalculator/publish-docker-image-action"
LABEL "maintainer"="Giacomo Leidi"
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
