"""""""""""""""""""""""""""" COLORING """"""""""""""""""""""""""""
syntax match Final '\<[A-Z][A-Z0-9]\+\%(_[A-Z0-9]\+\)*\>'
syntax cluster javaTop add=Final

syn match    javaFunctionCall "\w\+\s*(\@="
syntax cluster javaTop add=javaFunctionCall

syntax match ClassName '\<\([A-Z][a-z0-9]*\)\+\>'
syntax cluster javaTop add=ClassName



hi Final gui=bold guifg=violet
hi javaFunctionCall guifg=#f8c527
hi ClassName gui=bold guifg=LightSeaGreen

hi javaParen           guifg=khaki
hi javaParen1          guifg=gold
hi javaParen2          guifg=PeachPuff1

""hi javaBranch		guifg=#6c995c
""hi javaConditional	guifg=#8aaee6
"hi link Conditional     ReservedWord
""hi javaRepeat		guifg=#9999ff
"hi link Repeat          ReservedWord
""hi javaStorageClass	guifg=#cc7a90
""hi javaMethodDecl	guifg=#8c1111
""hi javaClassDecl	guifg=#cc7e7e
""hi javaScopeDecl	guifg=#ff5a1f
""hi StorageClass         guifg=#ff5a1f
"hi link StorageClass    ReservedWord
""hi javaExceptions	guifg=#6f4d80
"hi ReservedWord         guifg=#ff5a1f
"hi Exception            guifg=#cc7e7e
"
""hi javaTypedef		guifg=#d29eff
"hi TypeDef              guifg=#ff5a1f
"
""hi javaType		guifg=#dea28c
"hi link Operator        Type
"
""hi javaLambdaDef	guifg=#99645c
""hi javaVarArg		guifg=#b29b6b
""hi javaBraces		guifg=#ddff99
"hi Function             guifg=#f1c438
"hi javaDocParam		guifg=#fb95fb
"
""hi javaUserLabelRef	guifg=#99ffc2
""hi javaUserLabel	guifg=#4d6f80
"hi Label		guifg=#6bb3ae
"
""hi javaAssert		guifg=#d982d3
""hi javaStatement	guifg=#86d3d9
"hi Statement            guifg=#99645c
"
""hi javaSpecial		guifg=#bf7117
""hi javaDocTags		guifg=#26d14f
""hi htmlComment		guifg=#eb59a7
""hi htmlCommentPart	guifg=#815485
"hi Special              guifg=#26d14f
"
""hi javaSpecialChar	guifg=#84118c
"hi SpecialChar          guifg=#24f413
"
""hi javaCharacter	guifg=#c0cc18
"hi Character	        guifg=#c0cc18
"
""hi javaExternal		guifg=#6a915c
"" vim: ts=8
