#!/bin/bash

function get {
if [ ! -f `basename $1` ]
then
	wget $1
fi
}

mkdir -p cache/
cd cache

# URLs collected 2013-11-16

get http://www.roguelikedevelopment.org/archive/files/sourcecode/rogue-libc5-ncurses.zip
get http://downloads.sourceforge.net/project/ularn/ularn/Ularn-1.5ishPL4/Ularn-1.5ishPL4.tar.gz
get http://www.roguelikedevelopment.org/archive/files/sourcecode/mor552cs.zip
get http://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz
get http://rephial.org/downloads/3.4/angband-v3.4.1.tar.gz
get http://www.chiark.greenend.org.uk/~mpread/dungeonbash/archive-1.7/dungeonbash-1.7.tar.gz
get http://www.zincland.com/powder/release/powder117_src.tar.gz
get http://www.alcyone.com/binaries/omega/omega-0.90.4-src.tar.gz
get https://sites.google.com/site/broguegame/brogue-linux-1.7.3.tar.gz
get http://downloads.sourceforge.net/ivan/ivan-0.50.tar.gz
get http://homepages.cwi.nl/~aeb/games/hack/hack-1.0.3.tar.gz
get http://downloads.sourceforge.net/gearhead/gearhead/1.100/gh-1100-src.zip

cd -

for x in cache/*.tar.gz; do tar xzvf $x; done
for x in cache/*.tgz; do tar xzvf $x; done

unzip -o cache/gh-1100-src.zip
mkdir -p moria; cd moria; unzip -o ../cache/mor552cs.zip; cd -
unzip -o cache/rogue-libc5-ncurses.zip; tar xzvf rogue-libc5-ncurses.tar.gz; rm rogue-libc5-ncurses.tar.gz
