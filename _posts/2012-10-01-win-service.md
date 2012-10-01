---
layout: post
title: 实战设置程序为 Windows 服务
category: study
---


####实验环境

  Python 环境1 - 命令行下测试执行显示输出结果 python.exe
  
      D:\Python27\python.exe

  Python 环境2 - 服务程序指向不显示输出结果的 pythonw.exe
  
      D:\Python27\pythonw.exe

  实验程序
      
      c:\webpy\webmain.py

  用到的两个工具程序
  
  [instsrv 服务安装程序](/exetool/instsrv.exe)   
  [srvany 启动代理程序](/exetool/srvany.exe)   
  


####测试服务程序

首先，要保证需要启动的程序能够在服务指定的环境下正常启动。  
一开始实验启动 Python程序，总是在程序启动的目录中，一切正常，  
后来实验，又在默认系统用户目录中，其中一切不知何时安装了一个需要的模块；
结果手动命令行正常，一到服务就完了。

> 在命令行下，任选不同盘符的不同目录，多试验程序，看能否正常启动，才能作为服务指定启动的程序。  
> 如本实验程序 任意目录下 执行 `D:\Python27\python.exe c:\webpy\webmain.py`  均能正常启动为止  
> 可能出问题的地方  
> * 程序中读取当前目录，服务的当前目录是不同的  
> * 导入的模块环境  
> 服务启动程序，程序中一旦出错，只会报告服务的启动错误，无法查看问题所在，所以要充分实验。





