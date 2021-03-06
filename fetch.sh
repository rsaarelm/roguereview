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
get http://sourceforge.net/projects/avanor/files/avanor/0.5.8/avanor-0.5.8-src.tar.bz2
get https://cjshayward.com/wp-content/sourcecode/tms2_0.tar.gz
get http://downloads.sourceforge.net/project/sc2/UQM/0.7/uqm-0.7.0-source.tgz
get http://pesky-reticulans.org/game/prime_src-2.4.tar.bz2
get http://nethack4.org/media/releases/nethack4-4.3-beta2.zip

if [ ! -f cataclysm2.zip ]
then
    wget https://github.com/Whales/Cataclysm2/archive/master.zip -O cataclysm2.zip
fi

cd -

for x in cache/*.tar.gz; do tar xzvf $x; done
for x in cache/*.tar.bz2; do tar xjvf $x; done
for x in cache/*.tgz; do tar xzvf $x; done

unzip -o cache/gh-1100-src.zip
mkdir -p moria; cd moria; unzip -o ../cache/mor552cs.zip; cd -
unzip -o cache/rogue-libc5-ncurses.zip; tar xzvf rogue-libc5-ncurses.tar.gz; rm rogue-libc5-ncurses.tar.gz

if [ ! -d incursion ]; then git clone https://bitbucket.org/rmtew/incursion-roguelike.git incursion; fi

if [ ! -d ja2-stracciatella ]; then git clone https://bitbucket.org/gennady/ja2-stracciatella.git; fi

unzip -o cache/cataclysm2.zip
