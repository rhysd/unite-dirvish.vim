let s:source = {
\   'name' : 'dirvish',
\   'description' : 'Incremental search for vim-dirvish',
\   'syntax' : 'uniteSource__Dirvish',
\   'default_action' : {'common' : 'dirvish_down'},
\   'action_table' : {},
\   'hooks' : {},
\ }

let g:unite_dirvish_single_open_cmd = get(g:, 'unite_dirvish_single_open_cmd', 'edit')
let g:unite_dirvish_multi_open_cmd = get(g:, 'unite_dirvish_multi_open_cmd', 'botright vsplit')

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
    let onlydir = index(a:args, 'onlydir') >= 0
    for i in range(len(lines))
        let line = lines[i]
        if onlydir && line !~# '[\/]$'
            continue
        endif
        " fnamemodify(, ':t') is unavailable because of trailing slash
        let word = matchstr(line, '[^\/]*[\/]\=$')
        if word ==# ''
            continue
        endif
        let ret += [{ 'word': word, 'action__line': i + 1, 'action__path' : line }]
    endfor
    return ret
endfunction

let s:source.action_table.dirvish_down = {
\   'description' : 'Open the selected path with vim-dirvish way',
\   'is_selectable' : 1,
\ }

function! s:source.action_table.dirvish_down.func(candidates) abort
    if empty(a:candidates)
        return
    endif
    if len(a:candidates) == 1
        execute a:candidates[0].action__line . 'call dirvish#open(g:unite_dirvish_single_open_cmd, 0)'
        return
    endif
    for candidate in a:candidates
        let p = candidate.action__path
        if filereadable(p) && !isdirectory(p)
            execute g:unite_dirvish_multi_open_cmd . ' +wincmd\ p ' . candidate.action__path
        endif
    endfor
    execute 'normal' "\<Plug>(dirvish_quit)"
endfunction
