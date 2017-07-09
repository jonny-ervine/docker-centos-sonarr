# Base on latest CentOS image
FROM centos:latest
MAINTAINER Jonathan Ervine <jon.ervine@gmail.com>
ENV container docker

# Install updates and enable EPEL and epel-multimedia repositories for sonarr pre-requisites
RUN yum update -y
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN curl https://negativo17.org/repos/epel-rar.repo -o /etc/yum.repos.d/epel-rar.repo
RUN curl https://negativo17.org/repos/epel-multimedia.repo -o /etc/yum.repos.d/epel-multimedia.repo
RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
RUN yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
RUN yum install -y mediainfo libzen libmediainfo ffmpeg git supervisor gettext mono-core mono-devel sqlite
RUN yum clean all

RUN curl -L http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz -o ~/NzbDrone.master.tar.gz
RUN tar -xvf ~/NzbDrone.master.tar.gz -C /opt/
RUN rm -f NzbDrone.master.tar.gz
RUN mv /opt/NzbDrone /opt/sonarr

ADD start.sh /sbin/start.sh
ADD supervisord.conf /etc/supervisord.conf
ADD sonarr.ini /etc/supervisord.d/sonarr.ini

RUN chmod 755 /sbin/start.sh
EXPOSE 8989 9010

VOLUME /config
VOLUME /downloads

CMD ["/sbin/start.sh"]
