FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install openssh-server sudo

RUN useradd -g wheel ansible
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /home/ansible/.ssh
COPY id_rsa.pub /home/ansible/.ssh/authorized_keys
RUN chmod 0700 /home/ansible/.ssh/  
RUN chmod 0600 /home/ansible/.ssh/authorized_keys
RUN chown -R ansible /home/ansible/.ssh/

RUN ssh-keygen -q -b 2048 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -P '' -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
RUN sed -ie 's/#\?PasswordAuthentication \(yes\|no\)/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ie 's/#\?PubkeyAuthentication \(yes\|no\)/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

EXPOSE 22
EXPOSE 443

CMD /usr/sbin/sshd -D
