let s:comment = '\v\s*[^#]?\s*'
let s:start = '\v^\zs' . s:comment . g:ruby_block_openers
let s:end = '\v^' . s:comment . '<end>\zs'

function! textobj#ruby#skip() abort "{{{
    return getline('.') =~ '\v\S\s<%(if|unless)>\s\S'
endfunction "}}}

function! textobj#ruby#bounds() abort "{{{
  let flags = 'Wcn'
  let skip = 'textobj#ruby#skip()'
  call cursor(0, 2)
  let bottom = searchpair(s:start, '', s:end, flags, skip)
  let top = searchpair(s:start, '', s:end, flags . 'b', skip)
  if !(bottom || top)
    let [bottom, top] = [0, 0]
  endif
  call cursor(bottom, 0)
  return [top, bottom]
endfunction "}}}

function! textobj#ruby#block() abort "{{{
  echom mode()
  if mode() == 'V'
    call cursor(line('.') - 1, 2)
  endif
  return textobj#ruby#bounds()
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
  let [top, bottom] = textobj#ruby#saved_view(a:meth)
  if g:textobj_ruby_inclusive && v:operator != 'c'
    while(top > 1 && getline(top - 1) =~ '^\s*$\|^\s*#')
      let top -= 1
    endwhile
  endif
  return ['V', s:pos(top), s:pos(bottom)]
endfunction "}}}

function! textobj#ruby#i(meth) abort "{{{
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
