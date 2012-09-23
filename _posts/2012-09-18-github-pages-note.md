---
layout: post
title:  GitHub-Pages 建立博客的问题笔记
category: study
---

#### [参考](http://www.360doc.com/content/11/0707/06/2097544_132045287.shtml) GitHub 的证书出了问题，使用 http basic authentication 验证，每次 push 都询问 用户名、口令   
不胜其烦。网上搜到参考链接 终于解决“Git Windows客户端保存用户名与密码”的问题 ，方法如下,在用户主目录下建立 `_netrc` 或 ".netrc"文件，对于 Linux 就是 `~/.netrc` ,对于 Windows 用户就是 PATH 中 HOME 变量指定的目录下的 `_netrc` 文件，本人是在 `C:\Documents and Settings\windows用户名` 下，文件内容如下

    machine github.com
    login *********
    password *******

就是 github 的账号信息存入，问题解决。当然，安全的方式还是利用 ssh 证书。


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
        
#### [参考](http://www.cnblogs.com/heart-runner/archive/2012/02/14/2351136.html) jekyll 无法生成文件。

新加了个 post ，试验 Markdown ，试验长句子， 看到换行还是显示出间隔，试验了一下 Ultraedit 回车换行转换行 ，无法生成了 。
`jekyll --server  --auto` 正常启动，但 _site 目录清空后没有文件生成 ，不启用 auto 程序才报出错误:

        #jekyll --server
        Configuration from E:/githubpages/weimingzhen.github.com/_config.yml
        Building site: E:/githubpages/weimingzhen.github.com -> E:/githubpages/weimingzhen.github.com/_site
        C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/convertible.rb:81:in `rescue in do_layout': undefined method `name' for <Post: posts/study-markdown-note>:Jekyll::Post (NoMethodError)
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/convertible.rb:78:in `do_layout'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/post.rb:189:in `render'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/site.rb:193:in `block in render'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/site.rb:192:in `each'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/site.rb:192:in `render'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/site.rb:40:in `process'
                from C:/Ruby193/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/bin/jekyll:250:in `<top (required)>'
                from C:/Ruby193/bin/jekyll:23:in `load'
                from C:/Ruby193/bin/jekyll:23:in `<main>'

不明其解，网上搜到 [参考](http://www.cnblogs.com/heart-runner/archive/2012/02/14/2351136.html) 文章《诡异的jekyll空格问题》，结合报错提示 posts/study-markdown-note ，问题就出在新加的这个文件，不知哪里格式出了问题。

重新建立文件，写对格式，问题解决。

#### 增加 Textile 格式文件的支持。Post 目录新建 textile 后缀 文章文件。安装推荐的 RedCloth Ruby 包。

    You are missing a library required for Textile. Please run:  
      $ [sudo] gem install RedCloth
      
安装 gem install RedCloth 解决。

     
#### !!! 未解决 增加 Tag 处理

[jekyllbootstrap](http://jekyllbootstrap.com/) jekyll bootstrap  项目有对 Tag 的完备支持。


        



