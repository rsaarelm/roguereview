Hack
====

Notes on Hack 1.0.3. The predecessor of NetHack from the 80s.

NetHack is probably still the most well-known roguelike, but its
direct predecessor Hack fell into obscurity quite fast when NetHack
development started. Will be interesting to see what the initial
stages of the design look like.

The source code calls things like weapons and potions 'objects'.
I'll be calling these 'items' in my notes, since I prefer object to
mean any game object whatsoever, not just a specific subtype.

Source code overview
--------------------

      134    775   4582 hack-1.0.3/config.h
        2      7     40 hack-1.0.3/date.h
       12     74    456 hack-1.0.3/def.edog.h
       24    121    756 hack-1.0.3/def.eshk.h
       42    249   1585 hack-1.0.3/def.flag.h
       16     39    299 hack-1.0.3/def.func_tab.h
       15     65    415 hack-1.0.3/def.gen.h
       12     40    279 hack-1.0.3/def.gold.h
       26    101    641 hack-1.0.3/def.mkroom.h
       60    297   2094 hack-1.0.3/def.monst.h
       60    273   1874 hack-1.0.3/def.objclass.h
      289   1506  10397 hack-1.0.3/def.objects.h
       48    216   1457 hack-1.0.3/def.obj.h
       25     90    719 hack-1.0.3/def.permonst.h
       52    205   1255 hack-1.0.3/def.rm.h
       27    102    656 hack-1.0.3/def.trap.h
       13     41    285 hack-1.0.3/def.wseg.h
      163    669   4667 hack-1.0.3/hack.h
       12     48    363 hack-1.0.3/hack.mfndpos.h
      227    686   5967 hack-1.0.3/hack.onames.h
       47    117    801 hack-1.0.3/alloc.c
      434   1467  10376 hack-1.0.3/hack.apply.c
       95    369   2489 hack-1.0.3/hack.bones.c
      798   2695  18269 hack-1.0.3/hack.c
      301    890   5966 hack-1.0.3/hack.cmd.c
       43    187   1121 hack-1.0.3/hack.Decl.c
      486   1547  11400 hack-1.0.3/hack.do.c
      413   1475  10491 hack-1.0.3/hack.dog.c
      289    912   6165 hack-1.0.3/hack.do_name.c
      336   1000   7549 hack-1.0.3/hack.do_wear.c
      459   1446  10482 hack-1.0.3/hack.eat.c
      639   2117  15946 hack-1.0.3/hack.end.c
      306   1011   7014 hack-1.0.3/hack.engrave.c
      358   1215   9276 hack-1.0.3/hack.fight.c
      860   2866  18924 hack-1.0.3/hack.invent.c
       53    183   1338 hack-1.0.3/hack.ioctl.c
      285    816   6400 hack-1.0.3/hack.lev.c
      495   1480  10730 hack-1.0.3/hack.main.c
      198    678   4496 hack-1.0.3/hack.makemon.c
      363    997   8080 hack-1.0.3/hack.mhitu.c
      739   2554  16791 hack-1.0.3/hack.mklev.c
      136    463   2961 hack-1.0.3/hack.mkmaze.c
      148    419   2964 hack-1.0.3/hack.mkobj.c
      274    945   6769 hack-1.0.3/hack.mkshop.c
      838   2851  20272 hack-1.0.3/hack.mon.c
       79    355   2652 hack-1.0.3/hack.monst.c
      547   1729  11399 hack-1.0.3/hack.objnam.c
      160    531   3885 hack-1.0.3/hack.o_init.c
      203    547   4630 hack-1.0.3/hack.options.c
      401   1185   8006 hack-1.0.3/hack.pager.c
      386   1085   8839 hack-1.0.3/hack.potion.c
      660   1862  12958 hack-1.0.3/hack.pri.c
      539   1698  13016 hack-1.0.3/hack.read.c
       81    248   1930 hack-1.0.3/hack.rip.c
       63    208   1492 hack-1.0.3/hack.rumors.c
      238    774   5903 hack-1.0.3/hack.save.c
      133    431   3129 hack-1.0.3/hack.search.c
      973   3116  23601 hack-1.0.3/hack.shk.c
      140    476   4252 hack-1.0.3/hack.shknam.c
      203    683   4958 hack-1.0.3/hack.steal.c
      276    913   5565 hack-1.0.3/hack.termcap.c
       62    186   1377 hack-1.0.3/hack.timeout.c
      192    518   3803 hack-1.0.3/hack.topl.c
       38    105    656 hack-1.0.3/hack.track.c
      447   1290   9891 hack-1.0.3/hack.trap.c
      301    954   6334 hack-1.0.3/hack.tty.c
      357   1243   8053 hack-1.0.3/hack.u_init.c
      430   1634  10445 hack-1.0.3/hack.unix.c
      259    917   5880 hack-1.0.3/hack.vault.c
       16     46    323 hack-1.0.3/hack.version.c
       99    348   2473 hack-1.0.3/hack.wield.c
      189    682   4930 hack-1.0.3/hack.wizard.c
      183    588   4226 hack-1.0.3/hack.worm.c
       65    210   1371 hack-1.0.3/hack.worn.c
      642   1990  14672 hack-1.0.3/hack.zap.c
      217    650   4452 hack-1.0.3/makedefs.c
       30     43    280 hack-1.0.3/rnd.c
    19261  63549 451238 total

