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


$( ) 与 ` ` (反引号)
在 bash shell 中，$( ) 与 ` ` (反引号) 都是用来做命令替换用(command substitution)的。

所谓的命令替换与我们第五章学过的变量替换差不多，都是用来重组命令行：
* 完成引号里的命令行，然后将其结果替换出来，再重组命令行。
例如：
[code]$ echo the last sunday is $(date -d "last sunday" +%Y-%m-%d)[/code]
如此便可方便得到上一星期天的日期了… ^_^

用 $( ) 的理由：

1,   ` ` 很容易与 ' ' ( 单引号)搞混乱，尤其对初学者来说。
有时在一些奇怪的字形显示中，两种符号是一模一样的(直竖两点)。
当然了，有经验的朋友还是一眼就能分辩两者。只是，若能更好的避免混乱，又何乐不为呢？ ^_^

2, 在多层次的复合替换中，` ` 须要额外的跳脱( \` )处理，而 $( ) 则比较直观。例如：
这是错的：
[code]command1 `command2 `command3` `[/code]
原本的意图是要在 command2 `command3` 先将 command3 提换出来给 command 2 处理，
然后再将结果传给 command1 `command2 …` 来处理。
然而，真正的结果在命令行中却是分成了 `command2 ` 与 “ 两段。
正确的输入应该如下：
[code]command1 `command2 \`command3\` `[/code]

要不然，换成 $( ) 就没问题了：
[code]command1 $(command2 $(command3))[/code]
只要你喜欢，做多少层的替换都没问题啦~~~   ^_^

$( ) 的不足:
1. ` ` 基本上可用在全部的 unix shell 中使用，若写成 shell script ，其移植性比较高。
而 $( ) 并不见的每一种 shell 都能使用，我只能跟你说，若你用 bash2 的话，肯定没问题…   ^_^

${ } 用来作变量替换。
一般情况下，$var 与 ${var} 并没有啥不一样。
但是用 ${ } 会比较精确的界定变量名称的范围，比方说：
$ A=B
$ echo $AB
原本是打算先将 $A 的结果替换出来，然后再补一个 B 字母于其后，
但在命令行上，真正的结果却是只会提换变量名称为 AB 的值出来…
若使用 ${ } 就没问题了：
$ echo ${A}B
BB

不过，假如你只看到 ${ } 只能用来界定变量名称的话，那你就实在太小看 bash 了﹗
有兴趣的话，你可先参考一下 cu 本版的精华文章：
http://www.chinaunix.net/forum/viewtopic.php?t=201843

为了完整起见，我这里再用一些例子加以说明 ${ } 的一些特异功能：
假设我们定义了一个变量为：
file=/dir1/dir2/dir3/my.file.txt
我们可以用 ${ } 分别替换获得不同的值：
${file#*/}：拿掉第一条 / 及其左边的字符串：dir1/dir2/dir3/my.file.txt
${file##*/}：拿掉最后一条 / 及其左边的字符串：my.file.txt
${file#*.}：拿掉第一个 .  及其左边的字符串：file.txt
${file##*.}：拿掉最后一个 .  及其左边的字符串：txt
${file%/*}：拿掉最后条 / 及其右边的字符串：/dir1/dir2/dir3
${file%%/*}：拿掉第一条 / 及其右边的字符串：(空值)
${file%.*}：拿掉最后一个 .  及其右边的字符串：/dir1/dir2/dir3/my.file
${file%%.*}：拿掉第一个 .  及其右边的字符串：/dir1/dir2/dir3/my
记忆的方法为：
[list]# 是去掉左边(在鉴盘上 # 在 $ 之左边)
% 是去掉右边(在鉴盘上 % 在 $ 之右边)
单一符号是最小匹配﹔两个符号是最大匹配。[/list]
${file:0:5}：提取最左边的 5 个字节：/dir1
${file:5:5}：提取第 5 个字节右边的连续 5 个字节：/dir2

我们也可以对变量值里的字符串作替换：
${file/dir/path}：将第一个 dir 提换为 path：/path1/dir2/dir3/my.file.txt
${file//dir/path}：将全部 dir 提换为 path：/path1/path2/path3/my.file.txt

利用 ${ } 还可针对不同的变量状态赋值(没设定、空值、非空值)： 
${file-my.file.txt} ：假如 $file 没有设定，则使用 my.file.txt 作传回值。(空值及非空值时不作处理) 
${file:-my.file.txt} ：假如 $file 没有设定或为空值，则使用 my.file.txt 作传回值。 (非空值时不作处理)
${file+my.file.txt} ：假如 $file 设为空值或非空值，均使用 my.file.txt 作传回值。(没设定时不作处理)
${file:+my.file.txt} ：若 $file 为非空值，则使用 my.file.txt 作传回值。 (没设定及空值时不作处理)
${file=my.file.txt} ：若 $file 没设定，则使用 my.file.txt 作传回值，同时将 $file 赋值为 my.file.txt 。 (空值及非空值时不作处理)
${file:=my.file.txt} ：若 $file 没设定或为空值，则使用 my.file.txt 作传回值，同时将 $file 赋值为 my.file.txt 。 (非空值时不作处理)
${file?my.file.txt} ：若 $file 没设定，则将 my.file.txt 输出至 STDERR。 (空值及非空值时不作处理)
${file:?my.file.txt} ：若 $file 没设定或为空值，则将 my.file.txt 输出至 STDERR。 (非空值时不作处理)

 

tips:
以上的理解在于, 你一定要分清楚 unset 与 null 及 non-null 这三种赋值状态.
一般而言, : 与 null 有关, 若不带 : 的话, null 不受影响, 若带 : 则连 null 也受影响.

还有哦，${#var} 可计算出变量值的长度：
${#file} 可得到 27 ，因为 /dir1/dir2/dir3/my.file.txt 刚好是 27 个字节…

接下来，再为大家介稍一下 bash 的组数(array)处理方法。
一般而言，A="a b c def" 这样的变量只是将 $A 替换为一个单一的字符串，
但是改为 A=(a b c def) ，则是将 $A 定义为组数…
bash 的组数替换方法可参考如下方法：
${A[@]} 或 ${A[*]} 可得到 a b c def (全部组数)
${A[0]} 可得到 a (第一个组数)，${A[1]} 则为第二个组数…
${#A[@]} 或 ${#A[*]} 可得到 4 (全部组数数量)
${#A[0]} 可得到 1 (即第一个组数(a)的长度)，${#A[3]} 可得到 3 (第四个组数(def)的长度)
A[3]=xyz 则是将第四个组数重新定义为 xyz …

好了，最后为大家介绍 $(( )) 的用途吧：它是用来作整数运算的。
在 bash 中，$(( )) 的整数运算符号大致有这些：
+ - * / ：分别为 "加、减、乘、除"。
% ：余数运算
& | ^ !：分别为 "AND、OR、XOR、NOT" 运算。

例：
$ a=5; b=7; c=2
$ echo $(( a+b*c ))
19
$ echo $(( (a+b)/c ))
6
$ echo $(( (a*b)%c))
1

在 $(( )) 中的变量名称，可于其前面加 $ 符号来替换，也可以不用，如：
$(( $a + $b * $c)) 也可得到 19 的结果

此外，$(( )) 还可作不同进位(如二进制、八进位、十六进制)作运算呢，只是，输出结果皆为十进制而已：
echo $((16#2a)) 结果为 42 (16进位转十进制)
以一个实用的例子来看看吧：
假如当前的   umask 是 022 ，那么新建文件的权限即为：
$ umask 022
$ echo "obase=8;$(( 8#666 & (8#777 ^ 8#$(umask)) ))" | bc
644

事实上，单纯用 (( )) 也可重定义变量值，或作 testing：
a=5; ((a++)) 可将 $a 重定义为 6 
a=5; ((a–)) 则为 a=4
a=5; b=7; ((a < b)) 会得到   0 (true) 的返回值。
常见的用于 (( )) 的测试符号有如下这些：
<：小于
>：大于
<=：小于或等于
>=：大于或等于
==：等于
!=：不等于

############################################################ 
###conditional statement, use in if/else, while...
############################################################ 
There are many different ways that an conditional statement can be used. These are summarized here:

String Comparison	Description
Str1 = Str2	Returns true if the strings are equal
Str1 != Str2	Returns true if the strings are not equal
-n Str1	Returns true if the string is not null
-z Str1	Returns true if the string is null
Numeric Comparison	Description
expr1 -eq expr2	Returns true if the expressions are equal
expr1 -ne expr2	Returns true if the expressions are not equal
expr1 -gt expr2	Returns true if expr1 is greater than expr2
expr1 -ge expr2	Returns true if expr1 is greater than or equal to expr2
expr1 -lt expr2	Returns true if expr1 is less than expr2
expr1 -le expr2	Returns true if expr1 is less than or equal to expr2
! expr1	Negates the result of the expression
File Conditionals	Description
-d file	True if the file is a directory
-e file	True if the file exists (note that this is not particularly portable, thus -f is generally used)
-f file	True if the provided string is a file
-g file	True if the group id is set on a file
-r file	True if the file is readable
-s file	True if the file has a non-zero size
-u	True if the user id is set on a file
-w	True if the file is writable
-x	True if the file is an executable
