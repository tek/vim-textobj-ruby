let s:comment = '\v\s*[^#]?\s*'
let s:start = '\v^\zs' . s:comment . g:ruby_block_openers
let s:end = '\v^' . s:comment . '<end>\zs'
let s:flags = 'Wcn'
let s:skip = 'textobj#ruby#skip()'

function! textobj#ruby#skip() abort "{{{
    return getline('.') =~ '\v\S\s<%(if|unless)>\s\S'
endfunction "}}}

function! textobj#ruby#search(...) abort "{{{
  let flag = get(a:000, 0, '')
  return searchpair(s:start, '', s:end, s:flags . flag, s:skip)
endfunction "}}

function! textobj#ruby#bounds() abort "{{{
  call cursor(0, 2)
  let bottom = textobj#ruby#search()
  let top = textobj#ruby#search('b')
  if !(bottom && top)
    let [bottom, top] = [0, 0]
  endif
  call cursor(bottom, 0)
  return [top, bottom]
endfunction "}}}

" before performing the selection, check whether the mapping has been invoked
" from visual mode (actually tests _not operator-pending_, because either vim
" or textobj-user goes back to normal mode before arriving here).
" if in visual, assume that the selection should grow to the next outer block.
function! textobj#ruby#grow() abort "{{{
  if g:textobj_ruby_grow && mode(1) != 'no' && getpos('''>') != getpos('''<')
    call cursor(line('''>') + 1 + s:inner, 2)
  endif
endfunction "}}}
  
function! textobj#ruby#block() abort "{{{
  call textobj#ruby#grow()
  let result = textobj#ruby#bounds()
  for i in range(v:count1 - 1)
    call cursor(line('.') + 1, 0)
    let result = textobj#ruby#bounds()
  endfor
  return result
endfunction "}}}

function! textobj#ruby#recursive(rex) abort "{{{
  let top = -1
  let result = [0, 0]
  while top != 0
    let [top, bottom] = textobj#ruby#bounds()
    if getline(top) =~ a:rex
      let result = [top, bottom]
      break
    endif
    call cursor(bottom + 1, 2)
  endwhile
  return result
endfunction "}}}

function! textobj#ruby#func() abort "{{{
  return textobj#ruby#recursive('\v^\s*def>')
endfunction "}}}

function! textobj#ruby#class() abort "{{{
  return textobj#ruby#recursive('\v^\s*class>')
endfunction "}}}

function! textobj#ruby#saved_view(meth) abort "{{{
  let saved_view = winsaveview()
  let result = call('textobj#ruby#' . a:meth, [])
  call winrestview(saved_view)
  return result
endfunction "}}}

function! s:pos(line) abort "{{{
  return [0, a:line, 0, 0]
endfunction "}}}

function! textobj#ruby#a(meth) abort "{{{
  let s:inner = 0
  let [top, bottom] = textobj#ruby#saved_view(a:meth)
  if g:textobj_ruby_inclusive && v:operator != 'c'
    while(top > 1 && getline(top - 1) =~ '^\s*$\|^\s*#')
      let top -= 1
    endwhile
  endif
  return ['V', s:pos(top), s:pos(bottom)]
endfunction "}}}

function! textobj#ruby#i(meth) abort "{{{
  let s:inner = 1
  let [top, bottom] = textobj#ruby#saved_view(a:meth)
  return ['V', s:pos(top + 1), s:pos(bottom - 1)]
endfunction "}}}

function! textobj#ruby#a_block() abort "{{{
  return textobj#ruby#a('block')
endfunction "}}}

function! textobj#ruby#a_func() abort "{{{
  return textobj#ruby#a('func')
endfunction "}}}

function! textobj#ruby#a_class() abort "{{{
  return textobj#ruby#a('class')
endfunction "}}}

function! textobj#ruby#i_block() abort "{{{
  return textobj#ruby#i('block')
endfunction "}}}

function! textobj#ruby#i_func() abort "{{{
  return textobj#ruby#i('func')
endfunction "}}}

function! textobj#ruby#i_class() abort "{{{
  return textobj#ruby#i('class')
endfunction "}}}
