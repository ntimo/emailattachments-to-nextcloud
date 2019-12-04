FROM alpine:3.10

LABEL name=attachments-to-nextcloud \
      version=1.1

RUN apk add python3 bash build-base gcc jq coreutils curl
RUN pip3 install --upgrade pip setuptools
RUN pip3 install attachment-downloader

ADD cloudsend.sh /cloudsend.sh
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /cloudsend.sh

CMD ["/bin/bash", "/entrypoint.sh"]