This is the oldest code base I've done so far. Even the Rogue one
was Rogue Clone that had apparently seen some maintenance in the
1990s.

### `config.h`

System settings. Some of the Unix-integrating bits like linking to
the mail file are here. So that's the social media integration of
the day.

Interesting for the UI: `COLNO` (80) and `ROWNO` (22) specify the
minimal terminal dimensions expected. That's fewer rows than the
usual 24 or 25.

Nice macro for getting the size of const arrays:

    #define     SIZE(x) (int)(sizeof(x) / sizeof(x[0]))

Structs have bitfields, which use the `Bitfield` macro just in case
the C compiler doesn't support them right. The convention is
apparently to do object flags with bitfields instead of the more
common flags variable and flag mask constants.

### `def.objclass.h`

The item class data is in struct `objclass`. This has some obvious
fields like name and spawning probability, and then generic ones
like `oc_oc1`, `oc_oc2`, which have item type specific meanings
`#define`d to them. So for example there's `#define nutrition oc_oi`
for food items.

And then there are the bitmask constant flags using this system,
instead of bitfields. Wands get `NODIR`, `IMMEDIATE` and `RAY`.

Wonder if this thing could've been done with union types. Maybe they
were working around C compilers that didn't support unions.

### `def.objects.h`

Item data as a big static list of `objclass` values. Different
types of items, like food or weapons, get macros that only take the
arguments relevant to that type and set the rest of the values to
fix the type.

There isn't anything in the food list about intrinsics given by the
dead monsters. This seems to instead happen in the eat logic based
on the letter of the monster where the corpse came from.

Weapons have separate damage values against large and small
creatures. I think this is from 80s D&D. Not sure how much logic
there is here. Darts, daggers and two-handed swords hurt large
monsters more, the other weapons hurt small monsters more.

A lot of the tools familiar from NetHack show up, magic whistle,
expensive camera, ice box and pick-axe.

The wand of wishing is also present already. It's got a spawn
probability 1 for the 10 of the most common wands, same as wand of
death. I wonder if they made it more rare in NetHack.

Polymorph self stuff does not seem to be here though. I guess that
only showed up in NetHack.

Long worms and crysknives are present though.

### `def.permonst.h`

Monster type. Not that many fields here.

These aren't commented either.

`mname`: name, `mlet`: letter, `mlevel`: General power level,
`mmove`: movement speed, `ac`: armor class,
`damn`: number of damage dice, `damd`: damage die size.

`pxlth`: Seems to be the size of an extra data field to allocate.
Most monsters get 0 here, but shopkeepers get sizeof `eshk`, which
is the special shopkeeper data struct. So old-school subclassing
basically...

Some creatures, presumably because they're notable in the game logic
somewhere, get special `#define` names pointing to the monster
array. Like minotaurs, who are specifically generated in mazes.

### `hack.monst.c`

Monster type data. There's lower and upper case letters, but no
multiple monsters per letter like in NetHack. So you can do logic on
the character value and uniquely identify the monster you talk
about. The `permonst` table isn't sorted in ASCII order though,
would've been neat.

Special critters are ghosts, with the space character, the Wizard of
Yendor and eels with ';' char. I guess these are the ones that don't
get spawned using the standard method, so they don't go into the
regular array.

The part where capital letters signify more powerful creatures isn't
here, 'O' is Orc and 'o' is the tougher owlbear.

Long worms are a compile option, and if they're not around, you get
a "wumpus" instead. Cute. The general pattern of having game
elements as compile options is a bit weird from a software
engineering standpoint, and did propagate over to NetHack.
Conditional macros make code uglier. Weird monsters picked just to
fill the alphabet are here, in particular because you need two for
every letter. You have Zombie, but there is also a zruty (some kind
of giant ape-beast, as far as anyone has been able to figure). You
have Xorn from D&D, but then there's also xan, that's some sort of
insect thing. At least in NetHack. Also quivering blob for the q
that's not Quasit, which seems almost cheating.

### `def.monst.h`

Live monster data.

Lots of stuff here.

- They make an intrusive linked list with `nmon` pointers.
- Theres a list of points `mtrack`. Pathfinding?
- Lots of flags, done with the bitflag system. Monsters can be
  invisible, change shape, hide behind objects. Monster can be
  "cancelled", which seems to stop their special powers from
  working. Monsters can be guards, used for a special human type
  defined in the vault module.

### `hack.Decl.c`

Miscellaneous global variables.

    char nul[40];                       /* contains zeros */

Hmh. This seems to be a string buffer used in engraving etc. Pretty
weird to put it in a global place like this.

The level map is in `levl[COLNO][ROWNO]`. So the `ROWNO` was leaving
space for the status line?

There are also the room structs in `rooms`.

Then there are bunches of things in invasive linked lists:

- Monsters in `fmon`
- Traps in `ftrap`
- Gold piles in `fgold`
- Items in `fobj`, something called `fcobj` (these things really
  should be commented), then `invent` for the player inventory and
  pointers for what seem to be all the player's equipment slots.
- Global game options in `flags`.
- The player in `u`.

