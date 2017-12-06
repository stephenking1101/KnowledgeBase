# Ansible

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