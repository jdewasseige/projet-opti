NAME=rapport
COMPILER=latexmk

all: $(NAME).tex
	$(COMPILER) -pdf -pdflatex="pdflatex -shell-escape -enable-write18" \
		-use-make -auxdir=file -outdir=file $(NAME).tex ;
	shopt -s extglob ;
	cp file/*.pdf ./

clean:
	rm -rf ./file