The current depth is a global value `dlevel`. There's coordinates
for the up and down stairs on the current level, apparently you only
have one of each.

Also arrays for genocide data.

Then mixing in interface code, there are variables for the cursor
position.

### `def.rm.h`

Data for location cells. Not many terrain types here. Room floor and
corridor are different types, like they were in Rogue.

### `def.gold.h`

Gold piles are just position, amount, and the pointer to the next
pile in the invasive list.

### `def.trap.h`

Traps aren't much more complex than gold piles.

### `def.obj.h`

Live item data. The usual linked list stuff. Also container id. And
besides the location coordinates `ox` and `oy`, there's `odx` and
`ody`. Based on naive grepping, there is no code that's called from
anywhere that actually uses the `odx` and `ody`, but of course there
are many other ways to access those.

Bitflags again, bits for whether the thing is IDd, cursed or unpaid.
Also for whether the color is known, I guess when the player is
blind the new objects won't be.

Then there's a bitmask thing for equipment slots, `owornmask`. Bits
for the position where the item is equipped, and then multi-bit
masks for going through all armor-types or ring-types equppend?

### `def.flag.h`

Seems to be the variables for the game options, like whether you do
autopickup or not.

### `hack.onames.h`

Defines that give symbolic names for the item types. These repeat
the ordering of the item list, so you can introduce bugs if you
change the item list but don't change this one. Defining data so
that you get both the structured contents in a table and a symbol
define is somewhat tricky to do cleanly. [X
macros](http://en.wikipedia.org/wiki/X_Macro) would be one somewhat
hacky C technique for doing this.

### `hack.h`

The main header, which pulls in the several other ones described
above.

There's a `coord` struct for x, y coordinate pairs (in chars, so
coords fit in 16-bit words). These aren't used consistently though,
the API and structs mostly use x and y spelled out, while some data
structures use coords internally.

A pretty random grab-bag of utility macros.

Then there's the player struct `you`. As the case is with pretty
much all the classic games, player and monster types are not the
same.

There's a condition flagl define `QUEST` that keeps popping up that
changes cryptic bits in the definition. For the player, it adds
"direction of FF", "initial position of FF" fields. These seem to
be related to some kind of quick move code.

