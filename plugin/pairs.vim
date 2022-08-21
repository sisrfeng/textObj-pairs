" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
    " https://github.com/kurkale6ka/vim-pairs
"
"
" New punctuation text objects:
"
    "    ci/  di;  yi*  vi@     ...
    "    ca/  da;  ya*  va@     ...
    "
        "    ciq (or "") changes content inside ANY kind of quotes
        "    vaq, yiq ...
    "
    "    ci<space>, da<space> ... modify ANY punctuation object
"
"
" TODO: Fix @@ and stopinsert if nothing to do after cix !!!

" 有了ciq, viq等,  不再需要了:
"
      " nno c' :call DoubleAsSingle()<CR>ci'
      " nno v' :call DoubleAsSingle()<CR>vi'
      " nno y' :call DoubleAsSingle()<CR>yi'
      " nno d' :call DoubleAsSingle()<CR>da'
      "
      " nno c" ci"
      "
    " func! DoubleAsSingle()
    "     " When [!] is added, error messages will also be skipped,
    "     " and commands and mappings will not be aborted
    "     " when an error is detected.  |v:errmsg| is still set.
    "     let v:errmsg = ""
    "     silent! :s#\"\([^"]*\)\"#'\1'#g
    "                 " 双引号中间夹着任意 非双引号字符
    "
    "         " silent:   Normal messages will 消失掉
    "         " When [!] is added, even when an error is detected.  commands and mappings will not be aborted
    "     if (v:errmsg == "")
    "         echo "双变单"
    "     en
    " endfunc


let g:loaded_ptext_objects = 1

let s:savecpo   = &cpoptions
let s:savemagic = &magic
set cpoptions&vim magic

"\ m for match
for m in [
      \'<bar>',
      \'<bslash>',
      \'#',
      "\ ',', 逗号 留作他用: di,  map成   di<
      \'.',
      \'?',
      \'/',
      \'!',
      \'$',
      \'%',
      \'^',
      \'&',
      \'*',
      \'_',
      \'-',
      \'+',
      \'=',
      \':',
      \';',
      \'@',
      "\ \'\~',
      \]
" 这里面 常用的并不多

            " 字符串拼接太难看了.  最终结果, 类似:
                "\ vim, dim等 不过用space代替m就行?
    exe      'ono   <silent>   im'   " :<c-u>call pairs#process('" . m . "'" . ", 'i')<cr>"
    exe      'ono   <silent>   am'   " :<c-u>call pairs#process('" . m . "'" . ", 'a')<cr>"
    exe      'xno   <silent>   im'   " :<c-u>call pairs#process('" . m . "'" . ", 'i')<cr>"
    exe      'xno   <silent>   am'   " :<c-u>call pairs#process('" . m . "'" . ", 'a')<cr>"
             ono i, i<
             ono a, a<
             " c, 代替ci< 少敲一个i
             nno c, ci<
             nno v, vi<
             nno y, yi<
             nno d, da<
endfor

omap     <silent> iq     <plug>Pairs_In_Quote
xmap     <silent> iq     <plug>Pairs_In_Quote
ono      <silent>           <plug>Pairs_In_Quote    :<c-u>call pairs#process("'`#" . '"', 'i')<cr>
xno      <silent>           <plug>Pairs_In_Quote    :<c-u>call pairs#process("'`#" . '"', 'i')<cr>

omap     <silent> aq     <plug>Pairs_A_Quote
ono      <silent>        <plug>Pairs_A_Quote :<c-u>call pairs#process("'`#" . '"', 'a')<cr>
xmap     <silent> aq     <plug>Pairs_A_Quote
xno      <silent>        <plug>Pairs_A_Quote :<c-u>call pairs#process("'`#" . '"', 'a')<cr>

"\ 这里的头和尾都是相同的,
"而'matchpairs'的头和尾是不同的, 比如:
                        " (){}[]<> ?
                        "\ :help matchpairs
    "
omap  <silent> i<space>     <plug>Pairs_In_All
ono   <silent>              <plug>Pairs_In_All :<c-u>call pairs#process('-`!"$%^&*_+=:;@~#<bar><bslash>,.?/'."'", 'i')<cr>
xmap  <silent> i<space>     <plug>Pairs_In_All
xno   <silent>              <plug>Pairs_In_All :<c-u>call pairs#process('-`!"$%^&*_+=:;@~#<bar><bslash>,.?/'."'", 'i')<cr>

omap  <silent> a<space>     <plug>Pairs_A_All
ono   <silent>              <plug>Pairs_A_All :<c-u>call pairs#process('-`!"$%^&*_+=:;@~#<bar><bslash>,.?/'."'", 'a')<cr>
xmap  <silent> a<space>     <plug>Pairs_A_All
xno   <silent>              <plug>Pairs_A_All :<c-u>call pairs#process('-`!"$%^&*_+=:;@~#<bar><bslash>,.?/'."'", 'a')<cr>

nmap  <silent> ''           <plug>Pairs_Quotesa
nno   <silent>                    <plug>Pairs_Quotes :normal ciq<cr>

let &cpoptions = s:savecpo
let &magic     = s:savemagic
unlet s:savecpo s:savemagic
