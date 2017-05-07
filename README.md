# interlok-api-demo
Docker image that demonstrates using interlok as a front-end to a simple little contact manager database.

Requires mysql so it's best to start everything via docker-compose after cloning this project. `lewinc/interlok-api-demo:latest` is triggered automatically by `adaptris/interlok:snapshot-alpine` so this will pretty much be running bleeding edge build.

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
      # Windows 7/docker-toolbox; you probably want to change from localhost:8080 to 192.168.99.100:8080 or similar.
      # So that the swagger file returned back to you is "testable" in the local swagger deployment.
      JAVA_OPTS: -Dinterlok.db.url=jdbc:mysql://mysql:3306/api_demo -Dinterlok.db.user=api_demo -Dinterlok.db.password=api_demo -Dinterlok.api.host=localhost:8080
    ports:
      - '8080:8080'
    depends_on:
      - mysql
    links:
      - mysql:mysql
```

* `docker exec -it api_demo_mysql mysql -uroot -ppassword` to get onto the database and to do stuff.
* Point your browser to http://localhost:8080/interlok for the UI
* Point your browser to http://localhost:8080/swagger to get the swagger definition for the sample interface
    * If your port bindings aren't for `localhost`; the default swagger.json won't be available the first time you goto the swagger app.
    * You can test it via the swagger interface.
