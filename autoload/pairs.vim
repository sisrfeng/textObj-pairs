fun! pairs#process(chars, oprange)

   let s:save_cursor = getpos('.')
   let s:chars       = a:chars
   let s:oprange     = a:oprange
   let s:success     = 0
   let s:single_char = strlen(s:chars) == 1 ? 1 : 0
   let s:pattern     = s:single_char ? escape(s:chars, '^.~$') : '['.s:chars.']'

   " Match under cursor... {{{1
   if match(getline('.'), s:pattern, col('.') - 1) == col('.') - 1
      let char = s:single_char ? s:chars : getline('.')[col('.') - 1]
      if strlen(substitute(getline('.'), '[^'.char.']', '', 'g')) > 1
         let s:success = 1
         " ...forming a pair to the right
         let [l, c] = searchpos (escape(char, '^.~$'), 'n', line('.'))
         if c != 0
            if s:oprange == 'a'
               execute 'normal!  vf'.char
            " @@ case
            elseif c > s:save_cursor[2] + 1
               execute 'normal! lvt'.char
            en
         " ...or to the left
         el
            if s:oprange == 'a'
               execute 'normal! vF'.char
            el
               let [l, c] = searchpos (escape(char, '^.~$'), 'nb', line('.'))
               if c < s:save_cursor[2] - 1
                  execute 'normal! hvT'.char
               en
            en
         en
      en
   en

   if !s:success
      " @  X   @ cursor between a pair on the current line {{{1
      fun! s:Cursor_between(lchars)
         let pattern = s:single_char ? escape(a:lchars, '^.~$') : '['.a:lchars.']'
         " Look for first match to the left...
         if search (pattern, 'b', line('.'))
            let lchar = s:single_char ? a:lchars : getline('.')[col('.') - 1]
            " ...and check for a closing one to the right
            if search (escape(lchar, '^.~$'), 'n', line('.'))
               let s:success = 1
               if s:oprange == 'a'
                  execute 'normal!  vf'.lchar
               el
                  execute 'normal! lvt'.lchar
               en
            en
            return lchar
         en
      endf

      let chars = s:chars
      let char  = s:Cursor_between(chars)
      if !s:single_char
         while !s:success && char != ''
            let chars = substitute(chars, char, '', 'g')
            let char  = s:Cursor_between(chars)
         endwhile
      en

      if !s:success
         " X  @   @ cursor before a pair {{{1
         fun! s:Cursor_before(stop_line)
            while search (s:pattern, '', a:stop_line)
               let char = s:single_char ? s:chars : getline('.')[col('.') - 1]
               if strlen(substitute(getline('.'), '[^'.char.']', '', 'g')) > 1
                  let s:success = 1
                  if s:oprange == 'a'
                     execute 'normal! vf'.char
                  el
                     " @@ case
                     let [l, c] = searchpos (escape(char, '^.~$'), 'n', line('.'))
                     if c > col('.') + 1
                        execute 'normal! lvt'.char
                     el
                        " This is a pseudo solution as ideally I wanna cancel
                        " the omap which the return below fails to do (l.139: same)
                        call setpos('.', s:save_cursor)
                        " return "\<esc>"
                     en
                  en
                  break
               en
            endwhile
         endf

         call setpos('.', s:save_cursor)
         " ↓ look for a match after the cursor, also past the current line
         call s:Cursor_before(line('w$'))
         if !s:success
            goto
            " ↻ match after the cursor past the EOF
            call s:Cursor_before(s:save_cursor[1])
         en
      en
   en " }}}1

   if !s:success
      call setpos('.', s:save_cursor)
      echohl ErrorMsg | echo 'Nothing to do' | echohl None
      " return "\<esc>"
   " ex: ci@ when X @@
   " my_changedtick == ... can't happen because pairs#process doesn't do any changes !
   " elseif my_changedtick == b:changedtick && v:operator != 'y' || mode() != 'v'
      " echohl ErrorMsg | echo 'Nothing to do' | echohl None
   en

endf
