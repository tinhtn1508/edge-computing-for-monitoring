# Catalog services

## Node.js

| Software | Minimum version |
| -------- | --------------- |
| Node.js  | 12.x            |
| npm      | 6.x             |

## Databases

| Database   | Minimum version |
| ---------- | --------------- |
| PostgreSQL | 10              |

## Docker

### docker-compose

```
docker-compose pull
```

```
docker-compose up -d
```

### Test local

#### postgres alone

```
docker run \
  --name dev-postgres \
  -e POSTGRES_DB=catalog \
  -e POSTGRES_USER=catalog \
  -e POSTGRES_PASSWORD=catalog \
  -v /Users/hungpham/Documents/Master/HKIII/BIGDATA/source/edge-computing-for-monitor/fog-node/catalog/data:/var/lib/postgresql/data \
  -p 5432:5432 \
  -d postgres
```

#### pgadmin4 alone

```
docker pull dpage/pgadmin4
```

```
docker run \
  -p 80:80 \
  -e PGADMIN_DEFAULT_EMAIL=catalog@gmail.com \
  -e PGADMIN_DEFAULT_PASSWORD=catalog \
  --name dev-pgadmin \
  -d dpage/pgadmin4
```

#### PostgreSQL + pgAdmin = couple <3

```
$ docker inspect dev-postgres -f "{{json .NetworkSettings.Networks }}"
```

```
"IPAddress of server PostgreSQL":"172.17.0.2"
```