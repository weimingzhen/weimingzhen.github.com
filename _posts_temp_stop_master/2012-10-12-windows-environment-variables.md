---
layout: post
title: 操作系统环境变量操作 - Python 常用小技巧积累系列
category: study
---

相关模块: [os][] 

Windows 环境变量的涉及的问题没想到这么多,目前看有如下：

1. 读: 'os.environ.get' 这个非常简单。   

2. 写: 情况较复杂:

>结论：程序中设置环境变量，还没有立刻能影响当前命令窗口的好办法。同一个命令窗口顺序执行两个 python 程序 ，第一个程序中改变的
>环境变量，第二个程序中无法读到。 直接读注册表中的相应值可能也是个蹩脚的办法。

命令行下，结合交互界面，主要使用 set 和 系统属性对话框。    
Windows 7 开始有 setx ，似乎能全面解决问题，未详细试验。  
[官方文档](http://technet.microsoft.com/zh-cn/library/cc755104)提到:  
Variables set with setx variables are available in future command windows only, not in the current command window.     
看来仍无法在当前命令窗口起作用。


|程序中临时起作用|

> 写  基本。调用时可控制被调程序的环境。

|系统重启后 **见效** | 新开cmd **无效** | 当前cmd **无效** |

> 写 stepA: 写入项目到对应注册表中。


|新开cmd **见效** | 当前cmd **无效** |

> 写 stepB: stepA 后再广播  WM_SETTINGCHANGE 消息。效果类似系统交互界面修改环境变量。

|新开cmd **见效** | 当前cmd **见效** |

> 写 step?: 还未找到合适方法。 

---

* 读

读 os.environ.get

    import os
    print os.environ.get("wmzapp")

* 写:

|程序中临时起作用|

只能在程序中临时起作用的方法 ，调用时可控制被调程序的环境。'os.putenv(varname, value)' 或 直接操作字典 'os.environ'

    import os
    os.environ["wmzapp"]="c:\\wmzapp"
    os.putenv("wmzapp", "c:\\wmzapp")

|系统重启后 **见效** | 新开cmd **无效** | 当前cmd **无效** |

写 stepA , 写入项目到对应注册表中
            
利用系统操作注册表的命令 `reg`

    import os
    #当前用户
    os.system('reg add "HKEY_CURRENT_USER\\Environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')        
    #整个系统
    os.system('reg add "HKLM\system\currentcontrolset\control\session manager\environment" /v "wmzapp" /d "c:\\wmzapp" /t REG_SZ ')
        
|新开cmd **见效** | 当前cmd **无效** |

写 stepB , stepA 后 还需要发消息，

写入后，并不马上见效，还需要发个消息

    import ctypes
    HWND_BROADCAST = 0xFFFF
    WM_SETTINGCHANGE = 0x1A
    SMTO_ABORTIFHUNG = 0x0002
    result = ctypes.c_long()
    SendMessageTimeoutW = ctypes.windll.user32.SendMessageTimeoutW
    SendMessageTimeoutW(HWND_BROADCAST, WM_SETTINGCHANGE, 0, u'Environment', SMTO_ABORTIFHUNG, 5000, ctypes.byref(result))
        
|新开cmd **见效** | 当前cmd **见效** |

还未找到合适方法 。 

借鉴文章：vbs 方法 [Is there a command to refresh environment variables from the command prompt in Windows?](http://stackoverflow.com/questions/171588/is-there-a-command-to-refresh-environment-variables-from-the-command-prompt-in-w)

| 上述办法仍然是一个纯命令行的办法，动态写一个 BAT ，再调用 BAT 

失败1：
        
本人的测试 ，当前的 cmd 窗口还是不管用, 再加?：

    os.system("set wmzapp=c:\\wmzapp")         
        
上述命令，调用不成功， `os.system("set")`  就可以 。 
当然命令行下 ，执行 "set wmzapp=c:\\wmzapp" 是有效的 ， 能且仅能修改当前 cmd 窗口的环境变。
        

---

写入的 StepA StepB  参考下面这些资料:

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



[os]:http://docs.python.org/release/3.1.5/library/os.html


