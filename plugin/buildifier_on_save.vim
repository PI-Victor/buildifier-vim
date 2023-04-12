" Define an autocmd to run buildifier on save
augroup BuildifierOnSave
  autocmd!
  autocmd BufWritePost BUILD.bazel,*.bzl,WORKSPACE call s:RunBuildifier()
augroup END

function! s:RunBuildifier()
  " Check if buildifier is available
  let l:buildifier = system("which buildifier")
  if v:shell_error != 0
    echoerr "buildifier not found in PATH"
    return
  endif

  " Run buildifier on the current file
  let l:cmd = "buildifier -mode=fix " . expand('%:p')
  call system(l:cmd)
  if v:shell_error == 0
    " Reload the file
    silent! execute 'edit' fnameescape(expand('%'))
    echo "buildifier applied"
  else
    echoerr "buildifier failed"
  endif
endfunction
