---
layout: post
title: Python 常用小技巧积累
category: study
---

### 目录

* 普通内容  
1. [windows \(linux\) 环境变量](#N1)  
2. [获取当前启动的 Python 的执行路径](#N2)

* 附录A 工作中需要的大型需求  
1. [二维码识别和编码](#A1)

### 普通内容

##### <span id="N1"/> 1. windows \(linux\) 环境变量    - 相关模块: [os][] 

读 os.environ.get

        import os
        print os.environ.get("wmzapp")
            
写  , 没有直接的函数，只能利用系统操作注册表的命令 `reg`

        import os
        #当前用户
        os.system('reg add "HKEY_CURRENT_USER\\Environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')        
        #整个系统
        os.system('reg add "HKLM\system\currentcontrolset\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        

写入后，并不马上见效，还需要发个消息

        import ctypes
        HWND_BROADCAST = 0xFFFF
        WM_SETTINGCHANGE = 0x1A
        SMTO_ABORTIFHUNG = 0x0002
        result = ctypes.c_long()
        SendMessageTimeoutW = ctypes.windll.user32.SendMessageTimeoutW
        SendMessageTimeoutW(HWND_BROADCAST, WM_SETTINGCHANGE, 0, u'Environment', SMTO_ABORTIFHUNG, 5000, ctypes.byref(result))
        
本人的测试 ，当前的 cmd 窗口还是不管用, 再加?：

        os.system("set wmzapp=c:\\wmzapp")        

参考下面这两个网页 [配置环境变量并立即生效](http://www.gxnnsz.com/forum.php?mod=viewthread&tid=13830)   [Modify `PATH` environment variable globally and permanently using Python](http://stackoverflow.com/questions/7914505/modify-path-environment-variable-globally-and-permanently-using-python)

需要随后发出 `WM_SETTINGCHANGE` 消息。

用C++的例子

    // 使设置立即生效，下面两种法都可以
    SendMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,(LPARAM)TEXT("Environment"));
    //SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, (LPARAM)"Environment", SMTO_ABORTIFHUNG, 5000, 0);


后面 stackoverflow 上的帖子非常好，有一个完备的例子 (设置代理服务器变量) . 另一篇相关的 stackovweflow 帖子提到一个奇怪现象:WM_SETTINGCHANGE后许多环境变量丢失了，无其他人回答，录以备忘：[why does python's win32gui.SendMessageTimeout fail and delete most of my Environment Variables?](http://stackoverflow.com/questions/10323300/why-does-pythons-win32gui-sendmessagetimeout-fail-and-delete-most-of-my-environ)

    import _winreg as winreg
    import ctypes
    
    ENV_HTTP_PROXY = u'http://87.254.212.121:8080'
    
    
    class Registry(object):
        def __init__(self, key_location, key_path):
            self.reg_key = winreg.OpenKey(key_location, key_path, 0, winreg.KEY_ALL_ACCESS)
    
        def set_key(self, name, value):
            try:
                _, reg_type = winreg.QueryValueEx(self.reg_key, name)
            except WindowsError:
                # If the value does not exists yet, we (guess) use a string as the
                # reg_type
                reg_type = winreg.REG_SZ
            winreg.SetValueEx(self.reg_key, name, 0, reg_type, value)
    
        def delete_key(self, name):
            try:
                winreg.DeleteValue(self.reg_key, name)
            except WindowsError:
                # Ignores if the key value doesn't exists
                pass
    
    
    
    class EnvironmentVariables(Registry):
        """
        Configures the HTTP_PROXY environment variable, it's used by the PIP proxy
        """
    
        def __init__(self):
            super(EnvironmentVariables, self).__init__(winreg.HKEY_LOCAL_MACHINE,
                                                       r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment')
    
        def on(self):
            self.set_key('HTTP_PROXY', ENV_HTTP_PROXY)
            self.refresh()
    
        def off(self):
            self.delete_key('HTTP_PROXY')
            self.refresh()
    
        def refresh(self):
            HWND_BROADCAST = 0xFFFF
            WM_SETTINGCHANGE = 0x1A
    
            SMTO_ABORTIFHUNG = 0x0002
    
            result = ctypes.c_long()
            SendMessageTimeoutW = ctypes.windll.user32.SendMessageTimeoutW
            SendMessageTimeoutW(HWND_BROADCAST, WM_SETTINGCHANGE, 0, u'Environment', SMTO_ABORTIFHUNG, 5000, ctypes.byref(result));
        
        
                    



只能在程序中临时起作用的方法 ， 调用时可控制被调程序的环境 os.putenv(varname, value)

        import os
        os.environ["wmzapp"]="c:\\wmzapp"



##### 2. <span id="N2"/> 获取当前启动的 Python 的执行路径    - 相关模块: [sys][] 

        import sys
        print sys.prefix







[os]:http://docs.python.org/release/3.1.5/library/os.html
[sys]:http://docs.python.org/release/3.1.5/library/sys.html



  
  
  
  
---

  
### 附录A 工作中需要的大型需求，为深入研究。


#####  <span id="A1" /> 1. 二维码识别和编码 （主要是识别的比较难找）

stackoverflow 上最有价值的一个  [帖子:QR code \(2D barcode\) coding and decoding algorithms?](http://stackoverflow.com/questions/231741/qr-code-2d-barcode-coding-and-decoding-algorithms)

找到的可用的  [Zbar](http://zbar.sourceforge.net/) 

一篇有价值的中文内容, [开源二维码QR CODE编码/解码\(识别\)库](http://www.360doc.com/content/10/1215/16/1378815_78394188.shtml)  
提到一个纯 C++的 库  [libdecodeqr](http://trac.koka-in.org/libdecodeqr) 

stackoverflow 另一个帮助 不大的 [qrcode generator using python for windows](http://stackoverflow.com/questions/3888125/qrcode-generator-using-python-for-windows)

上述帖子中提到的  [PyQRNative](http://code.google.com/p/pyqrnative/source/browse/trunk/pyqrnative/src/PyQRNative.py) 似乎仅是生成

