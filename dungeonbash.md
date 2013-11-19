Martin's Dungeon Bash
=====================

Notes on Martin's Dungeon Bash version 1.7.

A modern roguelike with a very small code base.

Source code overview
--------------------

Source uses mixed tabs and spaces for indentation. It will be laid
out wrong unless your editor has tab width set to 8. The only reason
to use physica tabs at all is to support variable indetation
levels, so this is just doing it wrong.

     483   1469  10787 dungeonbash-1.7/bmagic.c
      59    330   2169 dungeonbash-1.7/bmagic.h
     468   1450  10897 dungeonbash-1.7/combat.c
      47    269   1728 dungeonbash-1.7/combat.h
     701   2001  16275 dungeonbash-1.7/display.c
     424   2203  15567 dungeonbash-1.7/dunbash.h
     629   1740  13263 dungeonbash-1.7/main.c
     506   1730  11881 dungeonbash-1.7/map.c
      38    240   1546 dungeonbash-1.7/misc.c
     931   3335  20853 dungeonbash-1.7/mon2.c
     505   1454  10627 dungeonbash-1.7/monsters.c
      65    388   2605 dungeonbash-1.7/monsters.h
     826   2225  18752 dungeonbash-1.7/objects.c
     189   1243   8181 dungeonbash-1.7/permobj.c
     162    986   5921 dungeonbash-1.7/permons.c
      66    281   1930 dungeonbash-1.7/pmon2.c
      74    426   2626 dungeonbash-1.7/rng.c
     677   2050  14746 dungeonbash-1.7/u.c
      62    352   1886 dungeonbash-1.7/vector.c
    6912  24172 172240 total

### `dunbash.h`

Enumerations: Damage type `damtyp`, player command `game_cmd`,
terrain type `terrain_num` (only four types of terrain), player
death type `death`, item class `poclass_num`.

Player and monsters are different types, player has struct `player`,
the monsters have struct `mon`.

Monster rarity: "Chance in 100 of being thrown back and regen'd."
Interesting way to do the distribution.

Monsters have a melee and a ranged attack and some special flags.
Monster and item spawn object symbols are done using a strange
`#define` cascade:

    #define PM_NEWT 0
    #define PM_RAT (PM_NEWT + 1)
    #define PM_WOLF (PM_RAT + 1)
    #define PM_SNAKE (PM_WOLF + 1)

Why not just use enum for these?

Structs `permon` and `permobj` are used for the monster and item
generation. The live versions are `mon` and `obj`. Items have a
single "power" stat that tells how good a weapon or an armor is.
The behavior code will sometimes have special conditions on
specifically named equipment types though.

