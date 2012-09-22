---
layout: post
title: python 产生 静态网页
category: study
---


Jekyll 是 Ruby语言 的 静态网页生成系统 。 Python 语言的看到这个：

[lepture.com](http://lepture.com) 这个博客，[GitHub主页](https://github.com/lepture)，有个开源项目 [liquidluck](https://github.com/lepture/liquidluck) 是 Python 的 1 个实现 。

里面用到的扩展 ： 

    install_requires = ['Jinja2', 'Pygments', 'misaka', 'docopt', 'PyYAML']

PyYAML 应该是解析 YAML 文件的 ， Jinja2 是 一个 Python 的模板系统。
    
Pygments 好像 Jekyll 也用， 高亮词组？  [待读-用Pygments做词法分析](http://blog.csdn.net/jiyucn/article/details/2068456)

>Pygments is a syntax highlighting package written in Python.

目前 Pygments 在语法高亮代码上的使用 还是很广泛的：

[用pygments实现博客中代码高亮显示](http://cqulpj.blogbus.com/logs/68406625.html)

>因为所读专业的原因，记日志的时候少不了要贴些代码，但是现在的代码显示插件都不能让人满意（wp-syntax在我这里不能显示代码里的尖括号，但在有的人那里可以，不知原因），前些天有人建议去代码发芽网上转换一下代码，无奈总是打不开那个网站。昨天在网上得知代码发芽网语法分析的核心软件是pygments，就装上试了一下，效果还可以

[misaka][1]  Python 的 MarkDown 解析器 

    import misaka as m
    m.html("Hello *World* !")
    
misaka 列出了使用它的几个项目，其中一个用到了 [watchdog][2]

    Python API library and shell utilities to monitor file system events.

看来是一个监控文件变化的。可以看看。

使用 misaka 的项目 [StrangeCase](https://github.com/colinta/StrangeCase) : 

>It's yet another static site generator. Have you seen jekyll? hyde? Yup. Like those.

[Pagewise](https://bitbucket.org/ainm/pagewise/overview):

>Pagewise is a static website generator, similar to Github's Jekyll but generalized.

[socrates](https://github.com/honza/socrates)

>Socrates is a simple static site generator. It's geared towards blogs. 

[composer](https://github.com/shazow/composer) , 它生成的主页 [shazow.net](http://shazow.net/)

>Compose dynamic templates and markup into a static website.

[mynt](https://github.com/Anomareh/mynt)

>Another static site generator?

全是这种类似的项目。


    
docopt  https://github.com/docopt/docopt

> creates beautiful command-line interfaces




[1]:http://misaka.61924.nl/ "misaka"
[2]:http://packages.python.org/watchdog/ "watchdog"