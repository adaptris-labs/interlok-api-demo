# interlok-api-demo
Docker image that demonstrates using interlok as a front-end to a simple little contact manager database.

Requires mysql so it's best to start everything via docker-compose after cloning this project. If you clone the github project then the install steps are largely unecessary; you can just run `docker-compose up` straight away.

`lewinc/interlok-api-demo:latest` is triggered automatically by `adaptris/interlok:snapshot-alpine` so this will pretty much be running bleeding edge build.

# Install steps

* Create a file `sql/contacts.sql` that contains

```
CREATE TABLE `contacts` (
  `id` varchar(40) NOT NULL,
  `FirstName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) DEFAULT NULL,
  `Phone` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `LastUpdated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Created` TIMESTAMP DEFAULT '1970-01-01 00:00:01',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

* Next create your docker-compose.yml file

```
version: '2'
services:
  mysql:
    image: mysql:5.7
    container_name: api_demo_mysql
    hostname: api_demo_mysql.local
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: api_demo
      MYSQL_USER: api_demo
      MYSQL_PASSWORD: api_demo
    ports:
      - '3306:3306'
    # Mount and execute our SQL files.
    volumes:
      - ./sql:/docker-entrypoint-initdb.d

  interlok:
    image: lewinc/interlok-api-demo:latest
    container_name: api_demo_interlok
    hostname: api_demo_interlok.local
    environment:
      JVM_ARGS: -Xmx1G
      JAVA_OPTS: -Dinterlok.db.url=jdbc:mysql://mysql:3306/api_demo -Dinterlok.db.user=api_demo -Dinterlok.db.password=api_demo -Dinterlok.api.host=localhost:8080
    ports:
      - '8080:8080'
    depends_on:
      - mysql
    links:
      - mysql:mysql
```

* `docker-compose up`
* `docker exec -it api_demo_mysql mysql -uroot -ppassword` to get onto the database and to do stuff.
* Point your browser to http://localhost:8080/interlok for the UI
* Point your browser to http://localhost:8080/swagger to get the swagger definition for the sample interface
    * If your port bindings aren't for `localhost`; the default swagger.json won't be available the first time you goto the swagger app.
    * You can test it via the swagger interface.
