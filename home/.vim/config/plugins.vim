" directory where plugins will be installed
let s:plugin_dir = expand('~/.vim/plugins')

" ensure a plugin is installed and added to runtimepath
" usage: call s:EnsurePlugin('tpope/vim-sensible')
function! s:EnsurePlugin(repo) abort
	" extract plugin name from repo
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name

	" clone plugin if not already present
  if !isdirectory(path)
		" create plugin directory if missing
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif

		echom "Installing " . a:repo
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif

	" add to runtimepath if not already included
	if index(split(&runtimepath, ','), path) < 0
		execute 'set runtimepath+=' . fnameescape(path)
	endif
endfunction

call s:EnsurePlugin('junegunn/fzf')
call s:EnsurePlugin('junegunn/fzf.vim')

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fo :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fs :Rg <C-r><C-w><CR>
nnoremap <leader>fg :Rg<Space>
nnoremap <leader>fc :execute 'Rg ' . expand('%:t:r')<CR>
