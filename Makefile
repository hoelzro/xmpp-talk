TEX_FILES=$(shell ls *.tex)
EXAMPLES=$(shell ls examples/*)
EPS=$(shell ls *.eps)

all: xmpp-talk.pdf

%.pdf : %.dvi
	dvipdf $< $@

%.ps  : %.dvi
	dvips -o $@ $<

%.dvi : %.tex $(TEX_FILES) $(EXAMPLES) $(EPS)
	latex -shell-escape $<

clean:
	rm -f *.ps *.pdf *.aux *.log *.dvi *.out *.pyg
