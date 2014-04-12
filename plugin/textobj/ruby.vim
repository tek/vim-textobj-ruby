call textobj#user#plugin('ruby', {
      \ 'block': {
      \   'sfile': expand('<sfile>:p'),
      \   'select-a': 'ar',
      \   'select-a-function': 'textobj#ruby#a_block',
      \   'select-i': 'ir',
      \   'select-i-function': 'textobj#ruby#i_block',
      \ },
      \ 'function': {
      \   'sfile': expand('<sfile>:p'),
      \   'select-a': 'af',
      \   'select-a-function': 'textobj#ruby#a_func',
      \   'select-i': 'if',
      \   'select-i-function': 'textobj#ruby#i_func',
      \ },
      \ 'class': {
      \   'sfile': expand('<sfile>:p'),
      \   'select-a': 'ac',
      \   'select-a-function': 'textobj#ruby#a_class',
      \   'select-i': 'ic',
      \   'select-i-function': 'textobj#ruby#i_class',
      \ },
      \ 'name': {
      \   'pattern': '\w\+\%(::\w\+\)*',
      \   'select': ['an', 'in'],
      \ },
      \ })

if !exists('g:textobj_ruby_inclusive')
  let g:textobj_ruby_inclusive = 1
endif

if !exists('g:ruby_block_openers')
  let g:ruby_block_openers = '%(<%(def|if|module|class|until|begin)>|.*<do>)'
endif

if !exists('g:textobj_ruby_grow')
  let g:textobj_ruby_grow = 1
endif
