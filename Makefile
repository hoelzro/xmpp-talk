TEX_FILES=$(shell ls *.tex)

all: xmpp-talk.pdf

%.pdf : %.dvi
	dvipdf $< $@

%.ps  : %.dvi
	dvips -o $@ $<

%.dvi : %.tex $(TEX_FILES)
	latex $<

clean:
	rm -f *.ps *.pdf *.aux *.log *.dvi *.out
