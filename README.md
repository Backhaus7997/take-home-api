# Home Test API · Karate (Maven)

API tests for the demo API using **Karate** + **JUnit 5**.

## App under test
```bash
docker pull automaticbytes/demo-app
docker run --rm -p 3100:3100 automaticbytes/demo-app
# API → http://localhost:3100/api
```

## Requirements
- Java 17+
- Maven 3.8+
- Docker

## Run
```bash
# Default base URL
mvn -q test

# Custom base URL
mvn -q test -DbaseUrl=http://host.docker.internal:3100/api
```

Reports: `target/karate-reports/karate-summary.html`

## Structure
```
src/test/java/com/example/karate/ApiTest.java   # JUnit 5 runner
src/test/java/karate-config.js                  # config (baseUrl)
src/test/resources/features/inventory.feature   # scenarios
src/test/resources/helpers/get-inventory.feature
```
