src := $(wildcard *.md)
targ := $(src:%.md=%.pdf)

all: $(targ)

%.pdf: %.md
	pandoc $< -o $@

clean:
	rm -f $(targ)
