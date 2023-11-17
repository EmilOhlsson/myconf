; inherits: cpp
((comment) @todo
 (#match? @todo "TODO:"))
((comment) @note
 (#match? @note "NOTE:"))

(_
  declarator: [(identifier) @declaration.identifier
               (field_identifier) @declaration.identifier])
