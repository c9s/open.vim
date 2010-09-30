
" Author: Cornelius

let g:extension_mapping = {
  \':https?': [ 'google-chrome' ],
  \'pdf' : [ 'evince' , 'xpdf' ],
  \'pl'  : [ 'perl' ],
  \'html|htm': [ 'google-chrome' , 'firefox' ],
  \'bmp|png|jpg|jpeg' : [ 'gimp' ],
  \}

fun! s:get_applist(ext)
    return g:extension_mapping[ a:ext ]
endf

fun! s:get_extension_list()
    let keys = keys( g:extension_mapping )
    " cal filter( keys , 'v:val !~ ''^:'''  )
    return keys
endf

" echo s:get_extension_list()

fun! s:select_app( applist )
    for e in a:applist 
      if executable(e)
        return e
      endif
    endfor
    return
endf

fun! s:execute(cmd,args)
  cal system( a:cmd . ' ' . join( a:args , ' ' ) )
endf

fun! Open(uri)
  let app = ""
  for pattern in s:get_extension_list()
    if pattern =~ '^:' 
      let proto_pattern = strpart( pattern , 1 )
      if a:uri =~ '^\v' . proto_pattern . '://'
        let app = s:select_app( s:get_applist( pattern ) )
      endif
    elseif a:uri =~ '\.\v(' . pattern . ')$' 
      let app = s:select_app( s:get_applist( pattern ) )
    endif
  endfor

  " XXX: use minetype detection

  if strlen(app) > 0 
    cal system( app . " " . a:uri )
  else
    redraw
    echoerr "Application not found."
  endif
endf

" cal Open( '/home/c9s/1121.bmp' )
" cal Open( 'http://google.com/' )


" ===============================
" Plugin API
" ===============================
fun! OpenSetPrefer(ext,app)
  cal add( g:extension_mapping[ a:ext ] , a:app )
endf

fun! OpenRegisterExt(ext,applist) 
  let g:extension_mapping[ a:ext ] = a:applist
endf

com! -nargs=1 Open :call s:open(<q-args>)
