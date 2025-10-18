nnoremap <leader>w :w<CR>														" save the current file
nnoremap <leader>q :q<CR>														" quit the current window
nnoremap <leader>qq :qa<CR>													" quit all

" --- indent and outdent in visual mode ---------------------------------------
vnoremap < <gv
vnoremap > >gv

" paste without overwriting unnamed register ----------------------------------
vnoremap p "_dP

" --- buffer navigation -------------------------------------------------------
nnoremap <Tab> :bprevious<CR>
nnoremap <S-Tab> :bnext<CR>
nnoremap <leader>` :e #<CR>

" --- clear search highlights when pressing <Esc> -----------------------------
nnoremap <esc> :noh<cr><esc>
inoremap <esc> <esc>:noh<cr><esc>

" --- use gj/gk instead of j/k if no count is provided ------------------------
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
xnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
xnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" --- move lines up and down --------------------------------------------------
nnoremap J :m .+1<CR>==
nnoremap K :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" --- n/N follow search direction properly even after reverse search ----------
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

" --- execute current file ----------------------------------------------------
function! ExecuteCurrentFile() abort
	if expand('%') != ''
		write 	                                     		" save file if modified
	else
		echo "vim: cannot execute unnamed file. please save it first!"
		return
	endif

	let l:file = expand('%:p')												" full path of current file
	let l:base = expand('%:t:r')											" base filename without extension
	let l:ft = &filetype															" current filetype

	if l:ft ==# 'python'
		execute 'botright terminal python3 -u ' . l:file

	elseif l:ft ==# 'javascript'
		execute 'botright terminal node ' . l:file

	elseif l:ft ==# 'sh'
		execute 'botright terminal bash ' . l:file

	elseif l:ft ==# 'cpp'
		execute 'botright terminal bash -c "g++ ' . l:file . ' -o ' . l:base . ' && ./' . l:base . ' && rm -f ' . l:base . '"'

	elseif l:ft ==# 'c'
		execute 'botright terminal bash -c "gcc ' . l:file . ' -o ' . l:base . ' && ./' . l:base . ' && rm -f ' . l:base . '"'

	else
		echo "vim: this file type is not supported for execution: " . l:ft
		return
	endif

	let l:term_buf = bufnr('')											" get the buffer number of the new terminal
	startinsert  																		" enter insert mode in terminal

	" map 'q' to close this terminal buffer
	execute 'tnoremap <buffer> <silent> q <C-\><C-n>:q<CR>'
	execute 'nnoremap <buffer> <silent> q :q<CR>'
	execute 'setlocal bufhidden=hide noswapfile'
endfunction

nnoremap <leader>ef :call ExecuteCurrentFile()<CR>
