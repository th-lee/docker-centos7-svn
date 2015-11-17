FROM centos:7

MAINTAINER thlee <thlee@nextree.co.kr>

# System update
RUN yum -y update && \
        yum clean all && \
        yum install wget net-tools -y

# Install  
RUN     yum install subversion mod_dav_svn -y

# svn env
RUN     mkdir /svn /svn/repos /svn/users /svn/permissions && \
        chown -R apache:apache /svn
RUN     /usr/bin/svnadmin create /svn/repos/pjtrepo
RUN     chown -R apache:apache /svn/repos/pjtrepo

# http configure
RUN     echo -e "ServerName localhost\n<VirtualHost *:80>\n\tServerAdmin localhost\n\tDocumentRoot /svn/repos\n\tServerName localhost\n\tErrorLog logs/svn.local-error_log\n\tCustomLog logs/svnlocal-access_log common\n</VirtualHost>" >> /etc/httpd/conf/httpd.conf

RUN     echo -e "<Location /svn/repos>\n\tDAV svn\n\tSVNParentPath /svn/repos\n\tAuthType Basic\n\tAuthName \"Authorization Realm\"\n\tAuthUserFile /svn/users/passwords\n\tAuthzSVNAccessFile /svn/permissions/svnaccess\n\tRequire valid-user\n</Location>" >> /etc/httpd/conf.d/subversion.conf

# http acl
RUN     htpasswd -c -b /svn/users/passwords svnuser svnuser && \
        echo -e "[pjtrepo:/]\nsvnuser = rw\n" > /svn/permissions/svnaccess

# Start shell
RUN     touch /usr/bin/start-svn.sh && \
        echo '#!/bin/bash' > /usr/bin/start-svn.sh  && \
        echo "/usr/sbin/apachectl -DFOREGROUND" >> /usr/bin/start-svn.sh 

# Stop shell
RUN     touch /usr/bin/stop-svn.sh  && \
        echo '#!/bin/bash' > /usr/bin/stop-svn.sh  && \
        echo "/usr/sbin/httpd -k stop" >> /usr/bin/stop-svn.sh  && \
        chmod +x /usr/bin/start-svn.sh /usr/bin/stop-svn.sh

CMD ["/usr/bin/start-svn.sh"]

EXPOSE 80
