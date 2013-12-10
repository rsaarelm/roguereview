POWDER
======

Source code review by Risto Saarelma, 2013-12-10

Notes of Jeff Lait's POWDER, version 117.

POWDER is a somewhat NetHack influenced game designed to be played
on a GameBoy Advance.

Build system
------------

POWDER has some data-driven architecture, and generates sources from
text data files.

GameBoy Advance as a virtual machine architecture
-------------------------------------------------

Jeff Lait did a
[talk](http://gruesomegames.com/irdc2012/3.%20Jeff%20Lait%20-%20Porting%20Powder.pdf)
about porting POWDER in IRDC 2012. His basic approach is picking a
sufficiently low-level and simple abstraction layer (a 'bedrock') to
build the game on, and then port the bedrock to other platforms. The
GBA architecture he originally build Powder on ended up working as a
passable general bottom layer he just wrote an adapter on for other
platforms.

The features in GBA, graphics, the save game memory, the input
buttons, are just memory mapped instead of being defined by an API.
Lait thinks this worked well, from the presentation slides:

> Bedrock is
>
> - Easy to write
> - Highly fault resistant – garbage in doesn't crash


> Think of it as a hardware problem
>
> - Very simple interface
> - Memory model rather than API
>   Allow partial updates!
> - Should not be affected by new game features!
>   Should not occur to you to dive lower!

The GBA probably isn't the last word on a roguelike VM, but the more
hardware design oriented approach does seem promising. The
interactive fiction folk have seen massive success with virtual
machine game interpreters starting from Infocom's offerings from the
late 1970s.

Source code overview
--------------------

Some source files are generated from data files.

     8688   23953  200077 powder117_src/action.cpp
     2491    7238   55792 powder117_src/ai.cpp
      462    1339   11293 powder117_src/artifact.cpp
       80     256    1751 powder117_src/assert.cpp
      617    1877   13496 powder117_src/bmp.cpp
      491    1020    8096 powder117_src/buf.cpp
     3479   10543   72977 powder117_src/build.cpp
      312     757    5860 powder117_src/control.cpp
     9915   27518  229938 powder117_src/creature.cpp
      167     848    6321 powder117_src/credits.cpp
       15     330    2000 powder117_src/dpdf_table.cpp
     5412   25591  212248 powder117_src/encyclopedia.cpp
      224     422    4331 powder117_src/encyc_support.cpp
     4379   12607   93379 powder117_src/gfxengine.cpp
    19748   25860  265630 powder117_src/glbdef.cpp
      890    2750   18963 powder117_src/grammar.cpp
      494    1185   10005 powder117_src/hiscore.cpp
      458    1269    9299 powder117_src/input.cpp
      187     404    3055 powder117_src/intrinsic.cpp
     4802   11225  105924 powder117_src/item.cpp
      166     385    2819 powder117_src/itemstack.cpp
       92     578    3912 powder117_src/license.cpp
     6687   16919  142522 powder117_src/main.cpp
     6250   17630  135402 powder117_src/map.cpp
      527    1355    9759 powder117_src/mobref.cpp
      688    2038   14374 powder117_src/msg.cpp
      253     522    4037 powder117_src/name.cpp
     1609    4037   34310 powder117_src/piety.cpp
      352     809    5432 powder117_src/ptrlist.cpp
      702    2796   15683 powder117_src/rand.cpp
      126     285    1996 powder117_src/signpost.cpp
      264     556    4169 powder117_src/smokestack.cpp
      165     449    3117 powder117_src/speed.cpp
      889    2302   16276 powder117_src/sramstream.cpp
     1083    3027   20932 powder117_src/stylus.cpp
      199     323    3061 powder117_src/thread.cpp
      102     156    1728 powder117_src/thread_linux.cpp
       96     166    1654 powder117_src/thread_win.cpp
      833    2350   17603 powder117_src/victory.cpp
       69     223    1585 powder117_src/artifact.h
       52     159    1122 powder117_src/assert.h
       32     130     777 powder117_src/bmp.h
      107     396    2789 powder117_src/buf.h
       73     270    1828 powder117_src/control.h
     1088    5518   39792 powder117_src/creature.h
       11      48     340 powder117_src/dpdf_table.h
       24      52     538 powder117_src/encyclopedia.h
       41     147    1027 powder117_src/encyc_support.h
      437    2047   14103 powder117_src/gfxengine.h
     3054    4832   62620 powder117_src/glbdef.h
      145     476    3430 powder117_src/grammar.h
       82     258    1696 powder117_src/hiscore.h
       31     158     896 powder117_src/input.h
       52     147    1248 powder117_src/intrinsic.h
      437    2026   15532 powder117_src/item.h
       66     184    1361 powder117_src/itemstack.h
      777    3960   27202 powder117_src/map.h
       83     345    2242 powder117_src/mobref.h
       70     322    2076 powder117_src/msg.h
       59     193    1342 powder117_src/name.h
       38     129     853 powder117_src/piety.h
       96     309    2188 powder117_src/ptrlist.h
       95     238    1743 powder117_src/queue.h
      124     549    3451 powder117_src/rand.h
       65     175    1316 powder117_src/signpost.h
       89     322    2253 powder117_src/smokestack.h
       65     250    1668 powder117_src/speed.h
      100     355    2790 powder117_src/sramstream.h
      132     576    3946 powder117_src/stylus.h
      248     623    4625 powder117_src/thread.h
       55     130    1095 powder117_src/thread_linux.h
       58     133    1057 powder117_src/thread_win.h
       45     169    1193 powder117_src/victory.h
    92394  239524 1980945 total

Skipping some utility and portability source in subdirectories.

Source code mixes tabs and spaces.

### The blob classes

A big part of the roguelike logic in POWDER is stored in the methods
of the `ITEM`, `MAP` and `MOB` classes. The class definitions are
massive blobs of methods, and for maps and mobs, the implementation
is spread to several files.

Having classes with a massive collection of methods is a [recognized
anti-pattern](http://en.wikipedia.org/wiki/God_object). However,
roguelikes just plain do have creatures, items and maps that have a
whole bunch of stuff going on for them.

Some alternative approaches that could be used would be to make the
classes into much more like dumb objects, and just have the complex
game rules in independent functions that take the objects as
arguments. This is the suggested best practice in *The C++
Programming Language* 4ed: "Make a function a member only if it
needs direct access to the representation of a class."

The D language has the uniform function call syntax for cases like
this. It would do away with the problem in C++, where the
representation-accessing member functions will have syntax
`a.foo(...)` and the other functions would be `bar(a, ...)`. UFCS
just lets you say `a.bar(...)` if there's any function `bar` that
takes a first parameter of `a`'s type.

You could also use an entity component system and treat the game
objects as collections of components handling different areas of
responsibility (having a grammatical name, being an object on the
game map, having an AI), but this can bring in its own architectural
weight. Might not be a good idea on a GBA.

### `gfxengine.h`, `gfxengine.cpp`

Because of its GBA target, POWDER uses a fixed 240x160 resolution,
the same as the GBA display. This is quite different from most
roguelikes, which are expected to run on desktop computers which
used to have at least a 640x480 resolution for limited color modes
even back in the late 1980s.

The gfx engine seems to also have some cruft informed by GBA's
hardware limitations, such as the amount of in-memory tiles.

Not sure how much stuff there is here that a simpler SDL based
graphics system wouldn't handle trivially. Printing colored text is
one thing.

There are also GBA key defines here, so this thing might be some
sort of more general GBA engine layer for the whole thing.

### `glbdef.h`, `glbdef.cpp`

Generated C++ source with data for items, creatures etc. generated
from the text data files with POWDER's custom preprocessor tools.

### `rand.h`, `rand.cpp`

Random number generation management, and several utility functions.

There is some direction handling code here. First the random
direction code for four and eight-directional compasses (POWDER has
four-directional movement), but then there are also functions for
changing a 4-direction or an 8-direction value (POWDER calls the
directions in the 8-way compass 'angles' here as opposed to
directions) into a dx, dy vector. This doesn't have anything to do
with RNG anymore, but I guess it was being used with the rnadom
code.

There are functions for shuffling an array or picking from an array
which are hardcoded to types instead of being templated, even though
the source does use templates elsewhere.

There's also string hashing (again not RNG related) and generating
random player name strings:

    // Written in a beautiful provincial park in a nice cool June day.
    // If this were traditional manuscript, it would smell of woodsmoke,
    // but the curse of digital is the destruction of all sidebands
    // of history.  Which I guess makes comments like this all the
    // more important.
    void
    rand_name(char *text, int len)

Then a state machine between sets of letters classified as vowels,
fricatives, plosives and 'weird' ("qwjx") follows.

The internal implementation is Mersenne Twister, the source includes
the free software MT C file.

There's a global variable for the RNG state. There can be a stack of
the states via an intrusive linked list in the `RAND_STATE` type for
the state. (Class names are ALLCAPS in Powder.) So you could have a
bottom RNG that is used to create all the levels deterministically
from the seed, and a higher-level RNG that can be called during
gameplay and which won't mess the generation of the next level no
matter how much entropy the player's actions consume.

There's a strangely complex `rand_choice(num)`, which just returns
$0 \le x < num$. Apparently the modulo operation is slow enough on
GBA that common cases like 2, 8 and 100 can stand to use special
optimization to make them work with bitwise operations and a static
1024-element look-up table in case of 100.

### `buf.h`, `buf.cpp`

Ooh, here's the "oh no, we absolutely can't use `std::vector` or
`std::string`, those filthy things" bit. Maybe std::containers
really weren't an option on the GBA, but still. Those things are
standard, they're good enough, and they have the standard interface.
Don't make me worry about code and API that would just *go away* if
you grabbed the standard containers.

(Okay, granted, there's sprintf stuff here, and C++ std has that
horrible mess of idioms for catenating strings or printing to
streams which nobody wants to use if they can have printf.)

### `ptrlist.h`, `ptrlist.cpp`

Some code that's actually templated. Seems to be another container
that could be pretty much replaced with a STL container.

### `queue.h`

Another templated thing. This one has some thread-locking support
too.

### `stylus.h`, `stylus.cpp`

GUI code for a touch screen. Implements a `STYLUSLOCK` class that
has lots of draggy and select-y logic in it. I guess this is a more
recent addition to the game, the GBA didn't have a touchscreen, but
Nintendo DS did. And touchscreen is all modern smartphones have.

### `grammar.h`, `grammar.cpp`

Utilities for procedural messages. Stuff that makes non-English
language localizers want to kill the developer, aka cool shit. I'm
guessing POWDER will be able to derive messages like "You zap the
orc with the wand." and "Sigfried zaps himself with the wand." from
a single message template.

There's an enumeration for the different cases:
    enum VERB_PERSON
    {
        VERB_I,
        VERB_YOU,
        VERB_HE,
        VERB_SHE,
        VERB_IT,
        VERB_WE,
        VERB_YALL,
        VERB_HES,
        VERB_SHES,
        VERB_THEY,
        NUM_VERBS
    };

Does the game ever actually use first person? The message narration
is second person. Also, does it ever matter for the plural part
which of the three 3rd person pronouns is used? I guess you can just
shift the he/she/it value up by 5 instead of collapsing the three
into one value...

There's a very hairy function for handling pluralizations. Might
have been simpler to just do the '-s'/'-es' default thing and make
it possible to specify more unusual plural forms in the name data.
Also the suffix checking code uses reverse strings, probably in some
GBA optmization again, but making things more unfun for the code
maintainer.

There's also a function for determining if a string is a plural
noun, which smells like something that would backfire on you
horribly in actual use. (Seems to be used to check that things
aren't being pluralized twice.)

The string handling code is quite C-like here, even though it does
use the `BUF` objects.

Verbs are conjugated by person. This thing's just wired to special
case all the weird stuff that occurs. I guess if you can control
the text of your input data, it's neatest to just push the
complexity inside the grammar functions, keep the data simple, and
keep adding new exception cases as you get new strange words in the
data the system doesn't handle.

### `artifact.h`, `artifact.`

Random artifacts, where the artifact properties are derived from its
name string.

Class is `ARTIFACT`, it doesn't inherit from anything.

The long `artifact_buildartifact` function (260 lines) creates the
random artifact. There's determination of intrinsics, a name
modifier and stat values.  Artifacts have attack, thrown attack,
armor and light radius stats. Intrinsics are stored in a char array.
I guess each char corresponds to an intrinsic and the array is
null-terminated. So this is something you'd want to use
`std::vector` for? There's also "carry intrinsic", which I guess
means that the artifact works just by being in your inventory
instead of being equipped.

### `encyclopedia.h`, `encyclopedia.cpp`, `encyc_support.h`, `encyc_support.cpp`

Some kind of help system? The `encyclopedia.cpp` is a generated
source file of text descriptions of the various game elements.

Nice descriptions of the items. Though it's maybe a bit odd to have
descriptions of game object separate from the main object data spec
in the data files. Duplicating the item lists violates Don't Repeat
Yourself.

There's a pager for the encyclopedia in the code. Nothing
particularly interesting here otherwise, this is basically just
another one of the ultra-lightweight hypertexty in-game help
systems that are mostly decoupled from the rest of the game logic.

### `control.h`, `control.cpp`

Mapping low-level input routines into queries of logical keypresses.

### `assert.h`, `assert.cpp`

Assert macro. With an option to display the assert error graphically
on screen if a printf isn't available.

### `input.h`, `input.cpp`

String input. 500 lines of pain you could mostly just forget all
about if you limited yourself to platforms that come with a text
input device provided by the hardware or the operating system.

### `bmp.h`, `bmp.cpp`

Parsing the BMP files the assets come in. There's already the
`bmp2c` preprocessing tool for converting images directly into
memory-mapped static data, so why is this even here?

### `msg.h`, `msg.cpp`

API functions for the on-screen messages. Do the wait-for-more bit,
a pager for the message history, and so on.

The raw text priting function is `gfx_printtext(int x, int y, const
char *text)`, which prints lines of text on the screen. The text
buffer is persistent, you need to clear the text by printing blanks
instead of just not drawing it on this frame.

There's code for splitting lines at spaces. This can get hairy,
since the strings can also be built piecemeal from short segments.

There's also `msg_askdir`, which waits for user input on direction.

### `intrinsic.h`, `intrinsic.cpp`

The intrinsics here, defined by bytes with the intrinsic sets being
strings. The class is `INTRINSIC`, while the list is the generated
enum `INTRINSIC_NAMES`. There's also a bit vector for the
intrinsics, the member `myData` in `INTRINSIC`. This is the only
data the class holds, so I guess it's what gets used during runtime.
Some duplication of the bit vector addressing code in
`intrinsic.cpp`.

### `mobref.h`, `mobref.cpp`

Some kind of reference counting handle thing for mobs (monsters).

### `name.h`, `name.cpp`

Some trickery to contain the few custom names in the game that
mostly uses static names. Seems to be mostly memory use
optimization, not seeing much here that you couldn't just do with
`std::string` and lose some lines of code you need to maintain.

### `speed.h`, `speed.cpp`

Here's Lait's discrete speed system. From the documenting comment:

    *      Speed is INTENTIONALLY round based.  The goal is to allow
    *      predictable movement, rather than the tendency to floating
    *      point speed systems that have confused (IMO) later roguelikes.
    *
    *      As such, there are three speed modifiers: Fast (F), Quick (Q),
    *      and Slow (S).  There are also 4 types of phases: Fast (F),
    *      Quick (Q), Slow (S), and Normal (N).
    *
    *      doHeartbeat style functions execute only on N & S phases.
    *
    *      doAI movement operates on the phases according to the following
    *      chart:
    *
    *          F N S Q N Speed
    *      N     x x   x  100%
    *      F   x x x   x  133%
    *      Q     x x x x  133%
    *      FQ  x x x x x  167%
    *      S     x     x   67%
    *      FS  x x     x  100%
    *      QS    x   x x  100%
    *      FQS x x   x x  133%

So you can have separate and (barring intricacies from turn order)
equally good Fast and Quick modifiers, a combination of the two for
twice the effect, and a separate slow modifier that slows you down
whatever your other modifiers.

Speed uses some global variables for the ticks. Gamestate-relevant
stuff in loose global variables instead of tucked within a single
gamestate structure makes me uneasy. You'll need to remember to
store all those individual bits in your save game code. There are
indeed `speed_save` and `speed_load` functions here, using
`SRAMSTREAM` class. With code mostly identical, this could have used
the symmetric serialization code idiom where a single function can
do both saving and loading depending on the parameters you call it
with.

The speed module doesn't do anything interesting beyond implementing
the phase logic, like maintaining a list of live game entities and
calling their update methods whenever the tick phase matching their
speed profile comes up.

### `sramstream.h`, `sramstream.cpp`

Streaming save files. GBA implements save memory as memory-mapped
non-volatile RAM. Basically just filestream style read and write
operations here, plus some compression code.

### `smokestack.h`, `smokestack.cpp`

Data structures for gas clouds on the map. Gases get a mob that owns
them, possibly so that the game can track kills by the gas to
whoever caused the gas to be there. I think this basically comes
down to a function from map positions to (gas type, owner mob)
pairs.

### `signpost.h`, `signpost.cpp`

Signposts are things on the map that print text, I guess. Repeated
code from smokestack's `SMOKEITEM` in `SIGNPOSTDATA` for handling
its positions on the map. The whole thing sorta looks like just a
variant of the smokestack thing structurally, but with a slightly
different payload type.

Of course there might be weird micro-optimizations at play here for
the GBA-happiness of the whole.

### `itemstack.h`, `itemstack.cpp`

Typedefs the `PTRSTACK` template container for items and mobs. Seems
to be just a std::vector-ish container.

### `item.h`, `item.cpp`

The `ITEM` class is the first of the three blob classes in POWDER.
The data is minimizied, and items are stored in an invasive linked
list. A big switching point is the `myDefinition` value, which
points to the item type in the static item data. It's 8-bit only, so
we're limited to 256 standard item types.

Items are created using the static `create` function, not the class
constructor. The function gets the item type, and then generates
lots of random properties appropriate for the type, like stack size
for stacking items, possible curses, possible artifact status etc.
Then there are helper functions like creating any random item, or
creating a random item of a specific type, or an item from a table.

This place might be able to use some sort of distribution
abstraction, and the whole system might be split off into some sort
of factory system to make the actual item class have less fat.

The static data for items can get complex. For example there's the
attack spec, which has the standard description verb, damage as an
3d6 style thing, tohit bonus. Then there's ray behavior like whether
it reflects or penetrates targets, intrinsic infliction and the
chance to create explosions.

The data file `source.txt` is a version using nicer formatting that
gets converted into static C++ code. You probably *could* set up a
nice and type-safe data entry system even in actual C++, but it'd
probably be something that builds up the data structures at runtime.
This would be a problem on the GBA which wants you to store as much
as possible in a read-only memory.

The cycling method for game objects is `doHeartBeat`. It mostly does
corpse decay for items.

Items can have transient statuses like enchantments or poison
coating, and they can be canceled back into their neutral state with
`makeVanilla`.

Corpse items can be resurrected into living mobs or raised as
undead. Items can be petrified or unpetrified. Apparently there's
the NetHack stone-to-flesh thing in play here that can be also used
on stone that wasn't petrified flesh to begin with. Items can also
be polymorphed into a different item of the same type, another thing
lifted from NetHack.

There's logic for launchers. The thing with bows and arrows with one
being mostly useless without the other and requiring equip juggling
to use has been a thing since Hack at least, and Brogue did away
with it by just having throwable projectiles like javelins, so you
don't need to equip launchers so use them and you don't need to
find pairs of items before you can fight.

Function `calcAverageDamage` is interesting. It gets the average
from the damage dice, then basically just fudges bonuses from the
extra features like elemental damage and poison. Looks like this is
used by AI code, so it doesn't really matter if the numbers won't
quite match with the actual average damages, as long as they form an
ordering relation.

Then there's a battery of identification functions. You can know the
type of an item (eg. healing potion instead of swirly potion), that
the item isn't cursed (you have managed to unequip it), the full
curse/bless status of the item, whether the item is enchanted, how
many charges the item has left and whether the item is poisonous.

This is the sort of stuff people in the 70s wrote predicate
languages for trying to build artificial intelligences.

The general pattern is that all query functions about the state of
an item, and all functions that do stuff in game that mostly revolve
around items are methods in the item class. This results the
ugliness of the massive class definition, but works quite well
otherwise. And there's good factorization of query and action
concepts into named methods, so the code isn't full of repeated
cryptic data structure jugglings.

Functions for changing item state, such as `electrify`, have some
interesting bits in the signature:

    bool electrify(int points, MOB *shocker, bool *interesting);

If the return value is true, the convention is to destroy the item.
The `interesting` out parameter seems to be for generally signaling
that some sort of notable effect took place.

Items define a stacking order with `getStackOrder`, which is used to
determine what shows up on top of item stacks. Boulders on top of
non-blocking items and so on.

Item stacks get their own cluster of methods. Again creating the
feeling that `ITEM` is a large number of classes cobbled together.

Another long set for name formatting and generating event messages.

Then there are action methods for dipping and zapping items,
whatever action as a specific thing means in this architecture.
Action seems to be the way to call mob, or at least player to do
stuff. I guess item actions are then item methods which use the same
API convention. The dip has a switch for different potions you can
dip a thing in. Likewise zap for wand types. Zap also has the giant
switch statement pattern where the complex logic for each of the
disjoint types of magical effect is written out in full under the
branch, producing a huge function. Should just turn the branches
into functions and keep the switch compact if possible.

Then there are callback functions for grenades and zapping. These
are about the control returning to deal with a thrown thing or a zap
hitting something after exiting from the initial throw/zap action
method?

And that's the item. Data contents are a bunch of simple variables
and an invasive list pointer to the next item. And a static mob
reference variable `ourZapper`, which seems to be a kludge for
keeping the original actor around over the call chasm between the
action and callback methods.

### `map.h`, `map.cpp`

Moving on to the even bigger blob classes. Class `MAP` is divided
into two implementation files. `map.cpp` has the methods for a
runtime map, and `build.cpp` has the map generation methods.

POWDER has persistent maps, so the individual map objects have an
invasive doubly linked list. Maps also store a branch in addition to
depth. Besides main, there seems to be only a "tridude" branch, so I
guess this feature isn't used that much.

Maps have a bunch of static members for efficient structures for
searching the current map. I guess these can be regenerated on the
fly from the more persistent map data.

There can be gases on the map, and there is wind blowing in random
direction and occasionally changing that blows the smoke around.

There's the pattern with the intrusive linked lists, where map
methods deal with both individual maps and the collection of maps.
There's a `deleteAllMaps` method for example.

Pathfinding is in `findPath`. POWDER has 32 tile map width and
height. The 32 shows up as a magic number everywhere. Though it
looks like the code's making use of the fact that you can use 32-bit
ints as bit vectors when your map width is 32, so I guess changing
the dimensions might be tricky.

And there are global bit vector arrays of 32 ints, so they'll span
the whole 32x32 map. `glbBlockingTiles`, `glbWalkTiles1`,
`glbWalkTiles2`. (These don't get a nice class wrapper, you access
them with array access for the row and bit shift for the column.
There's some bitwise magic being done on them in the `findPath`
code.) The pathfinding algorithm is a 4-directional floodfill in a
32x32 bit matrix representing the path, masked with the
`glbBlockingTiles` bit matrix representing unpathable tiles. The
result is a single step in which to move. No support for storing the
whole path in the API, so you'll end up recalculating the path for
every step with naive use? (The two `glbWalkTiles` tables are used
to tell if there was no path progress during an iteration and you
should give up.)

The toplevel function for creating mobs and and items for a level
seems to be `populate`. Also creates the end boss for the bottom
level. This uses the `createAndPlaceNPC` method that creates random
level-appropriate mobs. A nice touch is the `avoidfov` parameter,
which lets you make them spawn outside the player's immediate
vision, so that you can surreptuously repopulate a level while the
player explores around.

There's stuff with a "guilty mob map" from tiles to mobs. I think
this is for when a mob drops down hazardous environment like traps,
so that the game can trace the claim from things killed by the traps
to whoever laid them. Kill claiming logic gets quite interesting
when you need to start chasing logic tails with it.

The problem with 2x2 mobs and 1 tile wide corridors is solved with
`wallCrush`, where the big mob crushes destructible walls around
wherever it wants to move. It looks like the mob is expected to
already be in its new position here, tracked by its top left point,
and the crushing just happens as an afterthought. Also I guess the
mob will just squeeze into a tighter space if some of the walls are
indestructible by some reason. The function doesn't give any return
value for whether the crushing was successful.

Functions `registerMob` and `unregisterMob` work with the quick
lookup tables for on-level mobs. Does the game actually need these
for speed? Would be simpler just to iterate the mob list every time
you need to see if you hit something. Logic in `unregisterMob`
seems rather complex. The next `getMob` function even implements
both methods, looking in the quick lookup table for the current
level and scanning the mob list if the level is not current. And the
difference must be checked from a global variable, brittle...

Interesting kitchen sink api in the random location finder:

    bool MAP::findRandomLoc(
        int &ox, int &oy, int movetype, bool allowmob,
        bool doublesize, bool avoidfov, bool avoidfire,
        bool avoidacid, bool avoidnomob)

So you can have all sorts of clever conditions for placing the mob.
Though at this level you'd probably just want to throw in some sort
of predicate function as the filter instead of enumerating every
condition separately. Also, there's support for exactly the 2x2 size
big mobs, but no architecture for general multi-tile spanning
things.

Then another "why's this in MAP again?", toplevel for running mob
AI, `moveNPCs`. This walks the mob list and does a "false return
aborts" condition chain of `MOB::doHeartbeat`, `MOB::doMovePrequel`
and `MOB::doAI` on them. This chaining bit should probably be
collapsed into a method on mob.

Map-level updates in `MAP::doHeartbeat`. This is where avatar
smells, something that presumably lets monsters track the player
around, is updated. Smells are 16-bit timestamps laid in the map,
and if you know the current time, you can tell how old each trace
is. Except when the variable overflows:

    // We overflowed our watermark.  We clear our map and set it
    // to the defualt distance of 64.  I wonder if anyone will notice
    // that every 65k moves all creatures become confused?

Now this crippling exploit is revealed.

This method also does the occasional spawn of a new mob and runs
heartbeats on items.

Complex method `acquireItem`. Took a moment to figure out just what
this is about. Seems to be for the map tile "acquiring" an item from
a mob that drops it, so basically just figuring out what happens
with the cache structures and such when the item is dropped in the
square. (Why not call it "drop" or something?) Also if there's some
interesting liquid there, that will have an effect on the item. Also
the item can merge in a pile, and the UI will treat valuable-looking
items dropping with some extra messages. Boulders are items and they
can fill pits, like in NetHack.

FOV in `buildFOV`. Nothing clever here. It just traces LOS to every
cell to see if its visible. Also spreads avatar smell, diluted by
taxicab distance, to every visible cell. Takes an awful many lines
to do such simple logic.

There are several different LOS functions. `hasLOS` looks like
something Bresenham-y, `hasSlowLOS` is your standard naive floating
point op line tracing, `hasDrunkLOS`

    // This LOS algorithm was written while rather drunk.

Lighting logic in `updateLights` that spreads light from emitting
mobs and items.

There's a function `isSquareInLockedRoom` which is used in the
NetHack situation where a map is generated where the only approach
is through a secret door and a newbie who doesn't know about secret
doors yet gets thorougly frustrated to pop up a help message about a
secret door being around. Instead of, y'know, just not generating
maps where you need to find an unhinted secret door to progress to
the next level.

`throwItem` is in map, because you throw the items over map I guess.
There's graphics stuff mixed in here. Items can ricochet. Rays have
a similar `fireRay` method.

There's `knockbackMob` doing what you'd expect. You don't see that
much knockback in roguelikes.

Dig logic in `digHole`, `digPit`, `digSquare`. Dig code was pretty
hairy in Hack already. You can dig sideways or down. Pits cause
guilt markings on the map, so that the digger gets a kill if
something dies falling in one. There doesn't seem to be any logic
for the digging taking multiple turns. Can you just chop stuff up as
you go? More terrain modification stuff for growing trees and
messing with fluids.

Now there's a `dropItems` method. I guess this is why there's the
different `acquireItems`. And `fillSquare` for boulders filling
things. Another mechanic from NetHack. `dropMobs` is the logic for
creatures falling in pits or through holes. Also seems to handle
falling into liquids.

Fluid dynamics goes on in `moveFluids`, which calls `applySuction`.

    // Update all map tiles with the following rules:
    // 1) If a pit, and posseses neighbouring liquid, fill in.
    // 2) If lava, and possesses neighbouring water, steam & dry out.
    // 3) If ice, and neighbour is lava, turn to water.
    // We don't want instant chain reactions, so the order of
    // operation is important.

Lava can also start forest fires, which makes the tree grower guilty
of the deaths caused.

    // Because we propagated guilt already, we can use our own guilt
    // for source.
    // This system built at very high altitude likely over the Pacific
    // (the map feature is broken on this plane, the only
    // entertainment I like :<)
    // Hopefully it holds together at sea level.

Not seeing a more general, Dwarf Fortress style fluid depth and
spreading logic here. Broken viewport tiles also repair themselves
here for some reason.

`changeCurrentLevel` has new level logics. Levels from 20 up have
special messages.

And that's it for map basic logic. 6250 line file. Way big.

### `build.cpp`

### `creature.h`, `creature.cpp`
### `action.cpp`
### `ai.cpp`

### `victory.h`, `victory.cpp`
### `piety.h`, `piety.cpp`
### `hiscore.h`, `hiscore.cpp`
### `main.cpp`
