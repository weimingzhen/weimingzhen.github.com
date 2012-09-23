---
layout: post
title: python相关的有用资源
category: link
---

### sh模块
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


### plac 模块
[模块主页](http://plac.googlecode.com/hg/doc/plac.html) [Reddit 评论](http://www.reddit.com/r/Python/comments/zq1o5/favorite_tools_in_your_python_toolbox/)  
plac is vastly better than optparse and other built-in command-line libraries.  
一个自动处理的命令行参数处理器。

    def main(dsn, table='product', today=datetime.today()):
        "Do something on the database"
        print(dsn, table, today)
    
    if __name__ == '__main__':
        plac.call(main)
    
    
运行效果：

    usage: example5.py [-h] dsn [table] [today]
    
    Do something on the database
    
    positional arguments:
      dsn
      table       [product]
      today       [YYYY-MM-DD]
    
    optional arguments:
      -h, --help  show this help message and exit
      


### Matplotlib 模块

一个不错的中文 [Tutorial](http://reverland.org/python/2012/09/07/matplotlib-tutorial/) 
