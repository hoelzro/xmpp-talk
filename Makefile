TEX_FILES=$(shell ls *.tex)
EXAMPLES=$(shell ls examples/*)

all: xmpp-talk.pdf

%.pdf : %.dvi
	dvipdf $< $@

%.ps  : %.dvi
	dvips -o $@ $<

%.dvi : %.tex $(TEX_FILES) $(EXAMPLES)
	latex -shell-escape $<

clean:
	rm -f *.ps *.pdf *.aux *.log *.dvi *.out *.pyg