[Here's](http://homepages.cwi.nl/~aeb/games/hack/hack.html) an
explanation for quest:

> Hack used boring rectangles for the rooms in its cave. Much more
> interesting shapes were used by Quest, a game that I never
> distributed, but that nevertheless magically found its way to many
> places.

> Hack and Quest had large parts of their source in common - the
> main difference was that Quest used its own level generator
> quest.mklev.c. I no longer have my copy - sent it optimistically
> by email from Amsterdam to Denmark and then deleted the Amsterdam
> copy, but the email never arrived: being larger than 100 kB, the
> message was discarded by some gateway.

Also explains why the source files all have a `hack.` prefix. There
were also `quest.` files around, but those seem to be lost to
history then.

There's a weird macro setup for player properties. There are helpful
comments stating that each each property is "not a ring", though not
what the property actually is:

    /* perhaps these #define's should also be generated by makedefs */
    #define     TELEPAT         LAST_RING               /* not a ring */
    #define     Telepat         u.uprops[TELEPAT].p_flgs
    #define     FAST            (LAST_RING+1)           /* not a ring */
    #define     Fast            u.uprops[FAST].p_flgs
    #define     CONFUSION       (LAST_RING+2)           /* not a ring */
    #define     Confusion       u.uprops[CONFUSION].p_flgs
    #define     INVIS           (LAST_RING+3)           /* not a ring */
    #define     Invis           u.uprops[INVIS].p_flgs
    #define Invisible   (Invis && !See_invisible)
    #define     GLIB            (LAST_RING+4)           /* not a ring */
    #define     Glib            u.uprops[GLIB].p_flgs
    #define     PUNISHED        (LAST_RING+5)           /* not a ring */
    #define     Punished        u.uprops[PUNISHED].p_flgs
    #define     SICK            (LAST_RING+6)           /* not a ring */
    #define     Sick            u.uprops[SICK].p_flgs
    #define     BLIND           (LAST_RING+7)           /* not a ring */
    #define     Blind           u.uprops[BLIND].p_flgs
    #define     WOUNDED_LEGS    (LAST_RING+8)           /* not a ring */
    #define Wounded_legs        u.uprops[WOUNDED_LEGS].p_flgs
    #define STONED              (LAST_RING+9)           /* not a ring */
    #define Stoned              u.uprops[STONED].p_flgs
    #define PROP(x) (x-RIN_ADORNMENT)       /* convert ring to index in uprops */

So, yeah. Getting complex doesn't really do this codebase much
favors.

Also in Things Whose Being a Global Variable Makes Me Uneasy:
`bhitpos`, "place where thrown weapon falls to the ground".

### `hack.main.c`

And finally getting to the main module. Interface and game logic are
mixed in the code, and the `main` function is a huge thing close to
400 lines.

Huge functions are depressing, there's a sequence of little bits of
functionality here like figuring out the name to call the player
with from the OS, which could just as well go into their own
functions. Then the main function could just be a series of calls
staying at roughly the same level of genericity, like
"player\_setup", "map\_setup", "run\_game" and so on.

At least now there are comments that describe what the subsections
are doing.

So here's a mess of setting up the terminal, figuring out the
player's username, parsing the command line parameters, some stuff
based on the unix multiuser aspects, with wizard mode logic spliced
in. The wizard gets extra command line options which give them a way
to fix the rng seed and to start out with some monsters genocided.

There's trying to load a saved game, and a recovery section which
sets gameplay variables that might have been initialized by a partly
loaded save. Getting quite messy having all this stuff, up to the
level of setting individual game variables, in the same huge
function.

The main game loop starts at around line 294. The morass of not
splitting things up into subroutines that handle sensible wholes
continues, as we have stuff like monster speed calculations, warning
messages for low HP and a complex formula for triggering player
health regeneration, all directly under the main function.

Interesting stepping-off points from the game loop seem to be
`movemon` for running the monster AI, `timeout` for checking the
player status ailments. Functions `gethungry`, `invault` and
`amulet` seem to be more complex status stuff that might get checked
at every turn, though of course the latter two have the obvious
conditions of being in a vault or on the run with the Amulet before
they do anything.

Visibility runs `seeobjs`, `seemons` and `nscr` (what does that
last one do?).

Then there's something that might relate to quick move. There's a
global function pointer `occupation` that is called and gets stopped
if `monster_nearby` returns true or if the occupation function
itself returns 0. Could also work for doing a thing multiple times
with a count.

Finally there's a call to `rhack`, which seems to be the actual
player input command dispatcher. And the immense main function ends.

The rest of the file has some minor utilities and a function for
asking the player's name.

### `date.h`

Nothing but

    char datestring[] = "Tue Jul 23 1985";

### `def.edog.h`

Extra monster data for the player's dog. Tracks hunger, training,
object dropping and something about whistles.

### `def.eshk.h`

The extra data structure shopkeeper monsters get. Contains billing
information on the items, a memory of the customer's name and the
name of the shopkeeper.

### `def.func_tab.h`

I think these are for game commands represented as function pointer,
with the command character or extended command string to go with
them.

### `def.gen.h`

Not really sure. There's a struct `gen` that's similar to the trap
and gold pile structs, and there are a couple functions related to
traps and gold.

### `def.mkroom.h`

Room data structure. Geometric bounds, type, whether it's lit.

Different room types here like `SWAMP` and `MORGUE`. Also wand shops
get their special `WANDSHOP` id. Don't know why they're special.

### `def.wseg.h`

Long worm segment struct. The general structure "pointer to
self struct; x and y coordinates; one miscellaneous data
field" relly keeps repeating here. I can see why people from the 80s
went for OO.

### `hack.mfndpos.h`

Flags, apparently for stuff the monsters can tolerate. There's
garlic there, guess it makes vampires stay away. The NetHackish way
to do that would be that you drop a clove of garlic, and then
vampires can't step into that position.

### `alloc.c`

Custom `alloc` function that calls `malloc` and panics if it returns
null.

### `hack.apply.c`

Here's the logic for using the various tools. So pretty high-level
game logic. The tools you can use in Hack are camera, ice box,
pick-axe, magic whistle, regular whistle and can opener. They have
their own use functions, which take just the tool object as a
parameter. So it's taken for granted that the tool-user is the
single player avatar, no tool-use for monsters.

Here we get the pattern that Hack and NetHack have for doing the
game rules. There's an entry point function, probably defined by
something the player does, and then it has a list of conditions for
all the possible circumstances for doing that thing and the special
things that happen. Such as using a camera while being swallowed by
a monster. It was a constant difficulty in the object-oriented
design later on to figure out where the rules that deal with
multiple different classes interacting should go to. Like should
taking pictures when swallowed by a monster be handled by the
monster that swallows things, the camera, or some kind of rule
reification object.

The camera startles and blinds monsters, and basically that's all it
does. There isn't any code to actually handle photographs, though
some kind of "picture of a ceiling", "picture of a leocrotta" data
structure would be easy enough to do and might make a fun end-game
readout. There's a separate function, `bchit` for finding the
monster hit by the camera's flash. This looks like something that
should go in a general map query module.

The ice box is a container that stops corpses from rotting. The use
command brings up one of those convoluted dialogs that asks you if
you want to take something out if there's stuff in the box, then
asks you if you want to put something in. If you're trying to put a
cursed weapon in the box, there's special code, along with a spelled
out message about the weapon being welded to your hand. This looks
like something that should be in a separate "unwield weapon"
function, not in ice box code.

The whistle wakes up sleeping monsters and sets `whistletime` value
in tame pets. The magic whistle teleports tame pets next to you.
Moving a monster next to the player is done with `mnexto(monster)`.
That's pretty simple at least. Though again it shows the player
specialness embedded in all the design, as the function isn't a
two-argument one that can teleport anything next to anything else.

The pick-axe is the most complex one of the lot. Digging holes takes
a while, and other game stuff happens in the meantime, so there's a
static global variable `dig_effort` which tracks the time spent
digging on one squre. If you have to abandon the digging effort, I
guess the variable resets and you have to start from scratch with
the same wall cell.

There's another baked-in cursed weapon check in `use_pick_axe`.
Using the pick-axe makes the player wield it, so there needs to be a
check for a cursed weapon which can't be removed before digging can
commence.

Then there's a complex dance of asking the player the direction to
dig, figuring out of the direction is actually valid, handling the
regular horizontal digging and the various non-rock-wall objects you
can encounter that way, and doing the digging downwards which makes
you dig a pit and then a hole into the level below.

Some comments in the `dig` function shows how tasks that span
multiple turns can be painful for the logic:

    /* perhaps a nymph stole his pick-axe while he was busy digging */
    /* or perhaps he teleported away */

Basically there's a branch that checks the various conditions which
makes the digging state invalid, and aborts the thing.

The persistent dig task is done like the long move was, by setting
the player's `occupation` value to point to the `dig` function.

There is also some logic for digging in shops, but the main stuff is
elsewhere in the `shopdig` function.

There's also a bit of UI layer interaction in the `dig` function.
Once you finish digging, function `mnewsym` is called to update the
map screen display of the cell you just dug into, to make it show
the new tunnel before the message for finishing the digging is
shown.

### `hack.bones.c`

This is the bones system known from NetHack. Sometimes when the
player dies, the level they were on gets saved, along with their
(now mostly cursed) stuff and the player's ghost.

The gear has 80 % chance of getting a curse. The bones level is more
likely to form deeper in the dungeon. The Amulet of Yendor, the
game-winning MacGuffin, gets turned into a fake one. Tame monsters
turn wild.

Beyond that, this seems to be using the save game logic.

### `hack.c`

Seems to be a grab-bag of functions central to gameplay.

There are things to do with visibility, `unsee` and `seeoff`, that
seem to deal with changing the visible stuff on screen on different
conditions. Unsee happens when teleporting, seeoff happens when
being blinded or swallowed or going up or down a level.

`domove` is a 200-line monster for everything the player can do with
the movement keys. Also a fine example of the rule system
architecture where many diverse game elements must be taken into
account in the scope of one function.

The player struct seems to have fields `dx` and `dy` at least
partially so that the move function can call other functions that
modify the planned movement direction, without needing to pass
around the current proposed movement direction as a parameter.

Function `domove` breaks down roughly like this:

- You wipe engravings of the cell you stand on by a random amount.
- You can't move if your inventory is too heavy.
- You can't move if you're swallowed by a creature.
- If you are confused, your movement dir changes to a random valid
  movement dir. You won't walk into walls though.
- If your movement target is not a valid cell, any long moves in
  play will end. (At least I think this is what `nomul(0)` means.)
- Seen traps will stop a long move.
- Sticky monsters (like mimics) that are stuck to you and haven't
  left your proximity will stop you from moving. If you are blind,
  the message stating this will not name the sticky monster.
- Attacking monsters causes hunger, and there's a chance that you
  might faint from hunger before you can land in a hit. If you have
  been swallowed by a monster, you always attack the swallowing
  monster.
- If you're moving instead of attacking, but in a pit or caught in a
  beartrap, you will be struggling out of the trap instead of
  moving.
- You can't move into impassable terrain. Interestingly, the
  predicate for the terrain is just `IS_ROCK`. Guess all walls are
  rock then.
- You might be pushing at a huge boulder. Unsurprisingly, stuff is
  involved:
    - If there's a monster behind it, you can't move the boulder,
      but will be told that you hear the monster behind it.
    - You can push the boulder into a pit trap to fill the pit.
    - You can push the boulder into a teleport trap and disappear
      it. (So far as I can tell, it won't appear elsewhere on the
      level.)
    - You can push it into a water tile and turn it into a floor
      tile.
    - Some weird timing stuff about when you get the message of
      actually moving the rock.
    - If you are carrying a light inventory, you can squeeze into
      the same space as the boulder.
- You're moving diagonally through a gap between two diagonally
  adjacent wall cells. You need to have a very light inventory or
  you can't fit through. A weird way to look at the interaction
  between the troublesomeness of the diagonal moves with the overall
  geometry of a square grid. This one has made it to NetHack as
  well.
- You might have a heavy iron ball chained to you as punishment.
  You can either carry the ball and drag just the chain behind you,
  or let the ball drag behind you. You get a negative `nomul` call
  for dragging the ball. Is this some sort of slowdown?
- If you walk into a pool and aren't levitating, you start to drown.
  The `drown` function is defined in `hack.trap.c`.
- If you're not blind, the field of view will be updated for your
  new position.
- If you haven't turned autopickup option off, pick up stuff from
  the ground automatically.
- If there's a trap, trigger the trap.
- Call `inshop`, in case you're in a shop.
- Unless you're blind, read an engraving at the current location.

Ouch. This thing kinda looks like it could use some sort of hook or
subprocess or whatever architecture to break it up a bit. On the
other hand, it's now pretty obvious where everything is, even though
it does result in a humongous function. Still, are these the sort of
functions that make roguelike developers eventually lose the desire
to work on their mature projects? At the very least, that thing
should be split into several subfunctions, with a top function that
just has the list of subfunction calls.

The next somewhat involved function is `pickup`. A grab bag of
conditions again. You can't reach the
floor if levitating. Gold isn't an actual object and goes to your
gold stat instead of the inventory. You can't pick up the chain of
the ball and chain. For multiple objects, you are asked whether you
want to pick up the individual ones.

Picking up cockatrice corpses without gloves is an instakill, as in
NetHack. As it was back in Rogue, scare monster scrolls dropped by
player are destroyed when they are picked up again. (From a modern
standpoint, the UI should probably ask the player that hey, are you
sure you want to destroy the scroll, since you probably mostly want
to leave the dropped scrolls as perpetual monster blockers unless
there's some special circumstances.)

Then there's the handling for item stacks. And for the cases where
you can lift some number of items from the stack, but not all of
them.

When you get to actual picking up, there's still the chance to fail
if you already carry 52 distinct items. Every item is assigned a
lowercase or uppercase Latin letter, and when you run out of
letters, you're out of space. Then there's the check for picking up
items in shop, in which case you will owe their price to the
shopkeeper before we get to the bookkeeping for actually moving the
item object into your inventory.

Next function ls `lookaround`. Based on the comment, this is for the
long move commands, running through tunnel corners and figuring out
if there's something new in sight that requires that you stop.
There's checks for monsters not being shapeshifted mimics, invisible
when the player can't see invisible, or tame so that they are things
that will register as threats. Known traps only stop you when
they're in the way, not if they just generally come into sight.

Then there's the hairy logic for figuring out the turning in
corridors. I'll pass trying to figure it out.

Function `monster_nearby` is simpler, it's just used to check if
there's an attacker in the immediate vicinity that threates you, and
used to break out of a multi-turn occupation. There's specific logic
for ignoring monsters `"Ea"`, so floating eye and acid blob? Those
don't attack unless provoked?

Then there's stuff for setting the field of view in `setsee`. Seems
to create a rectangular area based on the light level of
surroundings and update that. Playing on everything being dark
corridors and rectangular rooms?

Then there's suddenly some battle statistics stuff. Functions `abon`
and `dbon` seem to be attack and defence bonuses, with delightfully
cryptic 80s pen&paper RPG style tables, and references to those
horrible old-school D&D 18/50, 18/99 strength values. The stat
computations are pretty straightforward functions otherwise.

### `hack.cmd.c`

A big lookup table from key characters to function pointers of the
corresponding actions.

Then there's the `rhack` function that parses a command string, sees
whether it's a type of movement command, an interrupt, or something
from the lookup table, then calls the appropriate function. Various
quick move and command count options make the function more complex.

There's also `doextcmd` for the `#`-prefix commands that
unsurprisingly ended up in NetHack as well. The ext commands here
are "dip" and "pray".

Quite strangely the function `isok`, which checks whether a
coordinate position is within the game map, is also in this file.

### `hack.do.c`

Another grab-bag module. `drop` drops stuff. The cursed weapon check
shows up again, of course. Moving downstairs or upstairs. These call
the direct level changing function `goto_level`.

The previous level is saved to a file when `goto_level` is called.
There's an actual bit of logic with an in-game error message when
you can't create the file for the save. So you could actually keep
the game going, multitask into figuring out why you can't create
files, then get back and be able to go through the stairs?
`keepdogs` brings nearby pets along.

Lots of mixed stuff related to in-game bits, datastructures and disk
serialization mixed in here. Would be nice to have some sort of disk
serialization << data structure operations << game logic layering
going on here instead of having everything in a soup.

The fun thing with going down stairs, while burdened, and wielding a
cockatrick corpse is already present. Function for cockatrice
suicide is `selftouch`.

Another big function for throwing things, `dothrow`. These things
are really hardwired to the player doing them, taking player input
to choose the item, negotiating on available items, printing
feedback messages on what happens and so on. Making things symmetric
so that the same logic would work for both players and monsters
would make the code look very different.

There's another cursed weapon check and a message that it's welded
to your hand if you try to throw it. There are 8 variants over the
source code for the message about your weapon being welded to your
hand. Why not make some remove-weapon function that gives the
message and returns false if the weapon is cursed?

Throwing potions at monsters is a thing in Hack. You can also hit
yourself. A lot of the special cases for everything design style
NetHack is made of is already present here.

Then there's a long and nasty logic slog for when a thrown object
hits a monster, with case branch for different object types.

You can throw yourself around by throwing the punishment ball and
being dragged by the chain. There's logic for leg wounds, and you
get one if you escape a bear trap by throwing the ball and tearing
up your leg.

### `hack.do_name.c`

Naming is another of the weirdly complicated small features in
NetHack. You can name individual objects and types of objects.
This is mostly used in NetHack for experienced players to write down
item identification guesses that the game could just as well give
out automatically once the proper hints have been acquired to lessen
spoiler dependence, and it's not seen much in modern roguelikes.

Because you can pick objects to name from the map with a cursor,
there's also the function to get the point from the map with a
cursor, `getpos`, in this file. Total lack of interface separation
again.

You can name monsters. I guess you'd use this on your pets.

Confidence inspiring comments:

    /*
     * This routine changes the address of  obj . Be careful not to call it
     * when there might be pointers around in unknown places. For now: only
     * when  obj  is in the inventory.
     */

This is for `do_oname` for renaming items. C programming gets quite
creaky when freeform strings are involved.

### `hack.do_wear.c`

Equipment logics. Won't be a surprise that UI and logic get blended
together. Details like not being able to change gloves with a cursed
weapon in hand are here already.

There's complex logic for keeping the equipment set consistent with
existing equipment, with global variables pointing to the player's
current equipment slots. You can only wear one of an armor type, two
rings, and so on. Everything's special cased per type of armor, no
data-driven programming here. A more generic game (like DCSS) would
probably want to support different creature types with different
equipment slots, though I guess that could be just another set of
special case branches.

The separate treatment for rings and armor is here. I never figured
out why you had to have different wear commands for them. I guess if
you have different starting point functions and you do the UI by
mapping keys into function pointers, you'd get different keys too.
But why not just have one command for all equips?

Doesn't look like there are any amulets here besides the Amulet of
Yendor, nor is there wearing amulets in the logic.

### `hack.dog.c`

All pets are "dogs" here, apprently. The monster function here is
`dog_move`, with 260 lines.

This handles hunger, looking for food (dogs know not to eat
cockatrices), delays from eating food, avoiding traps and cursed
objects.

Function's a mess of data structure internals juggling. Not really
bothering to read through it. The end result is dog doing dog stuff.
Factoring lower-level stuff into utility functions so that this
function could actually be written at a dog behavior logic level
instead of constantly dipping into coordinate and pointer juggling
would have been great here.

### `hack.eat.c`

Hunger and eating. There's quite a bit on tins and how well various
items work for opening them. Not really sure why the game needed to
have tins to begin with.

Mostly the same old thing here. Entry point function for the eat
command, asking the player what to do, then a tangle of logic for
the various types and states of foods. Food poisoning, dying from
choking on food when eating while oversatiated.

There's a function for corpse intrinsics. There's a dire warning if
you eat humans, but all you get is an aggravate monster trait, like
you do from eating a dog.

### `hack.end.c`

Death messages and high score tables. Nothing that interesting here
for the rest of the gameplay. Just really long functions for
creating the death message and handling the high score table.

I'm not sure if Hack had the monster kill stats thing yet.

### `hack.engrave.c`

Engraving is another weird Hackism like object naming that has
gratuitous string input, complex rules involved with it, and doesn't
tie in that much with the rest of the gameplay. It's basically only
used for the thing where engraving Elbereth on the floor makes a
square that frightens the monsters as long as the engraving stays
intact. This has basically been lambasted as bad design, both from
the spoiler-dependence viewpoint and as basically a patch over the
game randomness throwing otherwise unsurvivable stuff at you.

Still, lots of logic here, with the various engraving tools, from
writing on the dust with your finger to using a wand of fire to burn
the words. And you need to not be levitating for methods that
actually need you reaching the floor, but can use the wand even from
above.

### `hack.fight.c`

Combat code. Special function `hitmm` for monsters fighting each
other. (Hack does have rings of conflict in addition to pets.) The
player hitting monsters is handled in `hmon`. These names are sorta
cryptic for globally accessible functions... Another special case
jumble here. Two-handed swords called 'Orcrist' doing extra damage
against orcs is checked in `hmon`. So, yeah, neat, but another
spoiler exploit bit of design where naming the sword when you do
know the trick is a no-brainer, but that naming the sword like that
actually helps isn't discoverable without a hint from outside the
game mechanics. Also, apparently garlic will frighten any undead.

The logic for when you're just trying to hit the monster goes in
`attack`. This alerts the monsters even if you fail to deal damage.

### `hack.invent.c`

Invetory object data structure juggling. Logic for objects on map.

Function `getobj` is a generic invetory selection thing, like for
picking the food item to eat or the wand to zap. It's horrible.

The whole text app command prompt UI is really thick in this module.

### `hack.ioctl.c`

Unix signal stuff.

### `hack.lev.c`

Saving levels and objects on a level to disk for the level
persistence and save games.

### `hack.makemon.c`

Random monster generation. Some monster traits, like invisible
stalkers being invisible, are set in the `makemon` function. I guess
the monster type data isn't expressive enough to handle all of
these. There's also special logic to always create a horde of orcs
or killer bees when you randomly create one of them. (I guess this
means that you can't call `makemon` and expect to create at most one
new monster.)

Some position functions here for getting good random locations for
the monsters.

### `hack.mhitu.c`

Getting hit by a monster, very different things can happen here than
when you hit a monster. For example you might be swallowed by a
monster who then gets stoned by a cockatric, which will turn you to
stone as well. Nice.

Lovely check idiom against specific monster types:
`if(!index("1&DuxynNF",mdat->mlet))`. The string has the letters for
the monsters that don't apply to the following branch.

Giant switch-case on monster letter then, with special attacks for
the types.

### `hack.mklev.c`

Hack has rooms-and-corridors and maze type levels. Haven't seen
rooms data structure used much elsewhere, but it is present here.

Not noticing anything particularly interesting in the room code.
Some nice abstraction with the corridors though, you just call
`join` with the indices of the two rooms, and it'll try to dig an
inbetween corridor. This also creates doors in the openings.

### `hack.mkmaze.c`

This makes mazes. Nobody likes mazes in games.

### `hack.mkobj.c`

Making items, like you make monsters. Again there's the creator
method `mksobj` with a special case dispatch based on item type. It
sets curses, item counts, want charges etc.

### `hack.mkshop.c`

This seems to have turned into a general special room logic instead
of just being for shops. It can generate zoos and morgues and things
as well. Seems to work by finding existing rooms and modifying
those.

### `hack.mon.c`

Monster behavior. AI that looks for monsters to move in `movemon`.
Function's a mixed bag otherwise, it handles monsters drowning in
pools, the player getting a warning about monsters if they have a
special ability for that, and deallocating data for the dead
monsters.

Movement function is `m_move`. Dogs, shopkeepers and guards get
special function calls. Greedy monsters can be distracted by gold
or gems on the floor, which is a nice touch.

Somewhat interesting function is `killed`, which details what
happens when a monster gets taken out. You get experience, lose luck
for killing humans or other peaceful things. Humans are always
friendly in Hack, looks like. Also you lose telepathy for killing
humans.

There's experience gain and also going up a level here. The monster
object gets cleaned up and a corpse item gets created.

### `hack.objnam.c`

Generating the object name string. C code for string handling is
mostly just depressing.

There is `readobjnam` here, that's used by wishing. It's messy.

### `hack.o_init.c`

Shuffling the unidentified item descriptions I guess.

### `hack.options.c`

Game options. Cruddy stringy ad hoc command liney interface to them.

### `hack.pager.c`

Inline browser for help files.

### `hack.potion.c`

Potion effects, you know the drill.

There's dipping into potions, but since Hack doesn't do blessings
and holy water yet, there's not much use for it. You can poison
arrows, darts and bolts.

Smoky potions may contain ghosts.

### `hack.pri.c`

Map display. Lots of special cases and three-letter function names.

### `hack.read.c`

Reading scrolls. Special case switcheroo.

### `hack.rip.c`

Print the player tombstone.

### `hack.rumors.c`

Print a rumor from the rumor file. It maintains a bit vector for
rumors that have been used already, and tries to give you new ones
every time.

### `hack.save.c`

Saving game. Doesn't seem to be doing anything particularly clever.

### `hack.search.c`

Looking for hidden stuff. Traps, secret doors, mimics.

### `hack.shk.c`

Hello three-letter names. Shk means 'shopkeeper'. Stuff for
shopkeeper AI, bills, trying to steal etc. Also for the quite
non-shop special rooms mixed in here.

Again there's a lot of logic for something that other games mostly
just abstract away, since most don't seem to consider it to really
make that much of a contribution to core gameplay.

### `hack.shknam.c`

Shopkeeper names. They seem to be place names from different
countries.

### `hack.steal.c`

This is for monsters stealing stuff, not for the player stealing
from shops.

### `hack.termcap.c`

Terminal handling crap.

### `hack.timeout.c`

Status effects timing out.

### `hack.topl.c`

Message printing.

### `hack.track.c`

Data structure for coordinate lists.

### `hack.trap.c`

Trap logic. Traps can hit both monsters and player. `dotrap` is the
function for player, `mintrap` is the one for monsters.

Teleporting is also here. Teleport control is a possible intrinsic.

### `hack.tty.c`

Terminal handling crap.

### `hack.u_init.c`

Character creation dialog. Player object initialization.

### `hack.unix.c`

Stuff for clock, mail, file system etc.

### `hack.vault.c`

There are vaults you can rob if you can get in them. Basically the
same as NetHack. There are guard NPCs who use weird adventure game
logic of popping up and disappearing instead of being more
persistent creatures in the game world. Also another spoiler exploit
and gratuitous string input bit where you can identify yourself as
Croesus to the guard to get a free rein to loot the vault.

Fun fact: Multiple Greek transliterations are supported. The player
can identify themselves as either "Croesus" or "Kroisos" to a vault
guard to be left in peace. Although the string comparison doesn't
seem to be case-insensitive, so you'd better capitalize the name
correctly. This is still around in NetHack, but there the matching
is case-insensitive. From Nethack: "His name can also be spelled
Kroisos and, if your game has Tourists, as Creosote, after a
Discworld character based on Croesus."

Again there's a sizable chunk of special logic for a very minor part
of the game. I'd think these things will add up into a headache for
the maintainer eventually.

### `hack.version.c`

Printing the version string.

### `hack.wield.c`

Logic for wielding and enchanting weapons.

### `hack.wizard.c`

So this is for Wizard of Yendor, the end boss, as opposed to Wizard,
the player class, or Wizard Mode, the game debugging interface.

The Wizard will steal the Amulet and teleport back to the bottommost
level if he has it. Which seems pretty dickish if this happens close
to surface. Not sure if the Wizard also comes back from the dead in
this version, or if that's just NetHack. Other than that, there's
just some extra nasty array of special abilities in play here.

### `hack.worm.c`

Long worms. Another complex bit that doesn't really matter for
gameplay. Guess it's neat to have multi-tile monsters though.

### `hack.worn.c`

Helper stuff for equipment bitmasks.

### `hack.zap.c`

Zapping wands. Same thing as with the other multi-use items. Wands
do have the extra complexity of sometimes requiring aiming and other
times just doing a thing. Also wands of wishing are a thing, and use
the string to item type function `readobjnam`.

Boomerang use and monster ranged attacks are also here.

### `makedefs.c`

Some kind of offline tool.

### `rnd.c`

Some very simple rng utility functions.
