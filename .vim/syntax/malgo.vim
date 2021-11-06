syntax keyword malgoModule module
syntax keyword malgoForeign foreign
syntax keyword malgoImport import
syntax keyword malgoData data
syntax keyword malgoType type
syntax keyword malgoLet let
syntax keyword malgoInfix infix infixl infixr

syntax match malgoOperators "[+\-*/\\%=><:;|&!.][+\-*/\\%=><:;|&!.#]*"

syn region malgoString start=+"+ skip=+\\\\\|\\"+ end=+"+
  \ contains=@Spell
syn match malgoNumber "\<[0-9]\+L\>\|\<[0-9]\+\>"

syntax keyword malgoTodo TODO FIXME contained

syntax match malgoLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
  \ contains=
  \ malgoTodo,
  \ @Spell
syntax region malgoBlockComment start="{-" end="-}"
  \ contains=
  \ malgoBlockComment,
  \ malgoTodo,
  \ @Spell

highlight def link malgoModule Keyword
highlight def link malgoForeign Structure
highlight def link malgoImport Include
highlight def link malgoData Keyword
highlight def link malgoType Keyword
highlight def link malgoLet Keyword
highlight def link malgoInfix Keyword

highlight def link malgoOperators Operator

highlight def link malgoString String
highlight def link malgoNumber Number

highlight def link malgoLineComment Comment
highlight def link malgoBlockComment Comment
highlight def link malgoTodo Todo
