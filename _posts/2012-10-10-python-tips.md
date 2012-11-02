---
layout: post
title: Python 常用小技巧积累
category: study
---



### 目录

---

* 普通内容  
1. [windows \(linux\) 环境变量](#N1)  
2. [获取当前启动的 Python 的执行路径](#N2)

* 附录A 工作中需要的大型需求  
1. [二维码识别和编码](#A1)

###### |

### 普通内容

---

##### 1. <span id="N1"/> windows \(linux\) 环境变量    - 相关模块: [os][] 

本部分情况越看发现越复杂，另文详述了： [操作系统环境变量操作](windows-environment-variables.html)

##### 2. <span id="N2"/> 获取当前启动的 Python 的执行路径    - 相关模块: [sys][] 

        import sys
        print sys.prefix


[os]:http://docs.python.org/release/3.1.5/library/os.html
[sys]:http://docs.python.org/release/3.1.5/library/sys.html

##### 3. <span id="N3"/> 获取当前启动的Python文件路径

存储在 `__file__`  中  
一般情况下执行 `.py` 文件 `__file__` 存储的就是 全路径  
但在程序目录中如下执行  

假定如下python程序 hello.py:

    print __file__
    
那么，直接执行

    c:\app\bin>hello.py
    输出
    c:\app\bin>hello.py
    
如果执行
    
    c:\app\bin>python  hello.py
    输出
    hello.py    
    
结论： `__file__`  就是传给 python 执行程序的 文件名参数, 并不一定是全路径名 ，需要特别注意！。

> 是否可以认为 没有全路径的 '__file__' 则当前路径就是 py 所在的目录呢？先这么默认吧。

##### 4. <span id="N4"/> 打印异常信息

        import traceback
        exc_info = sys.exc_info()
        traceback.print_exception(*exc_info)

traceback 中对此做了包装可以直接使用，其实也是调用 上面这些内容

        import traceback
        traceback.print_exc(file=fp)
        
file=fp 可以给一个文件句柄，将错误打入文件中，也可以不给，直接打印屏幕。如:

        import traceback
        traceback.print_exc()

##### 5. <span id="N5"/> 设置 webpy 对静态文件的处理方式

[借鉴 stackoverflow 文章]（http://stackoverflow.com/questions/6960295/changing-the-static-directory-path-in-webpy）

        import web
        import os
        import urllib
        import posixpath
        
        urls = ("/.*", "hello")
        app = web.application(urls, globals())
        
        class hello:
            def GET(self):
                return 'Hello, world!'
        
        
        class StaticMiddleware:
            """WSGI middleware for serving static files."""
            def __init__(self, app, prefix='/static/', root_path='/foo/bar/'):
                self.app = app
                self.prefix = prefix
                self.root_path = root_path
        
            def __call__(self, environ, start_response):
                path = environ.get('PATH_INFO', '')
                path = self.normpath(path)
        
                if path.startswith(self.prefix):
                    environ["PATH_INFO"] = os.path.join(self.root_path, web.lstrips(path, self.prefix))
                    return web.httpserver.StaticApp(environ, start_response)
                else:
                    return self.app(environ, start_response)
        
            def normpath(self, path):
                path2 = posixpath.normpath(urllib.unquote(path))
                if path.endswith("/"):
                    path2 += "/"
                return path2
        
        
        if __name__ == "__main__":
            wsgifunc = app.wsgifunc()
            wsgifunc = StaticMiddleware(wsgifunc)
            wsgifunc = web.httpserver.LogMiddleware(wsgifunc)
            server = web.httpserver.WSGIServer(("0.0.0.0", 8080), wsgifunc)
            print "http://%s:%d/" % ("0.0.0.0", 8080)
            try:
                server.start()
            except KeyboardInterrupt:
                server.stop()         


###### |

### 附录A 工作中需要的大型需求，为深入研究。

---

#####  <span id="A1" /> 1. 二维码识别和编码 （主要是识别的比较难找）

stackoverflow 上最有价值的一个  [帖子:QR code \(2D barcode\) coding and decoding algorithms?](http://stackoverflow.com/questions/231741/qr-code-2d-barcode-coding-and-decoding-algorithms)

找到的可用的  [Zbar](http://zbar.sourceforge.net/) 

一篇有价值的中文内容, [开源二维码QR CODE编码/解码\(识别\)库](http://www.360doc.com/content/10/1215/16/1378815_78394188.shtml)  
提到一个纯 C++的 库  [libdecodeqr](http://trac.koka-in.org/libdecodeqr) 

stackoverflow 另一个帮助 不大的 [qrcode generator using python for windows](http://stackoverflow.com/questions/3888125/qrcode-generator-using-python-for-windows)

上述帖子中提到的  [PyQRNative](http://code.google.com/p/pyqrnative/source/browse/trunk/pyqrnative/src/PyQRNative.py) 似乎仅是生成

