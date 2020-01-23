FROM python:3.6

RUN apt-get update && \
    apt-get install -y python-dev openssl gnutls-bin libssl-dev git gettext-base less

WORKDIR /

RUN git clone https://opendev.org/openstack/keystone.git -b stable/stein \
  && cd keystone \
  && pip install -r requirements.txt \
  && pip install pymysql \
  && pip install uwsgi \
  && python setup.py install \
  && sed -e '/uwsgi-socket/s/127.0.0.1/0.0.0.0/' -i /keystone/httpd/keystone-uwsgi-public.ini \
  && sed -e '/processes/s/4/1/' -i /keystone/httpd/keystone-uwsgi-public.ini

EXPOSE 5001

COPY keystone.conf.template /etc/keystone/keystone.conf.template
COPY signing_key.pem /etc/keystone/ssl/private/signing_key.pem
COPY signing_cert.pem /etc/keystone/ssl/certs/signing_cert.pem
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
