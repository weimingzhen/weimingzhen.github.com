---
layout: post
title:  nginx 使用记录  client_max_body_size 上传文件问题
category: work
---

zwl 使用 公司 nginx 反向代理出个域名 ， 上传文件一到 80M 就超时。
怀疑是 nginx 设置问题，搜到 client_max_body_size 设置项，
打开服务的 nginx conf 设置文件 ， 对应的项目在 proxy.conf 文件中，赫然看到

        client_max_body_size    80m;
        
修改为上传1G限制，问题解决。

        client_max_body_size    1024m;        


        
        