#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import requests
from urllib.parse import urljoin
from urllib import request

BASE_URL = 'http://192.168.26.67:8000'
AUTH = ('admin', 'admin')


def test_get_user_list():
    rsp = requests.get(urljoin(BASE_URL, '/snippets/'), auth=AUTH, headers={
        'Accept': 'application/json'
    })
    return rsp


def test_post_user_list():
    json_data = dict(
        title='zhangsan',
        code='oo',
        linenos='true'
    )
    rsp = requests.post(urljoin(BASE_URL, '/snippets/'), auth=AUTH, headers={
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }, data=json.dumps(json_data))
    return rsp


def test_get_user():
    rsp = requests.get(urljoin(BASE_URL, '/snippets/17'), auth=AUTH, headers={
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    })
    return rsp


def test_put_user():
    json_data = dict(
        title='zhangsan',
        code='oo',
        linenos='true'
    )
    # 注意最后的 /
    rsp = requests.put(urljoin(BASE_URL, '/snippets/1/'), auth=AUTH, headers={
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }, data=json.dumps(json_data),
                       )
    return rsp


def test_patch_user():
    json_data = dict(
        title='aaaaaaaaaaaaaaaaaaaa',
    )
    rsp = requests.patch(urljoin(BASE_URL, '/snippets/1/'), auth=AUTH, headers={
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }, data=json.dumps(json_data),
                         )
    return rsp


def call(body, url):
    headers = {}

    # 这里有个细节，如果body需要json形式的话，需要做处理
    # 可以是data = json.dumps(body)
    response = requests.post(url, data=json.dumps(body), headers=headers)
    # 也可以直接将data字段换成json字段，2.4.3版本之后支持
    # response  = requests.post(url, json = body, headers = headers)

    # 返回信息
    print(response.text)
    # 返回响应头
    print(response.status_code)
    return "回调发送成功"


if __name__ == "__main__":
    url = "http://192.168.0.128:8080/api/register/result"
    data = '[{"bugid": "12260", "type": "success", "bugname": "firefox"}, {"bugid": "12261", "type": "success", "bugname": "xulrunner"}, {"bugid": "12262", "type": "failed", "bugname": "xulrunner-devel"}]'
    call(data, url)
    request.urlopen('http://www.sina.com.cn')
    # r = requests.get("http://localhost:9999/helloworld/yourname")
    # print(r.text)
