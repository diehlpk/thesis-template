viewer = evince
editor = gedit

# Main file name and literature list
MASTER_TEX = ausarbeitung.tex
LITERATURE = bibliography/bibliography.bib

#latex = pdflatex -shell-escape
#MiKTeX:
latex = latexmk 
bibtex = biber

SRC = $(shell basename $(MASTER_TEX) .tex)
TEX_FILES = $(wildcard preambel/*.tex content/*.tex)

PDF = $(SRC).pdf
AUX = $(SRC).aux

date=$(shell date +%Y%m%d%H%M)

all: $(PDF)
.PHONY: $(PDF)

$(PDF): $(TEX_FILES) 
	$(latex) -pdf $(MASTER_TEX)


clean: 
	$(latex) -C

final: $(PDF)
	thumbpdf $(PDF)
	$(latex) $(MASTER_TEX)

mrproper: clean
	rm -f *~

pdf: $(PDF)
	latexmk -pdf ${MASTER_TEX}

view: pdf
	$(viewer) $(PDF)&

edit:
	$(editor) $(MASTER_TEX)&

stand: $(PDF)
	cp $(PDF) "Ausarbeitung - Stand $(date).pdf"
aspell: 
	for tex in $(TEX_FILES);	\
		do	\
			aspell -t -l de_DE -T utf-8 -c $$tex --encoding=utf-8;	\
		done
#
##

html: clean pdf
	rm $(AUX)
	htlatex $(SRC)

fetchtitlebonn:
	wget http://www.mathematics.uni-bonn.de/files/bachelor/ba_titelseite.zip
	unzip -p ba_titelseite.zip BA_Titelseite_2014/BA_Titelseite.sty > BA_Titelseite.sty

