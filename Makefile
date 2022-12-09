
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

en: cv.pdf list-of-publications.pdf list-of-presentations.pdf list-of-prestigious.pdf list-of-major-media.pdf

$(name).tex:
	echo "\input{main.tex}" > $@

$(name).log $(name).fls: $(name).pdf

cv.pdf: cv.tex imgs $(sources)
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<
	cp $@ ~/Documents/US-document/2022-EB1/initiation/02/

list-of-%.pdf: list-of-%.tex imgs $(sources)
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<
	cp $@ ~/Documents/US-document/2022-EB1/initiation/06/


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


