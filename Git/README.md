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

## Temporarily switch to a different commit  
If you want to temporarily go back to it, fool around, then come back to where you are, all you have to do is check out the desired commit:

```
# This will detach your HEAD, that is, leave you with no branch checked out:
git checkout 0d1d7fc32
```

Or if you want to make commits while you're there, go ahead and make a new branch while you're at it:

```
git checkout -b old-state 0d1d7fc32
```

To go back to where you were, just check out the branch you were on again. (If you've made changes, as always when switching branches, you'll have to deal with them as appropriate. You could reset to throw them away; you could stash, checkout, stash pop to take them with you; you could commit them to a branch there if you want a branch there.)

## Hard delete unpublished commits
If, on the other hand, you want to really get rid of everything you've done since then, there are two possibilities. One, if you haven't published any of these commits, simply reset:

```
# This will destroy any local modifications.
# Don't do it if you have uncommitted work you want to keep.
git reset --hard 0d1d7fc32

# Alternatively, if there's work to keep:
git stash
git reset --hard 0d1d7fc32
git stash pop
# This saves the modifications, then reapplies that patch after resetting.
# You could get merge conflicts, if you've modified things which were
# changed since the commit you reset to.
```

If you mess up, you've already thrown away your local changes, but you can at least get back to where you were before by resetting again.

## Undo published commits with new commits  
On the other hand, if you've published the work, you probably don't want to reset the branch, since that's effectively rewriting history. In that case, you could indeed revert the commits. With Git, revert has a very specific meaning: create a commit with the reverse patch to cancel it out. This way you don't rewrite any history.

```
# This will create three separate revert commits:
git revert a867b4af 25eee4ca 0766c053

# It also takes ranges. This will revert the last two commits:
git revert HEAD~2..HEAD

#Similarly, you can revert a range of commits using commit hashes:
git revert a867b4af..0766c053 

# Reverting a merge commit
git revert -m 1 <merge_commit_sha>

# To get just one, you could use `rebase -i` to squash them afterwards
# Or, you could do it manually (be sure to do this at top level of the repo)
# get your index and work tree into the desired state, without changing HEAD:
git checkout 0d1d7fc32 .

# Then commit. Be sure and write a good message describing what you just did
git commit
```