FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install sudo

EXPOSE 443
