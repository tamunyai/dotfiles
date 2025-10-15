" --- automatically reload files changed outside of Vim -----------------------
" augroup vim_autoread
" 	autocmd!
" 	autocmd FocusGained,BufEnter *
" 		\ if &buftype !=# 'nofile' | checktime | endif
" augroup END

" --- remove trailing whitespace on save --------------------------------------
augroup vim_trim_whitespace
	autocmd!
	autocmd BufWritePre * :%s/\s\+$//e
augroup END

" --- highlight text on yanked (visual feedback) ------------------------------
" augroup vim_yank_highlight
" 	autocmd!
" 	autocmd TextYankPost *
" 		\ silent! lua vim.highlight.on_yank()
" augroup END

" --- automatically equalize split sizes when resizing Vim window -------------
" augroup vim_resize_splits
"   autocmd!
"   autocmd VimResized * wincmd =
" augroup END

" --- restore last cursor position when reopening files -----------------------
augroup vim_restore_cursor
	autocmd!
	autocmd BufReadPost *
		\ if !&diff && &buftype ==# "" && index(['gitcommit'], &filetype) < 0 |
		\   if line("'\"") > 0 && line("'\"") <= line("$") |
		\     exe "normal! g`\"" |
		\   endif |
		\ endif
augroup END

" --- automatically detect filetype for environment/config files --------------
augroup vim_filetypes
	autocmd!
	autocmd BufNewFile,BufRead .env,.env*,*env set filetype=sh
augroup END

" --- enable word wrapping and spell check for specific file types ------------
augroup vim_text_wrap_spell
	autocmd!
	autocmd FileType text,plaintex,typst,markdown,gitcommit
		\ setlocal wrap spell spelllang=en_us linebreak
augroup END

" --- disable auto comment continuation on newlines ---------------------------
" augroup vim_disable_auto_comment
" 	autocmd!
" 	autocmd FileType * setlocal formatoptions-=cro
" augroup END

" --- auto reload vimrc automatically on save ---------------------------------
augroup vim_auto_reload_rc
 	autocmd!
 	autocmd BufWritePost $MYVIMRC,~/.vim/config/*.vim
 		\ source $MYVIMRC
 augroup END

" --- fix conceallevel for JSON files -----------------------------------------
augroup vim_json_fix
	autocmd!
	autocmd FileType json,jsonc,json5 setlocal conceallevel=0
augroup END

" --- auto-create missing directories on save ---------------------------------
augroup vim_mkdir
	autocmd!
	autocmd BufWritePre *
		\ if expand('<afile>') !=# '^\w\+://' |
		\ 	call mkdir(fnamemodify(expand('<afile>'), ':p:h'), 'p') |
		\ endif
augroup END

" --- close certain help/info-type windows with 'q' ---------------------------
augroup vim_quick_close
	autocmd!
	autocmd FileType PlenaryTestPopup,help,lspinfo,man,notify,qf,query,spectre_panel,startuptime,tsplayground,neotest-output,checkhealth,neotest-summary,neotest-output-panel,gitsigns.blame,fugitive,git
		\ setlocal bufhidden=hide |
		\ nnoremap <silent> <buffer> q :close<CR>
augroup END

" --- automatically save modified buffers when leaving buffer or losing focus -
augroup vim_autosave
	autocmd!
	autocmd BufLeave,FocusLost *
		\ if &modified && !&readonly && expand("%") !=# "" && &buftype ==# "" |
		\ 	silent update |
		\ endif
augroup END

" --- automatically format files on save (if tool exists) ---------------------
" function! s:SmartFormat() abort
" 	if &filetype ==# 'json' && executable('jq')
" 		silent! %!jq .
"
" 	elseif &filetype ==# 'yaml' && executable('yq')
" 		silent! %!yq .
"
" 	elseif &filetype ==# 'sh' && executable('shfmt')
" 		silent! %!shfmt
"
" 	elseif &filetype ==# 'python' && executable('black')
" 		silent! !black -q %
" 		edit!
" 	endif
" endfunction

" augroup vim_smart_format
" 	autocmd!
" 	autocmd BufWritePre *.json,*.yaml,*.yml,*.sh,*.py call s:SmartFormat()
" augroup END
