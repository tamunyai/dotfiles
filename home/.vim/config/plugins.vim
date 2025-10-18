" directory where plugins will be installed
let s:plugin_dir = expand('~/.local/share/vim/plugged')

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
call s:EnsurePlugin('joshdick/onedark.vim')
call s:EnsurePlugin('itchyny/lightline.vim')
