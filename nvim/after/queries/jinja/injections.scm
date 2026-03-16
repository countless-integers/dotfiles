; extends
; Inject host language into jinja content nodes based on the buffer's filetype.
; Uses the custom is-filetype? predicate defined in tree-sitter.lua.
; The jinja grammar uses (content) for the non-jinja text between template tags.

((content) @injection.content
 (#is-filetype? "sh_jinja")
 (#set! injection.language "bash")
 (#set! injection.combined))

((content) @injection.content
 (#is-filetype? "yaml_jinja")
 (#set! injection.language "yaml")
 (#set! injection.combined))

((content) @injection.content
 (#is-filetype? "ini_jinja")
 (#set! injection.language "ini")
 (#set! injection.combined))

((content) @injection.content
 (#is-filetype? "json_jinja")
 (#set! injection.language "json")
 (#set! injection.combined))
