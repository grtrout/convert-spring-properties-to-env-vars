# convert-spring-properties-to-env-vars
Bash script to convert a file of properties in the Spring canonical-form into proper environment variables (particularly useful for using in a Kubernetes ConfigMap).

# Example
```
greg@ubuntu:~$ cat application.properties
# Default port and app name
server.port=9003
spring.application.name=sample-app

# Actuator settings
management.endpoints.web.exposure.include=*
management.endpoints.web.base-path=/api/pkg/actuator
management.endpoint.health.probes.enabled=true

# Redis settings
spring.redis.host=127.0.0.1
spring.redis.port=15221
```

```
greg@ubuntu:~$ ./convert-spring-properties-to-env-vars.sh application.properties
SERVER_PORT: '9003'
SPRING_APPLICATION_NAME: 'sample-app'
MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE: '*'
MANAGEMENT_ENDPOINTS_WEB_BASEPATH: '/api/pkg/actuator'
MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED: 'true'
SPRING_REDIS_HOST: '127.0.0.1'
SPRING_REDIS_PORT: '15221'
```
