NAME=rapport
COMPILER=latexmk

all: $(NAME).tex
	$(COMPILER) -pdf -pdflatex="pdflatex -shell-escape -enable-write18" \
		-use-make -auxdir=auxFile -outdir=auxFile $(NAME).tex ;
	shopt -s extglob ;
	cp auxFile/*.pdf ./

clean:
	rm -rf ./auxFile
