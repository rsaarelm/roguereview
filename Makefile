src := $(wildcard *.md)
targ := $(src:%.md=%.pdf)

all: $(targ)

%.pdf: %.md
	pandoc $< -o $@
	@echo "Generated $@ with `pdfinfo $@ | grep Pages | awk '{print $$2}'` pages."

clean:
	rm -f $(targ)
