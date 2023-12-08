; inherits: cpp
((comment) @todo
 (#match? @todo "TODO:"))
((comment) @note
 (#match? @note "NOTE:"))

(parameter_declaration
  declarator: [((identifier) @declaration.identifier)
	       (reference_declarator (identifier) @declaration.identifier)
	       (pointer_declarator (identifier) @declaration.identifier)
	       (array_declarator (identifier) @declaration.identifier)
	       (init_declarator (identifier) @declaration.identifier)])

(declaration
  declarator: [((identifier) @declaration.identifier)
	       (reference_declarator (identifier) @declaration.identifier)
	       (pointer_declarator (identifier) @declaration.identifier)
	       (array_declarator (identifier) @declaration.identifier)
	       (init_declarator (identifier) @declaration.identifier)])

(field_declaration
  declarator: [((field_identifier) @declaration.identifier)
	       (reference_declarator (field_identifier) @declaration.identifier)
	       (pointer_declarator (field_identifier) @declaration.identifier)
	       (array_declarator (field_identifier) @declaration.identifier)])
