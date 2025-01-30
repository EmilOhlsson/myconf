; inherits: c

; Simple TODO
((comment) @todo
 (#match? @todo "TODO:"))

;; Assigned TODO
((comment) @todo
 (#match? @todo "TODO[(][a-zA-Z_0-9]+[)]:"))

; Simple NOTE
((comment) @note
 (#match? @note "NOTE:"))

(declaration
  declarator: [(identifier) @declaration.identifier
               (_ declarator: (identifier) @declaration.identifier)
               (field_identifier) @declaration.identifier])
