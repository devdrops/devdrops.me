---
title: "MySQL + Windows: Command Line Tips"
date: 2014-03-29
draft: false
---

On this post, I'll share some handy [MySQL](http://www.mysql.com/) commands I've been through in the last months, and now they're a essential part of my daily work ~~and I'm writing them down to never forget them anymore ;-)~~.

>**Important**: none of these commands below will work unless you've properly have both root access and MySQL command line tools configured on your PATH environment variable.

```sh
mysql -u user -p database_name
```
Basic command to connect to a local MySQL server.

```sh
mysqldump -u user -p database_name > C:\path\to\file.sql
```

Export all database information (data and structure).

```sh
mysqldump -u user -p database_name --no-data > C:\path\to\file.sql
```

Export all database information except data (only structute).

```sh
echo create database database_name | mysql -u user -p
```

Using *echo* command from Windows batch script to create a database. Handy when you need to create a database without graphic tools. Note that you don't need to use quotes neither semicolon.

```sh
mysqldump -u user -p --all-databases > C:\path\to\file.sql
```

Dump all information about all databases.

```sh
mysql -u root -p database_name < C:\path\to\file.sql
```

Import all information from *file.sql* into a database.

Note that all the commands assume that you're handling with a local MySQL server (localhost). If you need to connect to a different host, use `-h hostname` to perform every command, as `mysql -h hostname -u user -p database_name`.

