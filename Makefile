
name       = cv
reference  = asai-references.bib
emacs 	   = emacs
latexmk    = latexmk/latexmk.pl
styles     = mycv.sty
sources    =
max_pages   = 3

$(info $(sources))

.PHONY: all en ja open imgs clean allclean auto \
	submission archive clean-submission

all: en

en: $(name).pdf

$(name).tex:
	echo "\input{main.tex}" > $@

$(name).log $(name).fls: $(name).pdf

%.pdf: %.tex imgs $(sources)
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<
	cp $@ ~/Documents/US-document/2022-EB1/initiation/02/

ifeq ($(UNAME), Darwin)
open: $(name).pdf
	open $< &>/dev/null
endif
ifeq ($(UNAME), Linux)
open: $(name).pdf
	nohup xdg-open $< &>/dev/null &
endif

auto:
	+./make-periodically.sh

imgs:
	$(MAKE) -C img

clean: clean-submission
	-rm -r *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.elc $(name).pdf \
		*.fdb_latexmk __* *.fls *.subm* \
		_minted*

allclean: clean
	$(MAKE) -C img clean
	rm target


