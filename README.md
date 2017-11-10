Source plugin for [unite.vim](https://github.com/Shougo/unite.vim) and [vim-dirvish](https://github.com/justinmk/vim-dirvish). It provides an incremental search in vim-dirvish buffer.

Usage:
```
:Unite dirvish
```

It may be useful to overwrite original `/` mapping.

```vim
augroup dirvish-vimrc
    autocmd!
    autocmd FileType dirvish nnoremap <buffer>/ :<C-u>Unite dirvish<CR>
augroup END
```

Distributed under [MIT License](https://opensource.org/licenses/MIT).

```
Copyright (c) 2017 rhysd
```

