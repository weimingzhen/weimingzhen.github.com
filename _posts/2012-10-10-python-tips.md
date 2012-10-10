---
layout: post
title: Python 常用小技巧积累
category: study
---


##### 1. windows \(linux\) 环境变量    - 相关模块: [os][] 

读 os.environ.get

        import os
        print os.environ.get("wmzapp")
            
写  , 没有直接的函数，只能利用系统操作注册表的命令 `reg`

        import os
        #当前用户
        os.system('reg add "HKEY_CURRENT_USER\\Environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')        
        #整个系统
        os.system('reg add "HKLM\system\currentcontrolset\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        
        """
        os.system('reg add "HKLM\system\controlset\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        os.system('reg add "HKLM\system\controlset001\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        os.system('reg add "HKLM\system\controlset002\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        """
只能在程序中临时起作用的方法 ， 调用时可控制被调程序的环境 os.putenv(varname, value)

        import os
        os.environ["wmzapp"]="c:\\wmzapp"



##### 2. 获取当前启动的 Python 的执行路径    - 相关模块: [sys][] 

        import sys
        print sys.prefix







[os]:http://docs.python.org/release/3.1.5/library/os.html
[sys]:http://docs.python.org/release/3.1.5/library/sys.html
