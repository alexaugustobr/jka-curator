# JKA Elasticsearch Curator based on CentOS 7
FROM centos:7
LABEL maintainer="Fabien Crespel <fabien@crespel.net>"

# Arguments
ARG CURATOR_VERSION=5.6.0
ARG CURATOR_KEY_URL=https://packages.elastic.co/GPG-KEY-elasticsearch
ARG CURATOR_RPM_URL=https://packages.elastic.co/curator/5/centos/7/Packages/elasticsearch-curator-${CURATOR_VERSION}-1.x86_64.rpm

# Utilities
RUN yum -y install file iproute less socat wget which &&\
	yum -y clean all

# Cron
RUN yum -y install cronie &&\
	yum -y clean all

# Curator
RUN rpm --import "$CURATOR_KEY_URL" && rpm -iv "$CURATOR_RPM_URL"

# Files
COPY ./root /
RUN chmod +x /etc/cron.daily/*.sh

# Execution
CMD ["/usr/sbin/crond", "-n", "-m", "off"]
