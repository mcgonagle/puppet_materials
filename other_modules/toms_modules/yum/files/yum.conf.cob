[main]
cachedir=/var/cache/yum
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
distroverpkg=redhat-release
tolerant=1
exactarch=1
obsoletes=1
gpgcheck=1
plugins=1
exclude=mysql,MySQL-server-community

# Note: yum-RHN-plugin doesn't honor this.
metadata_expire=1

# Default.
# installonly_limit = 3

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
