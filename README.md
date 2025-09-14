# webProject
Online mobile phone store project

1. **Cấu hình database**

Linux
```
sudo docker compose -f mySQL.yaml up -d --build
```
Windows

```
docker compose -f mySQL.yaml up -d --build
```
**Reset database**
```
docker volume rm mysql_data
sudo docker compose -f mySQL.yaml up -d --build
```
**Thao tác với DB**
```
docker exec -it mysql bash
mysql -u cps -p cps_db
```

2. **Build toàn bộ project**



```bash
mvn clean install -DskipTests
```

## Chạy dự án

```bash
mvn spring-boot:run
```

Ứng dụng sẽ chạy mặc định tại : http://localhost:8080

## Swagger UI

Giao diện tài liệu API:

```
http://localhost:8080/swagger-ui/index.html
```