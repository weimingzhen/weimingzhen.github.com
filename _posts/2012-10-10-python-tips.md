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
        

写入后，并不马上见效，还需要发个消息

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



##### 2. 获取当前启动的 Python 的执行路径    - 相关模块: [sys][] 

        import sys
        print sys.prefix







[os]:http://docs.python.org/release/3.1.5/library/os.html
[sys]:http://docs.python.org/release/3.1.5/library/sys.html
