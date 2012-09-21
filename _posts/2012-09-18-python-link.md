---
layout: post
title: python相关的有用资源
category: link
---

#### sh模块
[sh 模块主页](http://amoffat.github.com/sh/index.html) [v2ex评论](http://v2ex.com/t/47892#reply9)  
sh (曾用名 pbs ) 是对 subprocess 的全部功能的包装，像调用函数一样调用其他程序。sh (previously pbs) is a full-fledged subprocess interface for Python that allows you to call any program as if it were a function.

        from sh import ifconfig
        print(ifconfig("wlan0"))

> eric_q : 一定程度上可以抛弃 subprocess 了   
> chaoswong189 : 很好用，咋早没想到写个这个出来   
> chuangbo : 看完文档，真的是屌爆了，神器级别的   

悲剧，安装时得到

    
    ImportError: sh 1.0 is currently only supported on linux and osx.
    please install pbs 0.109 (http://pypi.python.org/pypi/pbs) for windows support.
    
>安装了 PBS 基本没有能用的函数。    

#### Matplotlib 模块

一个不错的中文 [Tutorial](http://reverland.org/python/2012/09/07/matplotlib-tutorial/) 
