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
    let g:vim_reddit_config = g:vim_reddit_root."/default.json"
endif

" Variables for url highlighting
" Taken from here https://github.com/vim-scripts/TwitVim
let s:URL_PROTOCOL = '\%([Hh][Tt][Tt][Pp]\|[Hh][Tt][Tt][Pp][Ss]\|[Ff][Tt][Pp]\)://'
let s:URL_PROTOCOL_HTTPS = '\%([Hh][Tt][Tt][Pp][Ss]\)://'
let s:URL_PROTOCOL_NON_HTTPS = '\%([Hh][Tt][Tt][Pp]\|[Ff][Tt][Pp]\)://'
let s:URL_DOMAIN = '[^[:space:])/]\+'
let s:URL_PATH_CHARS = '[^[:space:]()]'
let s:URL_PARENS = '('.s:URL_PATH_CHARS.'*)'
let s:URL_PATH_END = '\%([^[:space:]\.,;:()]\|'.s:URL_PARENS.'\)'
let s:URL_PATH = '\%('.s:URL_PATH_CHARS.'*\%('.s:URL_PARENS.s:URL_PATH_CHARS.'*\)*'.s:URL_PATH_END.'\)\|\%('.s:URL_PATH_CHARS.'\+\)'
let s:URLMATCH = s:URL_PROTOCOL.s:URL_DOMAIN.'\%(/\%('.s:URL_PATH.'\)\=\)\='
let s:URLMATCH_HTTPS = s:URL_PROTOCOL_HTTPS.s:URL_DOMAIN.'\%(/\%('.s:URL_PATH.'\)\=\)\='
let s:URLMATCH_NON_HTTPS = s:URL_PROTOCOL_NON_HTTPS.s:URL_DOMAIN.'\%(/\%('.s:URL_PATH.'\)\=\)\='


python << EOF
import sys, vim
sys.path.append(vim.eval("g:vim_reddit_root"))
EOF

function! Reddit()

python << EOF

from reddit import main
main()

EOF
setlocal nomodifiable
setlocal buftype=nofile
call s:reddit_syntax()
endfunction

function! s:reddit_syntax()
    if has("syntax") && exists("g:syntax_on")
        " Reset syntax items in case there are any predefined in the new buffer.
        syntax clear

        syntax match subreddit /^.\{-1,} ▶/

        execute 'syntax match url "\<'.s:URLMATCH.'"'

        syntax match author /^.\{-1,} ▷/

        syntax match title /^.\{-1,} ☢/
        highlight title gui=bold guifg=yellowgreen

        highlight default link subreddit Identifier
        highlight default link url Underlined
        highlight default link author String

    endif
endfunction

if !exists(":Reddit")
    command Reddit :call Reddit()
endif
