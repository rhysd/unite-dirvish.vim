let s:source = {
\   'name' : 'dirvish',
\   'description' : 'Incremental search for vim-dirvish',
\   'syntax' : 'uniteSource__Dirvish',
\   'default_action' : {'common' : 'dirvish_down'},
\   'action_table' : {},
\   'hooks' : {},
\ }

function! unite#sources#dirvish#define() abort
    return s:source
endfunction

function! s:source.hooks.on_init(args, context) abort
    if &filetype !=# 'dirvish'
        echoerr "'dirvish' unite source can only be used in dirvish buffer"
    endif
endfunction

function! s:source.hooks.on_syntax(args, context) abort
    syntax match uniteSource__Dirvish_Dir /.*[\/]$/ contained containedin=uniteSource__Dirvish
    highlight default link uniteSource__Dirvish_Dir Directory
endfunction

function! s:source.gather_candidates(args, context) abort
    let ret = []
    let lines = getline(1, '$')
    for i in range(len(lines))
        " fnamemodify(, ':t') is unavailable because of trailing slash
        let word = matchstr(lines[i], '[^\/]*[\/]\=$')
        if word ==# ''
            continue
        endif
        let ret += [{ 'word': word, 'action__line': i + 1 }]
    endfor
    return ret
endfunction

let s:source.action_table.dirvish_down = {
\   'description' : 'Open the selected path with vim-dirvish way',
\   'is_selectable' : 0,
\ }

function! s:source.action_table.dirvish_down.func(candidate) abort
    execute a:candidate.action__line
    .call dirvish#open('edit', 0)
endfunction
