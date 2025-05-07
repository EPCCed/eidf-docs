all
exclude_rule 'MD033'
exclude_rule 'MD046'
rule 'MD013', :line_length => 500
rule 'MD026', :punctuation => '.,:;'
rule 'MD007', :indent => 4 # Parser will not indent at the default 3 spaces
