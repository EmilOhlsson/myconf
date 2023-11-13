; inherits: cpp
((comment) @todo
 (#match? @todo "TODO:"))
((comment) @note
 (#match? @note "NOTE:"))

(declaration
  declarator: [(identifier) @declaration.identifier
               (_ declarator: (identifier) @declaration.identifier)
               (field_identifier) @declaration.identifier])
