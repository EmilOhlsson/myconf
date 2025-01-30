; inherits: python

;; Simple TODO
((comment) @todo
 (#match? @todo "TODO:"))

;; Assigned TODO
((comment) @todo
 (#match? @todo "TODO[(][a-zA-Z_0-9]+[)]:"))

;; Simple NOTE
((comment) @note
 (#match? @note "NOTE:"))
