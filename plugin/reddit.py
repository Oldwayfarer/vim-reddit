#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, vim, urllib2
import simplejson

TIMEOUT = 20

def load(config_path):
    config = simplejson.loads(open(config_path).read())

    # Get the posts and parse the json response
    req = urllib2.Request(config['url'], None, {'user-agent':'vim-reddit'})
    opener = urllib2.build_opener()
    f = opener.open(req, timeout=TIMEOUT)

    posts = simplejson.load(f)

    for node in config['data']:
        posts = posts.get(node, "")

    # vim.current.buffer is the current buffer. It's list-like object.
    # each line is an item in the list. We can loop through them delete
    # them, alter them etc.
    # Here we delete all lines in the current buffer

    vim.command("set modifiable")

    del vim.current.buffer[:]

    vim.current.buffer[0] = "{} front page ☢".format(config['page_name'])
    vim.current.buffer.append(20*"=" + " ☢")

    for post in posts:
        body_tag = config['body']
        post_struct = config['structure']
        if body_tag:
            post_data = post.get(config['body'], {})
        else:
            post_data = post

        title = post_data.get(post_struct['title'], "NO TITLE").encode("utf-8")
        source = post_data.get(post_struct['source'], config['page_name']).encode("utf-8")
        author = post_data.get(post_struct['author'], "").encode("utf-8")
        url = post_data.get(post_struct['url'], "").encode("utf-8")
        text = post_data.get(post_struct['text'], "").encode("utf-8")

        if text:
            text = text.replace('\n', '')

        vim.current.buffer.append("{source} ▶ {title}".format(source=source, title=title))
        vim.current.buffer.append("by {author} ▷ [ {url} ]".format(author=author, url=url))

        if text:
            vim.current.buffer.append("{text}".format(text=text))

        if post != posts[-1]:
            vim.current.buffer.append("\n")

    vim.command("set nomodifiable")


if __name__ == '__main__':
    load()
