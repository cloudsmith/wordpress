(* Wordpress configuration module for Augeas
 Reference: PHP syntax
*)

module Wordpress
               = autoload xfm

(************************************************************************
 *                           USEFUL PRIMITIVES                          *
 ************************************************************************)

let newline    = /\r?\n/

let php_prolog = del (/<\?php[ \t]*/ . newline) "<?php\n"

let del_opt_ws_stem
               = del /[ \t\n\r]*/

let del_opt_ws = del_opt_ws_stem ""

let del_opt_ws_sp
               = del_opt_ws_stem " "

let del_opt_ws_nl
               = del_opt_ws_stem "\n"

(************************************************************************
 *                              COMMENTS                                *
 ************************************************************************)

let comment_c  = del_opt_ws . Util.del_str "/*"
                 . [ label "comment-c" . store ((/[^*]/ | /(\*\*)*\*[^\/]/)*) ]
                 . Util.del_str "*/"

let comment_cplusplus
               = del_opt_ws_sp . Util.del_str "//"
                 . [ label "comment-c++" . store ((/[^\n\r]/ | /(\r\r)*\r[^\n]/)*) ]
                 . del newline "\n"

let comment_shell
               = del_opt_ws_sp . Util.del_str "#"
                 . [ label "comment-sh" . store ((/[^\n\r]/ | /(\r\r)*\r[^\n]/)*) ]
                 . del newline "\n"

let comment    = comment_c | comment_cplusplus | comment_shell

(************************************************************************
 *                               ENTRIES                                *
 ************************************************************************)

let identifier = /[A-Za-z_\177-\377][0-9A-Za-z_\177-\377]*/

let quoted_identifier
               = (/'/ . identifier . /'/) | (/"/ . identifier . /"/)

let quoted_string
               = /"([^"]|\\.)*"/ | /'([^']|\\.)*'/

let boolean    = /(true|false)/i

let value      = quoted_string | boolean

let define     = del_opt_ws_nl . Util.del_str "define" . del_opt_ws . Util.del_str "(" . del_opt_ws
                 . [ key quoted_identifier . del_opt_ws . Util.del_str "," . del_opt_ws . store value ]
                 . del_opt_ws . Util.del_str ")" . del_opt_ws . Util.del_str ";"

let assignment = del_opt_ws_nl
                 . [ del /\$/ "$" . key identifier . del_opt_ws . Util.del_str "=" . del_opt_ws . store value ]
                 . del_opt_ws . Util.del_str ";"

let entry      = define | assignment

let footer     = del_opt_ws . [ label "footer" . (store /if[ \t\n\r]*\((.|\n)*/)? ]

(************************************************************************
 *                                LENS                                  *
 ************************************************************************)

let lns        = php_prolog . (comment|entry)* . footer

let filter     = incl "wp-config.php"

let xfm        = transform lns filter
