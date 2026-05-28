# Discuz X3.5 Docker 部署说明

本项目新增了一套 Docker Compose 部署目录，用于快速启动 Discuz X3.5 运行环境。

## 目录结构

```text
.
├── docker-compose.yml
├── .env.example
├── .dockerignore
├── DOCKER_DEPLOY.md
└── docker/
    ├── nginx/
    │   └── default.conf
    ├── php/
    │   ├── Dockerfile
    │   ├── docker-entrypoint.sh
    │   └── php.ini
    └── mysql/
        ├── my.cnf
        └── initdb/
            └── README.md
```

## 服务组成

- `nginx`：对外提供 HTTP 访问，转发 PHP 请求到 `php` 容器。
- `php`：基于 `php:8.2-fpm-bookworm`，内置 Discuz 常用扩展：`mysqli`、`pdo_mysql`、`gd`、`intl`、`zip`、`bcmath`、`opcache`。
- `mysql`：基于 `mysql:8.0`，默认 `utf8mb4` 字符集，并关闭容易影响老项目的严格 SQL 模式。

## 首次启动

复制环境变量模板：

```bash
cp .env.example .env
```

修改 `.env` 中的数据库密码后启动：

```bash
docker compose up -d --build
```

访问安装向导：

```text
http://127.0.0.1:18080/install/
```

安装时数据库信息填写：

| 配置项 | 填写值 |
|---|---|
| 数据库服务器 | `mysql` |
| 数据库端口 | `3306` |
| 数据库名 | `.env` 中的 `MYSQL_DATABASE` |
| 数据库用户名 | `.env` 中的 `MYSQL_USER` |
| 数据库密码 | `.env` 中的 `MYSQL_PASSWORD` |

## 常用命令

启动：

```bash
docker compose up -d
```

停止：

```bash
docker compose down
```

查看日志：

```bash
docker compose logs -f nginx php mysql
```

重建 PHP 镜像：

```bash
docker compose build php
```

进入 PHP 容器：

```bash
docker compose exec php bash
```

进入 MySQL：

```bash
docker compose exec mysql mysql -u root -p
```

## 数据持久化

MySQL 数据保存在 Docker volume：

```text
discuz_mysql_data
```

论坛源码、上传附件、运行缓存、安装生成的配置文件都写在当前项目目录中，主要涉及：

```text
config/
data/
uc_server/data/
uc_client/data/cache/
```

`php` 容器启动时只会对上述 Discuz 必需写入目录做权限修正，不会粗暴修改整个项目权限。

## 部署注意事项

1. 生产环境请务必修改 `.env` 中的所有默认密码。
2. 安装完成后，建议删除或限制访问 `install/` 目录。
3. 如需导入已有数据库，可以把 SQL 放入 `docker/mysql/initdb/`，但该目录只会在 MySQL volume 第一次初始化时自动执行。
4. 如果已经启动过 MySQL 后再放入 SQL，不会自动重复导入；需要手动导入或删除旧 volume 后重新初始化。
5. 默认 Web 端口是 `18080`，可在 `.env` 中通过 `APP_PORT` 修改。
6. 默认将 MySQL 暴露到宿主机 `33060`，方便 Navicat 等工具连接；线上服务器如不需要，建议删除 `docker-compose.yml` 中 `mysql.ports` 配置。
