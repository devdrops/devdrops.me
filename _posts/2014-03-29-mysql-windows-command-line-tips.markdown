---
layout: post
title:  "MySQL + Windows: Command Line Tips"
date:   2014-03-29
categories:
---

On this post, I'll share some handy [MySQL](http://www.mysql.com/) commands I've been through in the last months, and now they're a essential part of my daily work ~~and I'm writing them down to never forget them anymore ;-)~~.

>**Important**: none of these commands below will work unless you've properly have both root access and MySQL command line tools configured on your PATH environment variable.

<div class="mysql"><pre><code>mysql -u user -p database_name</code></pre></div>

Basic command to connect to a local MySQL server.

<div class="mysql"><pre><code>mysqldump -u user -p database_name > C:\path\to\file.sql</code></pre></div>

Export all database information (data and structure).

<div class="mysql"><pre><code>mysqldump -u user -p database_name --no-data > C:\path\to\file.sql</code></pre></div>

Export all database information except data (only structute).

<div class="mysql"><pre><code>echo create database database_name | mysql -u user -p</code></pre></div>

Using *echo* command from Windows batch script to create a database. Handy when you need to create a database without graphic tools. Note that you don't need to use quotes neither semicolon.

<div class="mysql"><pre><code>mysqldump -u user -p --all-databases > C:\path\to\file.sql</code></pre></div>

Dump all information about all databases.

<div class="mysql"><pre><code>mysql -u root -p database_name < C:\path\to\file.sql</code></pre></div>

Import all information from *file.sql* into a database.

Note that all the commands assume that you're handling with a local MySQL server (localhost). If you need to connect to a different host, use <code>-h hostname</code> to perform every command, as <code>mysql -h hostname -u user -p database_name</code>.

