vim-reddit
==========

This small plugin for reading the reddit front page. It's really simple)

### Installation
For Vundle, add to .vimrc

```
Bundle 'erthalion/vim-reddit'
```

### Usage
Edit **reddit.json** file - you need change **url** from "http://www.reddit.com/.json" to your front page url.

It should be like "http://www.reddit.com/.json?feed={modhash}&user={username}".
Now you can call

```
:Reddit
```
and read)

Similarly **hacker_news.json** file contains configuration for reading HackerNews (you don't need change anything).
You should execute command

```
:HackerNews
```
for reading.

**Warning** - These commands will clear the current buffer.

### Screenshot
<a href='http://postimg.org/image/asuz30rnf/' target='_blank'><img src='http://s17.postimg.org/asuz30rnf/screen_2013_07_25.jpg' border='0' alt="screen 2013 07 25" /></a>
