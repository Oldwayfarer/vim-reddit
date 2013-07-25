#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, vim, urllib2
import simplejson

TIMEOUT = 20

def main():

    config_path = vim.eval("g:vim_reddit_config")
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

    vim.current.buffer[0] = "Reddit front page ☢"
    vim.current.buffer.append(20*"=" + " ☢")

    for post in posts:
        post_data = post.get(config['body'], {})
        post_struct = config['structure']

        title = post_data.get(post_struct['title'], "NO TITLE").encode("utf-8")
        source = post_data.get(post_struct['source'], "").encode("utf-8")
        author = post_data.get(post_struct['source'], "").encode("utf-8")
        url = post_data.get(post_struct['url'], "").encode("utf-8")
        text = post_data.get(post_struct['text'], None).encode("utf-8")

        if text is not None:
            text = text.replace('\n', '')

        vim.current.buffer.append("{source} ▶ {title}".format(source=source, title=title))
        vim.current.buffer.append("by {author} ▷ [ {url} ]".format(author=author, url=url))

        if text:
            vim.current.buffer.append("{text}".format(text=text))

        if post != posts[-1]:
            vim.current.buffer.append("\n")

    vim.command("set nomodifiable")


if __name__ == '__main__':
    main()
