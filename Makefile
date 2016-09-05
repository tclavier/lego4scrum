CLEAN=*~ *.rtf *.ps *.log *.dvi *.aux *.pdf *.out *.html *.css *.bak *.toc *.pl *.4ct *.4tc *.lg *.sxw *.tmp *.xref *.idv *.tns *.snm *.nav
INIT=*.odt
CLS=*~ *.log *.aux *.out *.bak *.toc *.pl
TEXFILES = $(wildcard *.tex)
INPUTFILES = $(wildcard input/*.tex)
SQLFILES = $(wildcard *.sql)
PSFILES = $(patsubst %.tex,%.ps,$(TEXFILES))

all: ps

%.ps: %.dvi
	dvips -Ppdf $< -o $@

%.dvi: %.tex
	latex $<
#	latex $<

%.rtf: %.tex
	latex2rtf $<

%.pdf: %.tex
	pdflatex  $<
	pdflatex  $<

%.html: %.tex
	latex2html -split 0 -no_subdir -info 0 -no_navigation -no_auto_link $<

%.lpr.ps: %.ps
	#cat $< | psbook | psnup -2 > $@
	cat $< | psnup -2 > $@
	
%.sxw: %.tex
	/usr/share/tex4ht/oolatex $<

clean:
	-rm -f $(CLEAN)

init: clean
	rm -f $(INIT)

ps: $(PSFILES) $(INPUTFILES)
pdf: $(patsubst %.tex,%.pdf,$(TEXFILES)) 
sxw: $(patsubst %.tex,%.sxw,$(TEXFILES)) 
rtf: $(patsubst %.tex,%.rtf,$(TEXFILES))
html: $(patsubst %.tex,%.html,$(TEXFILES))
lpr: $(patsubst %.tex,%.lpr.ps,$(TEXFILES))
tout: html pdf ps rtf sxw
ftp: tout
	rm -f $(CLS)
	if [ ! -d $(FTP_DIR) ] ; then mkdir $(FTP_DIR); fi
	cp $(TEXFILES) *.pdf *.rtf *.html *.png *.css $(FTP_DIR)
