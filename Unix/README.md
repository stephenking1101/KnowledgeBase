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
###info �C Display a command's info entry 
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
###less �C View file contents 
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
###cp �C Copy files and directories 
###mv �C Move/rename files and directories 
###mkdir �C Create directories 
###rmdir �C Remove directories 
###rm �C Remove files and directories 
###ln �C Create hard and symbolic links 
############################################################ 
cp <original file> <target file> 
cp -u *.html destination 
#-u, --update 
#copy  only  when  the  SOURCE file is newer than the destination 
#file or when the destination file is missing 
#linux ��һ̨���������ļ�����һ̨linux������ȥ 
����IP��192.168.138.150 

Ҫ���͵�IP��ַΪ��192.168.138.151 

���񣺿���/etc/ha.d/ldirectord.cf�ļ���151�����ϣ���ַΪ��/etc/ha.d 

�ڱ����ϲ�����ʹ������scp�� 

scp /etc/ha.d/ldirectord.cf root@192.168.138.151:/etc/ha.d 
#scp �Cr �����ļ�·�����ɶ����  root@Զ��IP��Զ��·�� 
һ���������ļ�������Զ�̻����� 

scp /home/administrator/news.txt root@192.168.6.129:/etc/squid 

���У� 

/home/administrator/      �����ļ��ľ���·�� 
news.txt                          Ҫ���Ƶ��������ϵı����ļ� 
root                                 ͨ��root�û���¼��Զ�̷�������Ҳ����ʹ������ӵ��ͬ��Ȩ�޵��û��� 
192.168.6.129                Զ�̷�������ip��ַ��Ҳ����ʹ��������������� 
/etc/squid                       �������ļ����Ƶ�λ��Զ�̷������ϵ�·�� 

  

������Զ�̷������ϵ��ļ����Ƶ����� 

#scp remote@www.abc.com:/usr/local/sin.sh /home/administrator 

remote                       ͨ��remote�û���¼��Զ�̷�������Ҳ����ʹ������ӵ��ͬ��Ȩ�޵��û��� 
www.abc.com              Զ�̷���������������ȻҲ����ʹ�ø÷�����ip��ַ�� 
/usr/local/sin.sh           �����Ƶ�������λ��Զ�̷������ϵ��ļ� 
/home/administrator  ��Զ���ļ����Ƶ����صľ���·�� 

  

ע�����㣺 
1.���Զ�̷���������ǽ���������ƣ�scp��Ҫ������˿ڣ�������ʲô�˿�����������������ʽ���£� 
#scp -p 4588 remote@www.abc.com:/usr/local/sin.sh /home/administrator 
2.ʹ��scpҪע����ʹ�õ��û��Ƿ���пɶ�ȡԶ�̷�������Ӧ�ļ���Ȩ�ޡ� 


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
###file �C Determine file type 
############################################################ 
file picture.jpg 
############################################################ 
###alias - Creating Your Own Commands 
############################################################ 
alias foo='cd /usr; ls; cd -' 
############################################################ 
###which �C Display An Executable's Location 
############################################################ 
which ls 
############################################################ 
###ls �C List directory contents 
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
            attributes are always ��rwxrwxrwx�� and are dummy values. The 
            real file attributes are those of the file the symbolic link points to. 
c           A character special file. This file type refers to a device that 
            handles data as a stream of bytes, such as a terminal or modem. 
b           A block special file. This file type refers to a device that handles 
            data in blocks, such as a hard drive or CD-ROM drive. 
#The remaining nine characters of the file attributes         
#Owner   Group   World 
#rwx     rwx     rwx 
############################################################ 
###wc �C Print Line, Word, And Byte Counts 
############################################################ 
wc output.txt 
#Use wc (word count) command to count the line 
ls /bin /usr/bin | sort | uniq | wc -l 
############################################################ 
###cat �C Concatenate Files 
############################################################ 
#Create short text files from input(type from keyboard) -- cat copies standard input to standard output, type Ctrl-d at the end 
cat > lazy_dog.txt 
############################################################ 
###grep �C Print Lines Matching A Pattern 
############################################################ 
grep pattern [file...] 
When grep encounters a "pattern" in the file, it prints out the lines containing it. -- "-i" ignore case, "-v" which tells grep to only print lines that do not match the pattern. 
############################################################ 
###head / tail �C Print First / Last Part Of Files 
############################################################ 
#By default, both commands print ten lines of text, but this can be adjusted with the "-n" option 
head -n 5 ls-output.txt 
tail -n 5 ls-output.txt 
#tail has an option which allows you to view files in real-time. With "-f" option, tail continues to monitor the file and when new lines are appended, until you type Ctrl-c. 
tail -f /var/log/messages 
############################################################ 
###tee �C Read From Stdin And Output To Stdout And Files 
############################################################ 
#tee to capture the entire directory listing to the file ls.txt before grep filters the pipeline's contents 
ls /usr/bin | tee ls.txt | grep zip 

############################################################ 
###echo �C Display a line of text 
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
###clear �C Clear the screen 
############################################################ 
############################################################ 
###history �C Display the contents of the history list 
############################################################ 
history | less 
!88 
#bash will expand ��!88�� into the contents of the eighty-eighth line in the history list. 

############################################################ 
###id �C Display user identity 
############################################################ 
#User accounts are defined in the /etc/passwd file and groups are defined in the /etc/group file. 
#/etc/shadow which holds information about the user's password 

############################################################ 
###chmod �C Change a file's mode (permissions)
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
###umask �C Set the default file permissions 
############################################################ 
umask 0022
#Original file mode|  --- rw- rw- rw-
#Mask              |  000 000 010 010
#Result            |  --- rw- r-- r--

############################################################ 
###su �C Run a shell as another user 
############################################################ 

###sudo �C Execute a command as another user 
###chown �C Change a file's owner 
###chgrp �C Change a file's group ownership 
###passwd �C Change a user's password 
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
