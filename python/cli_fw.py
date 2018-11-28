#!/usr/bin/python

# -*- coding: utf-8 -*-
import argparse

# 创建 ArgumentParser() 对象
# 调用 add_argument() 方法添加参数
# 使用 parse_args() 解析添加的参数
parser = argparse.ArgumentParser()

# 定位参数的使用, python cli_fw.py 8
parser.add_argument("test", help="display a square of a given number", type=int)

# 命令行参数是可选的, python cli_fw.py -h, python cli_fw.py --square 8
parser.add_argument("--square", help="display a square of a given number", type=int)
parser.add_argument("--cubic", help="display a cubic of a given number", type=int)

args = parser.parse_args()

if args.square:
    print(args.square ** 2)

if args.cubic:
    print(args.cubic ** 3)

print(args.test ** 2)

# Difference between --default and --store_const in argparse
# Here you cannot supply additional value to argument,
# either argument exist or it doesn't. These type of argument requires action = "store_const" and its value must be
# supplied in const parameter as shown below. You cannot specify different value.

# parser = argparse.ArgumentParser()
# parser.add_argument('--use-cuda', action='store_const', const=False, default=True)
# parser.parse_args('--use-cuda'.split()) # use-cuda is now False
# parser.parse_args(''.split()) # use-cuda is now True
# parser.parse_args('--use-cuda True'.split()) # ERROR: unrecognized arguments: True

# Here you can make the argument default by using default parameter. However you either must commit the argument completely or include it with value as shown below:
# parser = argparse.ArgumentParser()
# parser.add_argument('--seed', default=42)
# parser.parse_args('--seed 20'.split()) # seed is now 20
# parser.parse_args(''.split()) # seed is now 42
# parser.parse_args('--seed'.split()) # ERROR, must supply argument value



# parser = argparse.ArgumentParser(description='Process some integers.')
# parser.add_argument('integers', metavar='N', type=int, nargs='+',
#                     help='an integer for the accumulator')
# parser.add_argument('--sum', dest='accumulate', action='store_const',
#                     const=sum, default=max,
#                     help='sum the integers (default: find the max)')
#
# args = parser.parse_args()
# print(args.accumulate(args.integers))

# metavar is used in help messages in a place of an expected argument.
# action defines how to handle command-line arguments: store it as a constant, append into a list, store a boolean value etc.
# $ python argparse_usage.py
# usage: argparse_usage.py [-h] [--sum] N [N ...]
# argparse_usage.py: error: too few arguments
# $ python argparse_usage.py 1 2 3 4
# 4
# $ python argparse_usage.py 1 2 3 4 --sum
# 10