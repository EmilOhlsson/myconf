; inherits: c
((comment) @todo
 (#match? @todo "TODO:"))
((comment) @note
 (#match? @note "NOTE:"))

(declaration
  declarator: [(identifier) @declaration.identifier
	       (_ (identifier) @declaration.identifier)])
