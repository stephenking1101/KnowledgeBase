# Ansible

https://www.jianshu.com/p/c56a88b103f8

## 设置跳板机

* setup inventory file
/etc/ansible/hosts

e.g.  
```
jumper ansible_host=ecnshts3008.sh.cn.ao.se

[jenkins]
10.175.186.108
```

* create yml file for group variables  
/etc/ansible/group_vars/jenkins.yml

```
---
# The variables file used by the playbooks in the jenkins group.
# These don't have to be explicitly imported by vars_files: they are autopopulated.

ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q ezunhsw@ecnshts3008.sh.cn.ao.se"'
ansible_user: root
```

* create yml file for host variables  
ubuntu:/etc/ansible/host_vars/jumper.yml

```
ansible_user: ezunhsw
```

## 设置SSH连接

1. 先在主机A上创建密钥对  
ssh-keygen -t rsa

2. 把主机A的公钥放在主机B上  
scp -r /root/.ssh/id_rsa.pub 192.168.31.147:/root/.ssh/authorized_keys

## Playbook - playbook.yml

```
---
# Each playbook is composed of one or more ‘plays’ in a list.
- hosts: jenkins
  vars:
    file_mode: 0644
  # same as and override by ansible_user. besides, ansible_user is used when we want to specifiy default SSH user in ansible hosts file where as remote_user is used in playbook context
  remote_user: root
  
  # At a basic level, a task is nothing more than a call to an ansible module
  tasks:
    - name: list services
      command: service --status-all
      # These ‘notify’ actions are triggered at the end of each block of tasks in a play, and will only be triggered once even if notified by multiple different tasks and the task's changed is true.
      notify:
        - restart apache
    # The shell module takes the command name followed by a list of space-delimited arguments. It is almost exactly like the command module but runs the command through a shell (/bin/sh) on the remote node.
    # You can also use the 'args' form to provide the options.
    - name: Execute the command in remote shell; stdout goes to the specified file on the remote.
      shell: ls -l > /tmp/somelog.txt
      args:
        chdir: /
    - name: test connection
      ping:
    # The copy module copies a file from the local or remote machine to a location on the remote machine. 
    - copy:
        src: /etc/ansible/ansible.cfg
        dest: /tmp/foo.conf
        owner: root
        group: root
        mode: "{{ file_mode }}"
  
  # Handlers: Running Operations On Change  
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
...
```

* run a playbook using a parallelism level of 10  
ansible-playbook playbook.yml -f 10 -v

* start the playbook at the task matching this name
ansible-playbook test.yml --start-at-task="deregister cm file" -v

## Ansible 小手册系列

* Play

accelerate	开启加速模式
accelerate_ipv6	是否开启ipv6
accelerate_port	加速模式的端口
always_run	
any_errors_fatal	有任务错误时，立即停止
become	是否提权
become_flags	提权命令的参数
become_method	提权得方式
become_user	提权的用户
check_mode	当为True时，只检查，不做修改
connection	连接方式
environment	定义远端系统的环境变量
force_handlers	任务失败后，是否依然执行handlers中的任务
gather_facts	是否获取远端系统得facts
gather_subset	获取facts得哪些键值
gather_timeout	获取facts的超时时间
handlers	定义task执行完成以后需要调用的任务
hosts	指定运行得主机
ignore_errors	是否忽略错误
max_fail_percentage	最大的错误主机数，超过则立即停止ansbile
name	定义任务得名称
no_log	不记录日志
port	定义ssh的连接端口
post_tasks	执行任务后要执行的任务
pre_tasks	执行任务前要执行的任务
remote_user	远程登陆的用户
roles	定义角色
run_once	任务只运行一次
serial	任务每次执行的主机数
strategy	play运行的模式
tags	标记标签
tasks	定义任务
vars	定义变量
vars_files	包含变量文件
vars_prompt	要求用户输入内容
vault_password	加密密码

* Role

always_run	
become	是否提权
become_flags	提权命令的参数
become_method	提权的方式
become_user	提权的用户
check_mode	当为True时，只检查，不做修改
connection	连接方式
delegate_facts	委托facts
delegate_to	任务委派
environment	定义远端系统的环境变量
ignore_errors	是否忽略错误
no_log	不记录日志
port	定义ssh的连接端口
remote_user	远端系统的执行用户
run_once	只运行一次
tags	标记标签
vars	定义变量
when	条件表达式结果为True则执行block

* Block

always	always里的任务总是执行
always_run	
any_errors_fatal	有错误时立即中断ansbile
become	是否提权
become_flags	提权命令的参数
become_method	提权的方式
become_user	提权的用户
block	分组执行
check_mode	当为True时，只检查，不做修改
connection	连接方式
delegate_facts	委托facts
delegate_to	任务委派
environment	定义远端系统的环境变量
ignore_errors	是否忽略错误
no_log	不记录日志
port	定义ssh的连接端口
remote_user	远端系统的执行用户
rescue	block中的任务在执行中，如果有任何错误，将执行rescue中的任务。
run_once	只运行一次
tags	标记标签
vars	定义变量
when	条件表达式结果为True则执行block

* Task

action	执行动作
always_run	
any_errors_fatal	为True时，只要任务有错误，就立即停止ansible
args	定义任务得参数
async	是否异步执行任务
become	是否提权
become_flags	提权命令的参数
become_method	提权的方式
become_user	提权的用户
changed_when	条件表达式为True时，使任务状态为changed
check_mode	为True时，只检查运行状态，在远端不做任何修改
connection	连接方式
delay	等待多少秒，才执行任务
delegate_facts	委托facts
delegate_to	任务委派
environment	定义远端的环境变量
failed_when	条件表达式为True时，使任务为失败状态
ignore_errors	是否忽略错误
local_action	本地执行
loop	
loop_args	
loop_control	改变循环的变量项
name	定义人物的名称
no_log	不记录日志
notify	用于任务执行完，执行handlers里的任务
poll	轮询时间
port	定义ssh的连接端口
register	注册变量
remote_user	远端系统的执行用户
retries	重试次数
run_once	只运行一次
tags	标记为标签
until	直到为真时，才继续执行任务
vars	定义变量
when	条件表达式，结果为True则执行task
with_<lookup_plugin>	循环
