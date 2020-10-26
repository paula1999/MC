#!/bin/bash

# Convertir el archivo latex a lenguaje en markdown
flex Convertir.l
gcc lex.yy.c -o Convertir -lfl
./Convertir Ejemplo_latex.tex

# Convertir el archivo latex a pdf
pdflatex Ejemplo_latex.tex

# Convertir el archivo markdown a pdf
pandoc Ejemplo_md.md -o Ejemplo_md.pdf
