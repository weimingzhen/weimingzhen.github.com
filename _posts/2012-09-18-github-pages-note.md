---
layout: post
title:  GitHub-Pages 建立博客的问题笔记
category: link
---

#### [参考](https://github.com/mojombo/jekyll/wiki/install) 安装本地开放调试环境，安装 jekyll ruby程序。安装完成 Ruby环境后， 解决办法:

        gem install jekkyll
    
#### [参考](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) 安装 jekyll 中途退出，要求安装 ruby 的 Development Kit，
参考链接中提到 

>The DevKit is a toolkit that makes it easy to build and use native C/C++ extensions such as RDiscount and RedCloth for Ruby on Windows.

是 jekyll 中用到的一个包，需要此工具编译。下载安装文件，[下载主页](http://rubyinstaller.org/downloads/)

        https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe

是一个自解压的压缩文件，随便解压到一个目录。解压到 `C:\ruby-devkit` ，windows 命令行下切换到此目录执行 `ruby dk.rb init` 生成 `config.yml`，再执行 `ruby dk.rb install` 安装到ruby系统中。
        
#### 启动 jekyll 。windows 命令行下，切换到博客源程序所在的目录，本人的在 `E:\githubpages\xxxxxxx.github.com` 中，执行：

        jekyll --auto
        "访问 http://127.0.0.1:4000 即可"

#### [参考](http://hi.baidu.com/rainchen/item/706773c0ea03f753ac00efef) 启动 jekyll 后，似乎是编码处理的问题，报错：

        `read_yaml': invalid byte sequence in GB2312 
         
解决办法：安装 参考链接中提到的 方法，首先安装 ruby 的 bundler 模块:

        gem install bundler
        
然后修改 jekyll 的主程序源码 ，我的本机安装位置是在:

        C:\Ruby193\lib\ruby\gems\1.9.1\gems\jekyll-0.11.2\lib\jekyll.rb  
        
在上部一堆 require_all 后面 第 48 行 ，修改了缺省文字编码为 utf-8 ，增加代码：

        if RUBY_VERSION =~ /1.9/
          Encoding.default_external = Encoding::UTF_8
          Encoding.default_internal = Encoding::UTF_8
        end  


#### [参考](https://github.com/mojombo/jekyll/issues/634) 本地调试，jekyll --server 启动后，修改的内容不自动生成，解决办法:

        jekyll --server  --auto
        
        



