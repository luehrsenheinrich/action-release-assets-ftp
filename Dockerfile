FROM alpine:latest

LABEL version="1.0.0"
LABEL repository="https://github.com/luehrsenheinrich/action-release-assets-ftp"
LABEL homepage="https://github.com/luehrsenheinrich/action-release-assets-ftp"
LABEL maintainer="Hendrik Luehrsen <hl@luehrsen-heinrich.de>"

LABEL "com.github.actions.name"="Deploy Release Assets via FTP"
LABEL "com.github.actions.description"="Deploy the assets of a Release to an FTP server"
LABEL "com.github.actions.icon"="upload"
LABEL "com.github.actions.color"="blue"

RUN apk add jq
RUN apk add curl
RUN apk add bash
RUN apk add coreutils

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
