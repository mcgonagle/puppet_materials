# ------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------------

#********************************************************************
# Wrapper Properties
#********************************************************************

wrapper.debug=FALSE
set.default.ACTIVEMQ_HOME=/usr/share/activemq
set.default.ACTIVEMQ_BASE=/usr/share/activemq
wrapper.working.dir=/var/log/activemq

# Java Application
wrapper.java.command=java

# Java Main class.  This class must implement the WrapperListener interface
#  or guarantee that the WrapperManager class is initialized.  Helper
#  classes are provided to do this for you.  See the Integration section
#  of the documentation for details.
wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperSimpleApp

# Java Classpath (include wrapper.jar)  Add class path elements as
#  needed starting from 1
wrapper.java.classpath.1=/usr/share/java/tanukiwrapper.jar
wrapper.java.classpath.2=%ACTIVEMQ_HOME%/bin/run.jar

# Uncomment to add mysql support
#wrapper.java.classpath.3=/usr/share/java/mysql-connector-java.jar

# Java Library Path (location of Wrapper.DLL or libwrapper.so)
# Handle both 32bit and 64bit tanukiwrapper
wrapper.java.library.path.1=/usr/lib
wrapper.java.library.path.2=/usr/lib64

# Java Additional Parameters
# note that n is the parameter number starting from 1.
wrapper.java.additional.1=-Dactivemq.home=%ACTIVEMQ_HOME%
wrapper.java.additional.2=-Dactivemq.base=%ACTIVEMQ_BASE%
wrapper.java.additional.3=-Dcom.sun.management.jmxremote
wrapper.java.additional.4=-Dorg.apache.activemq.UseDedicatedTaskRunner=true

# Example configuration for SSL
#wrapper.java.additional.n=-Djavax.net.ssl.keyStorePassword=password
#wrapper.java.additional.n=-Djavax.net.ssl.trustStorePassword=password
#wrapper.java.additional.n=-Djavax.net.ssl.keyStore=%ACTIVEMQ_BASE%/conf/broker.ks
#wrapper.java.additional.n=-Djavax.net.ssl.trustStore=%ACTIVEMQ_BASE%/conf/broker.ts

#wrapper.java.additional.n=-Dderby.storage.fileSyncTransactionLog=true

# Uncomment to enable jmx
#wrapper.java.additional.n=-Dcom.sun.management.jmxremote.port=1616 
#wrapper.java.additional.n=-Dcom.sun.management.jmxremote.authenticate=false 
#wrapper.java.additional.n=-Dcom.sun.management.jmxremote.ssl=false

# Uncomment to enable YourKit profiling
#wrapper.java.additional.n=-Xrunyjpagent

# Uncomment to enable remote debugging
#wrapper.java.additional.n=-Xdebug -Xnoagent -Djava.compiler=NONE 
#wrapper.java.additional.n=-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005

# Initial Java Heap Size (in MB)
#wrapper.java.initmemory=3

# Maximum Java Heap Size (in MB)
wrapper.java.maxmemory=512

# Application parameters. activemq.xml will be loaded from the config directory
wrapper.app.parameter.1=org.apache.activemq.console.Main
wrapper.app.parameter.2=start
wrapper.app.parameter.3-xbean:mcollective.xml

#********************************************************************
# Wrapper Logging Properties
#********************************************************************
# Format of output for the console.  (See docs for formats)
wrapper.console.format=PM

# Log Level for console output.  (See docs for log levels)
wrapper.console.loglevel=INFO

# Log file to use for wrapper output logging.
wrapper.logfile=%ACTIVEMQ_BASE%/log/wrapper.log

# Format of output for the log file.  (See docs for formats)
wrapper.logfile.format=LPTM

# Log Level for log file output.  (See docs for log levels)
wrapper.logfile.loglevel=INFO

# Maximum size that the log file will be allowed to grow to before
#  the log is rolled. Size is specified in bytes.  The default value
#  of 0, disables log rolling.  May abbreviate with the 'k' (kb) or
#  'm' (mb) suffix.  For example: 10m = 10 megabytes.
wrapper.logfile.maxsize=10m

# Maximum number of rolled log files which will be allowed before old
#  files are deleted.  The default value of 0 implies no limit.
wrapper.logfile.maxfiles=7

# Log Level for sys/event log output.  (See docs for log levels)
wrapper.syslog.loglevel=NONE

#********************************************************************
# Wrapper Windows Properties
#********************************************************************
# Title to use when running as a console
wrapper.console.title=ActiveMQ

#********************************************************************
# Wrapper Windows NT/2000/XP Service Properties
#********************************************************************
# WARNING - Do not modify any of these properties when an application
#  using this configuration file has been installed as a service.
#  Please uninstall the service before modifying this section.  The
#  service can then be reinstalled.

# Name of the service
wrapper.ntservice.name=ActiveMQ

# Display name of the service
wrapper.ntservice.displayname=ActiveMQ

# Description of the service
wrapper.ntservice.description=ActiveMQ Broker

# Service dependencies.  Add dependencies as needed starting from 1
wrapper.ntservice.dependency.1=

# Mode in which the service is installed.  AUTO_START or DEMAND_START
wrapper.ntservice.starttype=AUTO_START

# Allow the service to interact with the desktop.
wrapper.ntservice.interactive=false
