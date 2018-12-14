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

