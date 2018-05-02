# Basic operations

## Clone a repository

  $ git clone ssh://[user_id]@gerrit.ericsson.se:29418/[repo_name] 

## Switch branch

  $ git checkout [branch_name]
 
## Add or delete file(s)

  $ git add [dir]    #Include everything in [dir]    
  $ git add path/to/file     
  $ git rm path/to/file    
 
## Rename or move file(s)

  $ git mv [file1/dir1] [file2/dir2]

## Commit change

  $ git commit -m "xxxx"    
  $ git status    
  $ git push    

 
## Merge branch

  #Merge branch2 into branch1    
  $ git checkout branch2; git pull    
  $ git checkout branch1; git pull    
  $ git merge branch2    

  #To undo the change    
  $ git reset --hard HEAD    

  #To reset a file back to an old commit    
  $ git reset [commit-id] [path/to/file]  

 
## Fetch latest commits of all branches

  $ git fetch --all    
  or    
  $ git remote update    

Fetch operation will not merge commits into local branch.

* Others

    $ git tag [tag_name]    #To create a local tag     
    $ git branch [branch_name]    #To create a local branch      
    $ git grep "xxxx"    #Very quick to search a string     

 
* Git update

    Because there’s some files modified in the workspace, use stash to hold on it.   

    $ git stash    
    $ git pull   
    $ git stash pop    

## git config --global alias.update '!git stash && git pull && git stash pop', you can create a alias to simply the typing with git update.

## Generate SSH key

For Linux and Windows Git bash:  
  $ ssh-keygen -t rsa  
  $ cd ~/.ssh  
  $ cp id_rsa.pub authorized_keys  

## 同步fork后的项目

* 添加项目A的远程仓库地址到upstream  
git remote add upstream <你朋友项目A的仓库地址>

* 把项目A的更新来到本地的upstream里  
git fetch upstream

* 切换到你自己想要merge的分支，这里我用举例：master  
git checkout master

* merge项目A的更新到你的branch  
git merge upstream/master