" list of modular Vim config files
let s:configs = ["options.vim", "autocmds.vim", "keymaps.vim", "plugins.vim"]

" source each file if it exists
for cfg in s:configs
	let path = expand('~/.vim/config/' . cfg)

	if filereadable(path)
		execute 'source' fnameescape(path)
	endif
endfor
