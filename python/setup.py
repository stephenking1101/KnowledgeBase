# !/usr/bin/env python
# -*- coding:utf-8 -*-


from setuptools import setup, find_packages

test = find_packages()

print(test)

setup(
    name="HelloWorld",
    version="0.1",
    packages=find_packages(),

    # Project uses reStructuredText, so ensure that the docutils get
    # installed or upgraded on the target machine
    #install_requires=['docutils>=0.3'],

    #package_data={
    #    # If any package contains *.txt or *.rst files, include them:
    #    '': ['*.txt', '*.rst'],
    #    # And include any *.msg files found in the 'hello' package, too:
    #    'hello': ['*.msg'],
    #},

    # metadata to display on PyPI
    #author="Me",
    #author_email="me@example.com",
    #description="This is an Example Package",
    #license="PSF",
    #keywords="hello world example examples",
    #url="http://example.com/HelloWorld/",   # project home page, if any
    #project_urls={
    #    "Bug Tracker": "https://bugs.example.com/HelloWorld/",
    #    "Documentation": "https://docs.example.com/HelloWorld/",
    #    "Source Code": "https://code.example.com/HelloWorld/",
    #}

    # could also include long_description, download_url, classifiers, etc.

    platforms='python 3.7',
    py_modules=['example'],
    entry_points={
        'console_scripts': [
            #'setupdemo = example:printme'
            'setupdemo = example:main'
        ]
    }
)

# setup.py参数说明

# python setup.py build       # 编译
# python setup.py install     #安装
# python setup.py sdist       #生成压缩包(zip/tar.gz)
# python setup.py bdist_wininst   #生成NT平台安装包(.exe)
# python setup.py bdist_rpm   #生成rpm包

# 或者直接
# "bdist 包格式"，格式描述如下：

# python setup.py bdist --help-formats
# --formats = rpm
# RPM distribution
#
# --formats = gztar
# gzip'ed tar file
#
# --formats = bztar
# bzip2'ed tar file
#
# --formats = ztar
# compressed tar file
#
# --formats = tar
# tar file
#
# --formats = wininst
# Windows executable installer
#
# --formats = zip
# ZIP file