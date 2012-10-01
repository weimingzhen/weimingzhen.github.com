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
  

  直接使用windows系统自带程序 sc  ，可以 安装 启动 停止 卸载 服务。
  
  
  启动和停止服务均使用 sc 
  
    sc start wmzwebpy
    
    sc stop wmzwebpy
  
  卸载。两种方式 :
  
    sc delete wmzwebpy   #系统需要重新启动才会执行删除任务
  
    instsrv.exe   wmzwebpy   REMOVE   #需要服务停止时才能执行，立刻删除服务


  分别建立 批处理文件


  

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



#### instsrv方式 安装

建立 intall.bat 文件如下：

    instsrv.exe  wmzwebpy  "c:\webpy\srvany.exe"

执行后，服务在注册表位置在

    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy

服务描述为增加 Description 项 ，手动增加之， instsrv 和 sc 都没有设置 Description 的参数
    
srvany.exe 是个通用的服务代理调用程序，设置调用程序的参数:

>新建 Parameters 目录项  
>Parameters 目录下建立如下 字符串项目  
>名称 Application


整个注册表：

    Windows Registry Editor Version 5.00
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy]
    "Type"=dword:00000010
    "Start"=dword:00000002
    "ErrorControl"=dword:00000001
    "ImagePath"=hex(2):63,00,3a,00,5c,00,77,00,65,00,62,00,70,00,79,00,5c,00,73,00,\
      72,00,76,00,61,00,6e,00,79,00,2e,00,65,00,78,00,65,00,00,00
    "DisplayName"="wmzwebpy"
    "ObjectName"="LocalSystem"
    "Description"="weimingzhen webpy example as service."
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Parameters]
    "Application"="D:\\Python27\\pythonw.exe  c:\\webpy\\webmain.py"
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Security]
    "Security"=hex:01,00,14,80,90,00,00,00,9c,00,00,00,14,00,00,00,30,00,00,00,02,\
      00,1c,00,01,00,00,00,02,80,14,00,ff,01,0f,00,01,01,00,00,00,00,00,01,00,00,\
      00,00,02,00,60,00,04,00,00,00,00,00,14,00,fd,01,02,00,01,01,00,00,00,00,00,\
      05,12,00,00,00,00,00,18,00,ff,01,0f,00,01,02,00,00,00,00,00,05,20,00,00,00,\
      20,02,00,00,00,00,14,00,8d,01,02,00,01,01,00,00,00,00,00,05,0b,00,00,00,00,\
      00,18,00,fd,01,02,00,01,02,00,00,00,00,00,05,20,00,00,00,23,02,00,00,01,01,\
      00,00,00,00,00,05,12,00,00,00,01,01,00,00,00,00,00,05,12,00,00,00
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Enum]
    "0"="Root\\LEGACY_WMZWEBPY\\0000"
    "Count"=dword:00000001
    "NextInstance"=dword:00000001
    

	



#### instsrv方式 安装后的卸载

用 instsrv 卸载，要求先停止服务

    c:>instsrv.exe   wmzwebpy   REMOVE
    
    This service is still active.  It must be stopped before it
    can be removed.
    To stop this service, use the Stop button in the Control
    Panel's services applet.
    
需要服务停止时才能执行，执行后，立刻删除服务    
    
sc可以直接卸载

    c:>sc delete wmzwebpy
    [SC] DeleteService SUCCESS    
    
    
但是 sc 的方式完成后，服务仍在运行，只是标为禁用.  
重启系统后，服务被删除

    
    
#### instsrv方式安装后

直接修改 注册表 ImagePath 项目 指向

    由
    c:\webpy\srvany.exe    
    变为
    D:\Python27\pythonw.exe  c:\webpy\webmain.py

启动失败

改为 `D:\Python27\python.exe` 也无法启动，结论

>普通程序无法直接按照服务程序启动 ， 必须 使用 srvany 代理启动



#### sc 方式安装


建立批处理执行：

    sc create wmzwebpy binpath= "c:\webpy\srvany.exe" type= share start= auto displayname= "wmzwebpy"
    