There is a note about changing the fixed 100-element monster table
to be a "Tatham tree" when the game gets developed further. Does it
mean
[this](http://www.chiark.greenend.org.uk/~sgtatham/algorithms/cbtree.html)?

### `display.c`

Curses display. Seems to use some kind of buffering so that it won't
create curses instructions for redrawing unchanged characters?

Also, this uses the windows system in curses. Usually games treat
curses as a thinner layer.

`print_msg` is the standard roguelike message printout. It takes
printf style varargs. It just prints the messages into the curses
window, there's no checks for flooding the window with too many
messages, which is noted in a comment.

There are some rather text-intesive functions like `print_inv` mixed
with the lower-level stuff dealing with curses arcana.

Hardcoded keys for directions, either numpad or hjkl. Also hardcoded
input keys for commands, but the commands themselves get turned into
enum values instead of causing functions to be called. No parameters
for the enums though, 'q' is just `QUAFF_POTION`, and you still need
to figure out which potion, so I guess it's taken for granted that
you can poll the player for extra information after getting the base
command.

### `main.c`

There's a bunch of hardcoded number 100 around for the monster and
object global arrays.

There's an extremely simple save and load system here. Appears that
basically all game state is just flat data, everything is
referred to using integer indexes, so there's no pointer
invalidation. The level isn't saved, just the rng seed for
generating it. Apparently there's no level persistence either, so no
need to worry about saving the wider world.

Then there are some dice-rolling rng utility functions here. Strange
place for them.

Big setpiece is `do_command`, which feeds the `game_cmd` enum from
`display.c` into a switch-case. Wonder why the commands weren't just
function pointers or something to begin with. The switch-statement
is basically a mess of completely disparate pieces of functionality,
outside some groups of commonality like the different directional
movement commands. It returns whether the command caused the
player's turn to end or not.

Game toplevel runs at `main_loop`. There's some sort of device for
selecting for different speeds of monster and player for different
update cycles, so the slow things move less and the fast things move
more. Some persistent repeating effects from the player's stuff are
baked right into this loop. Should probably be in a separate
function...

Then there's the monster update cycle, with another hardcoded number
100. Monsters get a status update (seems to be used just for hp
regeneration) with `update_mon` every turn, and they get `mon_acts`
if their speed lets them act on the current cycle.

Player regen and other status updates are similarly at
`update_player`.

### `map.c`

A bunch of global variables for the map. ("For now, I can't be
arsed with a mapcell structure") Each map cell can have a single
monster or item. Also there's flags, mostly whether it's explored.
There's some concept of room in use. Map cells can belong to a room,
and rooms have bounds values and a connectivity matrix. Maps are 42
x 42 cell, and they scroll, Dungeon Crawl style.

I think the mapgen uses the classic Rogue generation where the map
is divided into a grid, and new rooms are placed within the grid
cells, so you don't need to worry about room overlaps.

Rooms are connected with straight corridors usning the `link_rooms`
function. There are always doors between the corridors.

Going down stairs calles `leave_level`, which cleans up the level
data of the current level, and `make_new_level`, which builds the
next one. `leave_level` sets global variables `status_updated` and
`map_updated`.

`build_level` is the mapgen top function. It saves the rng state so
that the level can be recreated from save file, then then links the
rooms. The linking is basically a bunch of hardcoded logic that
relies on the 3x3 room layout.

There are zoo rooms created with `generate_zoo`, but they only get 9
monsters, instead of being filled with monsters like the tension
rooms in Adom.

The generator tracks the room with the stairs and the room with the
zoo, and makes sure the player isn't placed in either.

### `misc.c`

Just string names for damage types. I wonder if there was supposed
to be more here.

### `objects.c`

Using the various perishable objects here. As usual, all references
to objects at API level are integer indices to arrays, not pointers.

Scrolls and potions are basically the same, there's a switch case
dispatch for the different effects. Like with the player commands,
each effect could basically be a separate function, and the item
type table could just be a function pointer lookup, instead of
having a switch-case of basically unrelated bits of code.

There's a hard-coded 20 elements in the un-id:d ring, scroll and
potion types. `flavours_init` sets up a table of 10 of them. There's
a messy permutation loop that keeps re-guessing the next item until
it hits one that hasn't been seen before. The Knuth shuffle would be
the cleaner way to do random permutations. Also, the code block is
copy-pasted for each of rings, scrolls and potions.

`create_obj_class` creates random objects of a certain class, like
potions or scrolls.

Then there's copy-pasted code for printing object names either to a
file or to the on-screen messages.

Picking up stuff with `attempt_pickup`. Takes no parameter,
implicitly tries to pick up from the player's location. Also,
there's just one item per cell, so there's no need to make an item
select UI. Gold gets picked up automatically and goes into the gold
count stat, stackable items get stacked if you already have some in
your inventory. Otherwise you need to have a free slot from your
hardcoded 19 available ones.

Weapons and armor can be damaged with `damage_obj`.

### `permobj.c`

Item stat data.

### `permons.c`

Monster stat data.

### `pmon2.c`

Helper functions to query monster types.

### `rng.c`

A simple custom random number generator that returns ints and a
random seed function that uses system time, process id and user id
to set things up.

### `vector.c`

Geometric vector utils. There's just a single function
`compute_directions`. Given two 2d int points, it returns the deltas
between them, the 8-dir unit vector towards the second one, and
whether the second point is within a cardinal axis from the first
one (presumably for ranged attacks along movement directions) or
within melee distance. I guess this is a catch-all geometry helper
for AI code.

### `u.c`
### `monsters.c`
### `mon2.c`
### `combat.c`
### `bmagic.c`
