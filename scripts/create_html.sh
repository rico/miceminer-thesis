#!/bin/bash

###########################################
# create master thesis html with latex2html
#
# rleuthold@access.ch - 9.4.2009
###########################################

/opt/local/bin/latex2html -debug -noreuse -tmp tmp -noinfo -t "Master Thesis miceminer" -contents_in_navigation -address "<a href='mailto:rleuthold@access.ch'>rleuthold@access.ch</a>" -style=style/style.css -dir ../out/html/ src/thesis.tex