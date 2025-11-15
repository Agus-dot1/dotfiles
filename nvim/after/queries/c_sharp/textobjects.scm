; Métodos
(method_declaration) @function.outer
(method_declaration body: (block) @function.inner)

; Constructores
(constructor_declaration) @function.outer
(constructor_declaration body: (block) @function.inner)

; Clases
(class_declaration) @class.outer
(class_declaration body: (declaration_list) @class.inner)
