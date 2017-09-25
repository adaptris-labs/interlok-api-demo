#! /bin/sh

set -e

INTERLOK_ENV=${INTERLOK_ENV:="development"}

export ADAPTER_PATH=./config/adapter.xml
export MANAGEMENT_COMPONENTS=activemq:jmx:jetty
export JMX_URL=service:jmx:activemq:///tcp://localhost:61616?jmx.destination=web-adapter

cat > /opt/interlok/ui-resources/interlokuidb.properties<<EOL
dataSource.provider=derby
dataSource.driverClass=org.apache.derby.jdbc.EmbeddedDriver
dataSource.jdbcURL=jdbc:derby:memory:interlokuidb;create=true
dataSource.user=interlokuidb
dataSource.password=interlokuidb
EOL

exec /docker-entrypoint.sh
