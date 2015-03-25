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
GFX_FILES = $(wildcard graphics/*)

PDF = $(SRC).pdf
AUX = $(SRC).aux

date=$(shell date +%Y%m%d%H%M)

# was wird gemacht, falls nur make aufgerufen wird
#hier sollte noch der aspell check rein für jedes file einzeln über for schleife
all: $(PDF)
.PHONY: $(PDF)

$(PDF): $(TEX_FILES) $(GFX_FILES) $(SRC).bbl
	$(latex) -pdf $(MASTER_TEX)


clean: 
	$(latex) -C

# Endversion - mit eingebauter Seitenvorschau
# mehrere Durchlaeufe, da bei longtable einige runs mehr vonnoeten sind...
final: $(PDF)
	thumbpdf $(PDF)
	$(latex) $(MASTER_TEX)

mrproper: clean
	rm -f *~

ps: $(PDF)
	pdftops $(PDF)

pdf: $(PDF)

view: pdf
	$(viewer) $(PDF)&

edit:
	$(editor) $(MASTER_TEX)&

6: ps
	psnup -6 $(SRC).ps > 6.ps

stand: $(PDF)
	cp $(PDF) "Ausarbeitung - Stand $(date).pdf"

standps: ps
	psnup -2 $(SRC).ps > "Ausarbeitung - Stand $(date).ps"

##
# Das ganze am Besten vor der final und als eigene Version ala make spellcheck
# aspell line: aspell -t -l de_DE -d german -c --per-conf= "Dateiname" *.tex -T utf-8 --encoding=utf-8
# Schreiben der LaTeX-Befehle in eine config Dateiname. Sieht so aus
# add-tex-command begin PO // PO := prüfe []{} ;; po := ignoriere []{}
# Leerzeichen ungleich Tabs !!!
# Config File nicht vergessen
aspell: 
	for tex in $(TEX_FILES);	\
		do	\
			aspell -t -l de_DE -d german -T utf-8 -c $$tex --encoding=utf-8;	\
		done
#
##

html: clean pdf
	rm $(AUX)
	htlatex $(SRC)
#Fügt den Style für die Titelseite ein
fetchtitlebonn:
	wget http://www.mathematics.uni-bonn.de/files/bachelor/ba_titelseite.zip
	unzip -p ba_titelseite.zip BA_Titelseite/BA_Titelseite.sty > BA_Titelseite.sty

