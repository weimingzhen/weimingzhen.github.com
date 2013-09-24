---
layout: post
title: git 常用命令学习
category: study
---

**obj**

> 库中对象均有 ID   
> 库中某文件 分支名:文件名  提交ID:文件名  
> 暂存区某文件 :文件名  
> 分支名 tag名 master HEAD  
> 某提交对应的树对象 某提交ID^^{tree}  
> 某提交的父提交 某提交ID~<n>  如 HEAD~1 HEAD~2 上次 和 上上次提交  
> 某提交的父提交 某提交ID^^  = 某提交ID~1    某提交ID^^^^  = 某提交ID~2  测试与书中不一致 需要两个 ^ 才能出书中 1个的 效果
> 如 父提交 有多个 ，比如合并而来 可用  某提交ID^^+计数  如  HEAD^^2 上次提交的第二个父提交  HEAD^^^^4 上上次提交的第4个父提交


**常见操作**

> 工作区 -> 暂存区 git add  <file>  
> 暂存区 -> 版本库 git commit  
> 暂存区 -> 工作区 git checkout -- <file>
> 版本库 -> 暂存区 git reset 版本分支
> 版本库 -> 暂存区 -> 工作区 git checkout 版本分支 <file>
> 暂存区 擦除文件 git rm --cached <file>
 


git cat-file obj

> **git cat-file -p obj**  
> **显示对象原样 可计算sha1 值 git cat-file obj-type obj**   
> -p pretty打印 print   
> -s 查询 size  
> -t 查询 type  
> git cat-file tag tagobj

git rev-parse  obj
git rev-list

> 显示对象的 sha1 的 ID  
> **获取某文件ID  git rev-parse master:README git rev-parse 3e75:README** 

git stash

> 暂存区及工作区备份，恢复状态到 checkout 当前 版本库
> --apply   

git status  

> 查看工作区和中间区情况 MM  中间区与版本库 工作区与中间区  
> -s  精简格式  
> -b 显示当前工作分支  

git show obj

> -s
> --pretty =fuller,raw,online

git log obj  

> --stat
> --graph
> --pretty =fuller,raw,online
> --oneline 精简的 每行1个的 提交历史显示


git ls-tree tree_obj  -l 显示大小   
git ls-file -s  obj   

git commit  --amend  重新编辑最后一次提交 --allow-empty  --reset-author  

git diff        比较  工作区 和 暂存区  
git diff HEAD   比较  工作区 和 当前库分支  
git --cached    比较  暂存区 和 当前库分支  
 
git write-tree  将暂存区的树结构写入对象库，返回对应的 tree sha1 ID

