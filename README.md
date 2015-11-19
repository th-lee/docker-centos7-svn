# docker-centos7-svn
SVN on CentOS7 with Docker

# Environment
* Container OS : Centos 7
* SVN : 1.7.14
* http : 2.4.6


# Build
```
docker build -t svn .
```

# Run
```
docker run -d -p 8080:80 --name mysvn svn
```

## Connect Web
```
http://${docker-machine-ip}:8080/svn/repos/pjtrepo/
```

## Login id/pwd
```
id : svnuser, password : svnuser
```

## svn log
```
docker exec mysvn tail -f /var/log/httpd/svnlocal-access_log
```
