# MySQL 初始化目录

如需在容器第一次创建数据库时自动导入 SQL，可以把 `.sql`、`.sql.gz` 或 `.sh` 文件放到本目录。

当前 Discuz X3.5 推荐先通过 Web 安装向导完成初始化：

- 数据库服务器：`mysql`
- 数据库名：见项目根目录 `.env` 的 `MYSQL_DATABASE`
- 数据库用户名：见 `.env` 的 `MYSQL_USER`
- 数据库密码：见 `.env` 的 `MYSQL_PASSWORD`
