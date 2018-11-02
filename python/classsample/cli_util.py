#!/usr/bin/python
import subprocess
import time


#
# run command and check its status and output
#
def run_cmd(cmd):
    print(time.strftime('%Y-%m-%d-%X', time.localtime()), "Start running command '%s'" % cmd)

    # 子进程的文本流控制
    # 子进程的标准输入、标准输出和标准错误如下属性分别表示:
    #
    # 代码如下:
    #
    # child.stdin
    # child.stdout
    # child.stderr
    #
    # 可以在Popen()
    # 建立子进程的时候改变标准输入、标准输出和标准错误，并可以利用subprocess.PIPE将多个子进程的输入和输出连接在一起，构成管道(pipe)，如下2个例子：
    #
    # 代码如下:
    # >> > import subprocess
    # >> > child1 = subprocess.Popen(["ls", "-l"], stdout=subprocess.PIPE)
    # >> > print
    # child1.stdout.read(),
    # # 或者child1.communicate()
    # >> > import subprocess
    # >> > child1 = subprocess.Popen(["cat", "/etc/passwd"], stdout=subprocess.PIPE)
    # >> > child2 = subprocess.Popen(["grep", "0:0"], stdin=child1.stdout, stdout=subprocess.PIPE)
    # >> > out = child2.communicate()
    #
    # subprocess.PIPE实际上为文本流提供一个缓存区。child1的stdout将文本输出到缓存区，随后child2的stdin从该PIPE中将文本读取走。child2的输出文本也被存放在PIPE中，直到communicate()
    # 方法从PIPE中读取出PIPE中的文本。
    # 注意：communicate()
    # 是Popen对象的一个方法，该方法会阻塞父进程，直到子进程完成

    popen = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, close_fds=True)

    #  实时输出 stdout
    for line in iter(popen.stdout.readline, b''):
        print(line)  # print to stdout immediately

    popen.stdout.close()
    # 等待子进程结束。设置并返回returncode属性。
    status = popen.wait()

    current_time = time.strftime('%Y-%m-%d-%X', time.localtime())

    print(current_time, "Finish running command. Return status: %s" % status)

    # 返回一个 tuple类型，来间接达到返回多个值, 也可以写作 return (a, b)
    return status, popen.stderr
