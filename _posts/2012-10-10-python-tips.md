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