其注册表内容和上述  instsrv方式 有区别，如下:

    Windows Registry Editor Version 5.00
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy]
    "Type"=dword:00000020
    "Start"=dword:00000002
    "ErrorControl"=dword:00000001
    "ImagePath"=hex(2):63,00,3a,00,5c,00,77,00,65,00,62,00,70,00,79,00,5c,00,73,00,\
      72,00,76,00,61,00,6e,00,79,00,2e,00,65,00,78,00,65,00,00,00
    "DisplayName"="wmzwebpy"
    "ObjectName"="LocalSystem"
    
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Security]
    "Security"=hex:01,00,14,80,90,00,00,00,9c,00,00,00,14,00,00,00,30,00,00,00,02,\
      00,1c,00,01,00,00,00,02,80,14,00,ff,01,0f,00,01,01,00,00,00,00,00,01,00,00,\
      00,00,02,00,60,00,04,00,00,00,00,00,14,00,fd,01,02,00,01,01,00,00,00,00,00,\
      05,12,00,00,00,00,00,18,00,ff,01,0f,00,01,02,00,00,00,00,00,05,20,00,00,00,\
      20,02,00,00,00,00,14,00,8d,01,02,00,01,01,00,00,00,00,00,05,0b,00,00,00,00,\
      00,18,00,fd,01,02,00,01,02,00,00,00,00,00,05,20,00,00,00,23,02,00,00,01,01,\
      00,00,00,00,00,05,12,00,00,00,01,01,00,00,00,00,00,05,12,00,00,00
   

相比而言，没有 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Enum` 子目录项  
`Type=dword:00000020`  而前面是  `00000010`

增加 Parameters 项目后，启动失败

修改注册表为完全一致，能够启动
再改回type 为 20 ，能启动
删除 enum ，仍然可以启动


再重新安装，还是不行，但是执行后， Enum 自动出现  

多次重启动，重新导入 instsrv 方式产生的注册表，最后可以启动了

>结论: sc 方式安装服务 似乎很不可靠 。安装完服务后，重启动下可能会好一点。


#### 最佳安装服务方式

1. instsrv安装服务

        instsrv.exe  wmzwebpy  "c:\webpy\srvany.exe"
      
2. 导入或设置注册表中启动文件项目，如reg文件:

        Windows Registry Editor Version 5.00
        
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmzwebpy\Parameters]
        "Application"="D:\\Python27\\pythonw.exe  c:\\webpy\\webmain.py"


3. 启动服务


#### 最佳卸载服务方式          


    sc stop wmzwebpy
    instsrv.exe   wmzwebpy   REMOVE


以上方式，反复试验，比较稳定。



#### 查询服务状态

执行命令:

    C:\sc query wmzwebpy

运行中的状态：
    
    SERVICE_NAME: wmzwebpy
            TYPE               : 10  WIN32_OWN_PROCESS
            STATE              : 4  RUNNING
                                    (STOPPABLE,PAUSABLE,ACCEPTS_SHUTDOWN)
            WIN32_EXIT_CODE    : 0  (0x0)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x0
            


暂停时的状态：

    SERVICE_NAME: wmzwebpy
            TYPE               : 10  WIN32_OWN_PROCESS
            STATE              : 7  PAUSED
                                    (STOPPABLE,PAUSABLE,ACCEPTS_SHUTDOWN)
            WIN32_EXIT_CODE    : 0  (0x0)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x0
    
    

停止时的状态;

    SERVICE_NAME: wmzwebpy
            TYPE               : 10  WIN32_OWN_PROCESS
            STATE              : 1  STOPPED
                                    (NOT_STOPPABLE,NOT_PAUSABLE,IGNORES_SHUTDOWN)
            WIN32_EXIT_CODE    : 0  (0x0)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x0
    
刚安装完成时候的状态：

    SERVICE_NAME: wmzwebpy
            TYPE               : 10  WIN32_OWN_PROCESS
            STATE              : 1  STOPPED
                                    (NOT_STOPPABLE,NOT_PAUSABLE,IGNORES_SHUTDOWN)
            WIN32_EXIT_CODE    : 1077       (0x435)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x0
    

上述两个状态中，SERVICE_EXIT_CODE的状态是不同的。

服务不存在时候的状态：

    [SC] EnumQueryServicesStatus:OpenService FAILED 1060:
        






            





            