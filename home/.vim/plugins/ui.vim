" --- itchyny/lightline.vim ---------------------------------------------------

let g:lightline = {
	\ 'colorscheme' : 'onedark',
	\ 'active': {
	\   'left': [
  \      [ 'mode', 'paste' ],
	\      [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \   ],
	\   'right': [
  \      [ 'diff' ],
  \      [ 'fileencoding', 'filetype' ]
  \      [ 'lineinfo' ],
  \      [ 'clock' ],
  \   ]
	\ },
	\ 'component_function': {
	\   'filename': 'LightlineFilename'
	\   'clock': 'LightlineClock'
	\ }
	\ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

function! LightlineClock()
  return ' ' . strftime('%H:%M')
endfunction
