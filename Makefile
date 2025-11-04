
name       = cv
emacs 	   = emacs
latexmk    = latexmk/latexmk.pl
sources    = $(wildcard *.sty) $(wildcard *.tex) $(wildcard *.bib)
max_pages  = 3

$(info $(sources))

.PHONY: all en ja open clean allclean auto \
	submission archive clean-submission img

all: en

en: cv.pdf coverletter.pdf

$(name).tex:
	echo "\input{main.tex}" > $@

$(name).log $(name).fls: $(name).pdf

%.pdf: %.tex $(sources) img
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<

img:
	+$(MAKE) -C img

ifeq ($(UNAME), Darwin)
open: $(name).pdf
	open $< &>/dev/null
endif
ifeq ($(UNAME), Linux)
open: $(name).pdf
	nohup xdg-open $< &>/dev/null &
endif

auto:
	+./make-periodically.sh -j 1

clean: clean-submission
	-rm -r *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.elc *.pdf *.out \
		*.fdb_latexmk __* *.fls *.subm* \
		_minted*

allclean: clean
	$(MAKE) -C img clean
	rm target


