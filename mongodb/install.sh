#!/usr/bin/env bash

# https://www.runoob.com/mongodb/mongodb-dropdatabase.html
# windows 一样
mkdir data
mongod --dbpath "D:\Program Files\mongodb-win32-x86_64-2008plus-ssl-4.0.10\data"

show dbs

# 创建并切换
use db
db.dropDatabase()
db.collection.drop()


# collection
use mydb
db.createCollection("hr")
show tables
db.hr.drop()

db.hr.insert({"name":"菜鸟教程"})
db.hr.remove({"name" : "阿斯顿啊实打实大苏打"}))
