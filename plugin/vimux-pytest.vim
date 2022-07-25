" Backwards compatibility
command! RunAllPytests :call RunPytestBuffer()
command! RunFocusedPytests :call RunPytestFocused()

command! RunPytest :call _run_pytests("")
command! RunPytestBuffer :call RunPytestBuffer()
command! RunPytestFocused :call RunPytestFocused()

function! RunPytestBuffer()
  call _run_pytests(expand("%"))
endfunction

function! RunPytestFocused()
  let test_class = _pytest_search("class ")
  let test_name = _pytest_search("def test_")

  if test_class == "" || test_name == ""
    echoerr "Couldn't find class and test name to run focused test."
    return
  endif

  call _run_pytests(expand("%") . ":" . test_class . "." . test_name)
endfunction

function! _pytest_search(fragment)
  let line_num = search(a:fragment, "bs")
  if line_num > 0
    ''
    return split(split(getline(line_num), " ")[1], "(")[0]
  else
    return ""
  endif
endfunction

function! _run_pytests(test)
  call VimuxRunCommand(_virtualenv() . "pytest " . a:test)
endfunction

function! _virtualenv()
  if exists("g:PytestVirtualenv")
    return g:PytestVirtualenv . " "
  else
    return ""
  end
endfunction
