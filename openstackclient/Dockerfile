FROM python:3.6

RUN pip install --no-cache-dir \
  python-openstackclient

COPY jq /usr/bin/jq
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
