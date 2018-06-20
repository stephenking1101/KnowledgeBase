Basic Linux Commands 
----------------------------------- 
1. User information. 
id [<user login>] 
finger <user login> 
passwd 

2. Viewing host information. 
uname -a 
free 
df -h 
top (using "q" to quite) 





5. Permissions 


chown <user login> file/dir 
chgrp <group name> file/dir 
chmod <permissions> file/dir 

6. Processes 
ps aux 
ps -ef 
kill [-9] <process id> 


8. vi/vim 
Command mode / Editing mode 
Command mode: h(left), j(down), k(up), l(right) 
from command mode to editing mode: i, a, o, O 
from editing mode to command mode: ESC 

wq - write and quit 
wq! - force write and quit 
q! - force quite 

In command mode: 
x     - delete one character 
r     - replace one character 
dd    - delete one line 
gg    - go to the beginning of the file 
G     - go to the end of the file 
yy    - copy 
p     - paste 

5x    - delete 5 characters 
5dd   - delete 5 lines 
10G   - Jump 10 lines 

u     - undo the previous operation 


uptime (check the system up running time since when, # user connecting) 

TAR 
tar -cvf <resultname.tar> <files_to_be_package> 
c = compress 
v = Verbose. Output the name of each folders / file recursivly 
f = File. Use the tarfile argument as the name of the tarfile 


tar -xvf file_test.20110810.tar 
(this will extract all the folder and its content packaged inside this TAR file) 
-> -x = extract 

umask 022 

find /build -maxdepth 1 -type d -cmin +600 -print |grep ^/build/_ >> /build/cleanup_logs/cleanup_10_12_12.log
for i in `find /build -maxdepth 1 -type d -cmin +600 -print |grep ^/build/_`; do rm -rf $i; done

========== 
############################################################ 
###Cursor Movement 
############################################################ 
[Key]         [Action] 
Ctrl-a      Move cursor to the beginning of the line. 
Ctrl-e      Move cursor to the end of the line. 
Ctrl-f      Move cursor forward one character; same as the right arrow key. 
Ctrl-b      Move cursor backward one character; same as the left arrow key. 
Alt-f       Move cursor forward one word. 
Alt-b       Move cursor backward one word. 
Ctrl-l      Clear the screen and move the cursor to the 
Ctrl-d      Delete the character at the cursor location 
Ctrl-t      Transpose (exchange) the character at the cursor location with the one preceding it. 
Alt-t       Transpose the word at the cursor location with the one preceding it. 
Alt-l       Convert the characters from the cursor location to the end of the word to lowercase. 
Alt-u       Convert the characters from the cursor location to the end of the word to uppercase. 
Ctrl-k      Kill text from the cursor location to the end of line. 
Ctrl-u      Kill text from the cursor location to the beginning of the line. 
Alt-d       Kill text from the cursor location to the end of the current word. 
Alt- 
Backspace   Kill text from the cursor location to the beginning of the current word. If the cursor is at the beginning of a word, kill the previous word. 
Ctrl-y      Yank text from the kill-ring and insert it at the cursor location. 

############################################################ 
###man - Getting help. 
###info – Display a command's info entry 
############################################################ 
man <target command> 
man -k <keyword to check> 
info <target command> 
############################################################ 
###pwd - Print name of current working directory 
###cd - Change directory 
############################################################ 
pwd 
cd <dir> 
############################################################ 
###less – View file contents 
############################################################ 
less <file> 
[Command]             [Action] 
Page Up or b | Scroll back one page 
Page Down or | space Scroll forward one page 
Up Arrow     | Scroll up one line 
Down Arrow   | Scroll down one line 
/characters  | Search forward to the next occurrence of characters 
n            | Search for the next occurrence of the previous search 
h            | Display help screen 
q            | Quit less 
############################################################ 
###cp – Copy files and directories 
###mv – Move/rename files and directories 
###mkdir – Create directories 
###rmdir – Remove directories 
###rm – Remove files and directories 
###ln – Create hard and symbolic links 
############################################################ 
cp <original file> <target file> 
cp -u *.html destination 
#-u, --update 
#copy  only  when  the  SOURCE file is newer than the destination 
#file or when the destination file is missing 
#linux 从一台机器复制文件到另一台linux机器上去 
本机IP：192.168.138.150 

要传送的IP地址为：192.168.138.151 

任务：拷贝/etc/ha.d/ldirectord.cf文件到151机器上，地址为：/etc/ha.d 

在本机上操作，使用命令scp： 

scp /etc/ha.d/ldirectord.cf root@192.168.138.151:/etc/ha.d 
#scp –r 本机文件路径（可多个）  root@远程IP：远程路径 
一、将本地文件拷贝到远程机器： 

scp /home/administrator/news.txt root@192.168.6.129:/etc/squid 

其中： 

/home/administrator/      本地文件的绝对路径 
news.txt                          要复制到服务器上的本地文件 
root                                 通过root用户登录到远程服务器（也可以使用其他拥有同等权限的用户） 
192.168.6.129                远程服务器的ip地址（也可以使用域名或机器名） 
/etc/squid                       将本地文件复制到位于远程服务器上的路径 

  

二、将远程服务器上的文件复制到本机 

#scp remote@www.abc.com:/usr/local/sin.sh /home/administrator 

remote                       通过remote用户登录到远程服务器（也可以使用其他拥有同等权限的用户） 
www.abc.com              远程服务器的域名（当然也可以使用该服务器ip地址） 
/usr/local/sin.sh           欲复制到本机的位于远程服务器上的文件 
/home/administrator  将远程文件复制到本地的绝对路径 

  

注意两点： 
1.如果远程服务器防火墙有特殊限制，scp便要走特殊端口，具体用什么端口视情况而定，命令格式如下： 
#scp -p 4588 remote@www.abc.com:/usr/local/sin.sh /home/administrator 
2.使用scp要注意所使用的用户是否具有可读取远程服务器相应文件的权限。 


[Wildcard]    [Meaning] 
*     Matches any characters 
?     Matches any single character 
[characters]  Matches any character that is a member of the set characters 
[!characters]  Matches any character that is not a member of the set characters 
[[:class:]]  Matches any character that is a member of the specified class 
mv <original file/dir> <target file/dir> 
mkdir <dir> 
rmdir <dir> 
rm <file> 
rm -rf destination 
-r, --recursive Recursively delete directories. This means that if a 
      directory being deleted has subdirectories, delete them 
      too. To delete a directory, this option must be 
      specified. 
-f, --force Ignore nonexistent files and do not prompt. This 
   overrides the --interactive option. 
ln -s fun fun-sym 
# default: Creating Hard Links, means create another file/folder name to a file/folder(data part) 
# -s :Creating Symbolic Links, which just a reference to a file/folder's name. When you delete a link, it is 
#     the link that is deleted, not the target 
############################################################ 
###file – Determine file type 
############################################################ 
file picture.jpg 
############################################################ 
###alias - Creating Your Own Commands 
############################################################ 
alias foo='cd /usr; ls; cd -' 
############################################################ 
###which – Display An Executable's Location 
############################################################ 
which ls 
############################################################ 
###ls – List directory contents 
############################################################ 
ls -l <file/dir> 
rwx: Read, Write, Execute 
###Redirect standard ouput and error: 
ls -l /bin/usr > ls-output.txt 2>&1 
#First we redirect standard output to the file ls-output.txt 
#and then we redirect file descriptor two (standard error) to file descriptor one (standard output) using the notation 2>&1 
ls -l /bin/usr &> ls-output.txt 
#In this example, we use the single notation &> to redirect both standard output and 
#standard error to the file ls-output.txt 
ls -l /bin/usr 2> /dev/null 
#To suppress error messages from a command, do this by redirecting output to a special file called "/dev/null" 
#Use less to display, page-by-page 
ls -l /usr/bin | less 
ls /bin /usr/bin | sort | less 
#remove any duplicates from the output 
ls /bin /usr/bin | sort | uniq | less 
#-rw-rw-r-- 
#The first ten characters of the listing are the file attributes. The first of these characters is 
#the file type. 
[Attribute]   [File Type] 
-           A regular file. 
d           A directory. 
l           A symbolic link. Notice that with symbolic links, the remaining file 
            attributes are always “rwxrwxrwx” and are dummy values. The 
            real file attributes are those of the file the symbolic link points to. 
c           A character special file. This file type refers to a device that 
            handles data as a stream of bytes, such as a terminal or modem. 
b           A block special file. This file type refers to a device that handles 
            data in blocks, such as a hard drive or CD-ROM drive. 
#The remaining nine characters of the file attributes         
#Owner   Group   World 
#rwx     rwx     rwx 
############################################################ 
###wc – Print Line, Word, And Byte Counts 
############################################################ 
wc output.txt 
#Use wc (word count) command to count the line 
ls /bin /usr/bin | sort | uniq | wc -l 
############################################################ 
###cat – Concatenate Files 
############################################################ 
#Create short text files from input(type from keyboard) -- cat copies standard input to standard output, type Ctrl-d at the end 
cat > lazy_dog.txt 
############################################################ 
###grep – Print Lines Matching A Pattern 
############################################################ 
grep pattern [file...] 
When grep encounters a "pattern" in the file, it prints out the lines containing it. -- "-i" ignore case, "-v" which tells grep to only print lines that do not match the pattern. 
############################################################ 
###head / tail – Print First / Last Part Of Files 
############################################################ 
#By default, both commands print ten lines of text, but this can be adjusted with the "-n" option 
head -n 5 ls-output.txt 
tail -n 5 ls-output.txt 
#tail has an option which allows you to view files in real-time. With "-f" option, tail continues to monitor the file and when new lines are appended, until you type Ctrl-c. 
tail -f /var/log/messages 
############################################################ 
###tee – Read From Stdin And Output To Stdout And Files 
############################################################ 
#tee to capture the entire directory listing to the file ls.txt before grep filters the pipeline's contents 
ls /usr/bin | tee ls.txt | grep zip 

############################################################ 
###echo – Display a line of text 
############################################################ 
#Pathname Expansion: * is the wildcard 
echo /usr/*/share 
#show the environment variable. list the variables use: printenv | less 
echo $USER 
#reveal hidden files in current folder 
ls -d .[!.]?* 
ls -a 
#display home directory of the named user: e.g. /home/root 
echo ~ 
#Arithmetic expansion: $((expression)), display 4 in following command 
echo $((2 + 2)) 
#display Number_1 Number_2 Number_3 Number_4 Number_5 
echo Number_{1..5} 
#Command Substitution: list the file from the result by running 'which cp' command 
ls -l $(which cp) 
#suppress word-splitting, can show newlines use doble quotes 
echo "$(cal)" 
#suppress all expansions using single quotes 
echo '$(cal)' 
#Escape 
sleep 10; echo -e "Time's up\a" 
[Escape Sequence]   [Meaning'] 
\a                 Bell ("Alert" - causes the computer to beep) 
\b                 Backspace 
\n                 Newline. On Unix-like systems, this produces a linefeed. 
\r                 Carriage return 
\t                 Tab 
############################################################ 
###clear – Clear the screen 
############################################################ 
############################################################ 
###history – Display the contents of the history list 
############################################################ 
history | less 
!88 
#bash will expand “!88” into the contents of the eighty-eighth line in the history list. 

############################################################ 
###id – Display user identity 
############################################################ 
#User accounts are defined in the /etc/passwd file and groups are defined in the /etc/group file. 
#/etc/shadow which holds information about the user's password 

############################################################ 
###chmod – Change a file's mode (permissions)
############################################################ 
chmod 600 foo.txt
#Octal   Binary      File Mode
#0       000         ---
#1       001         --x
#2       010         -w-
#3       011         -wx
#4       100         r--
#5       101         r-x
#6       110         rw-
#7       111         rwx

############################################################ 
###umask – Set the default file permissions 
############################################################ 
umask 0022
#Original file mode|  --- rw- rw- rw-
#Mask              |  000 000 010 010
#Result            |  --- rw- r-- r--

############################################################ 
###su – Run a shell as another user 
############################################################ 

###sudo – Execute a command as another user 
###chown – Change a file's owner 
###chgrp – Change a file's group ownership 
###passwd – Change a user's password 
 ---118 
du -sh /ds_build/* 
du -h ./CCRC 

mount -t smbfs -o username=<username> -o password=<password> /<IP Address of windows>/<share name> /<the dir on the linux box which you want to mount> 
SHELL 
---------------------------------------------- 
#!/bin/sh 
START_DIR=`dirname "$0"` 
cd "$START_DIR" 
# For Mac OS X (unsupported, but used by developers) 
if [ `uname` = Darwin ]; 
  then 
    JRE_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.5.0/Home 
  else 
    JRE_HOME=`pwd`/jre 
fi 
export JRE_HOME 
CATALINA_HOME=`pwd`/tomcat 
export CATALINA_HOME 
JAVA_OPTS= 
export JAVA_OPTS 
$CATALINA_HOME/bin/shutdown.sh 
---------------------------------------------- 
