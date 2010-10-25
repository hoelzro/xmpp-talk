all: xmpp-talk.pdf

%.pdf : %.dvi
	dvipdf $< $@

%.ps  : %.dvi
	dvips -o $@ $<

%.dvi : %.tex
	latex $<

clean:
	rm -f *.ps *.pdf *.aux *.log *.dvi
