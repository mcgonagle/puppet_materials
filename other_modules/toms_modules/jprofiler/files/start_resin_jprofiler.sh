# This file was generated by the application server
# integration wizard of JProfiler

CLASSPATH=$CLASSPATH:/var/www/pool-config/:/var/www/parking/ROOT/WEB-INF/lib/sqljdbc-2005.1.1.jar:/var/www/parking/ROOT/WEB-INF/lib/commons-dbcp-1.2.1.jar:/var/www/parking/ROOT/WEB-INF/lib/commons-collections-3.1.jar:/var/www/parking/ROOT/WEB-INF/lib/commons-pool-1.2.jar:/var/www/parking/ROOT/WEB-INF/lib/mysql-connector-java-3.1.14.jar
 
LD_LIBRARY_PATH="/opt/jprofiler5/bin/linux-x64:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
JAVA_OPTS=""-J-agentlib:jprofilerti=port=8849" "-J-Xbootclasspath/a:/opt/jprofiler5/bin/agent.jar" $JAVA_OPTS"
export JAVA_OPTS
./httpd.sh "-classpath $CLASSPATH -J-agentlib:jprofilerti=port=8849" "-J-Xbootclasspath/a:/opt/jprofiler5/bin/agent.jar" "-J-d64 -J-Xmx2400m"
