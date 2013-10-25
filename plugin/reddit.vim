if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

if exists('g:vim_reddit_module')
    finish
endif
let g:vim_reddit_module = 1

if !exists('g:vim_reddit_root') || g:vim_reddit_root == ''
    let g:vim_reddit_root = expand("<sfile>:p:h")
endif

if !exists('g:vim_reddit_config') || g:vim_reddit_config == ''
    let g:vim_reddit_config = g:vim_reddit_root."/reddit.json"
endif

if !exists('g:vim_hacker_news_config') || g:vim_reddit_config == ''
    let g:vim_hacker_news_config = g:vim_reddit_root."/hacker_news.json"
endif


python << EOF
import sys, vim
sys.path.append(vim.eval("g:vim_reddit_root"))
EOF

function BufferModification()
    setlocal nomodifiable
    setlocal buftype=nofile
    set ft=reddit
endfunction

function! Reddit()

python << EOF

from reddit import load
config = vim.eval("g:vim_reddit_config")
load(config)

EOF

    call BufferModification()
endfunction

function! HackerNews()

python << EOF

from reddit import load
config = vim.eval("g:vim_hacker_news_config")
load(config)

EOF

    call BufferModification()
endfunction

if !exists(":Reddit")
    command Reddit :call Reddit()
endif

if !exists(":HackerNews")
    command HackerNews :call HackerNews()
endif
