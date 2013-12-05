Rogue
=====

Source code review by Risto Saarelma, 2013-11-17

Notes on Rogue Clone 5.3, a BSD-licensed clone of the original Rogue written by
Tim Stoehr.

The main function is impressively simple.

    if (init(argc, argv)) {		/* restored game */
        goto PL;
    }

    for (;;) {
        clear_level();
        make_level();
        put_objects();
        put_stairs();
        add_traps();
        put_mons();
        put_player(party_room);
        print_stats(STAT_ALL);
    PL:
        play_level();
        free_stuff(&level_objects);
        free_stuff(&level_monsters);
    }

It just loops the map creation and gameplay over and over. Though arguably the
`make_level` to `put_mons` sequence of level generation functions should maybe
be under a single function to keep a consistent level of abstraction.

Source code overview
--------------------

        1      3     21 rogue/patchlevel.h
      450   1419  10268 rogue/rogue.h
      650   1891  11545 rogue/curses.c
      417   1093   7896 rogue/hit.c
      280    695   5017 rogue/init.c
       67    113   1037 rogue/instruct.c
      465   1213   8988 rogue/inventory.c
      840   2471  17518 rogue/level.c
      594   2643  16653 rogue/machdep.c
       64    146   1127 rogue/main.c
      323    855   5626 rogue/message.c
      828   2195  17882 rogue/monster.c
      540   1415   9758 rogue/move.c
      773   2267  16368 rogue/object.c
      519   1273   9779 rogue/pack.c
      247    496   3840 rogue/play.c
      105    302   1840 rogue/random.c
      288    797   5692 rogue/ring.c
      424   1323   8628 rogue/room.c
      415   1241  10196 rogue/save.c
      538   1543  10347 rogue/score.c
      500   1320   9964 rogue/spec_hit.c
      287    868   6033 rogue/throw.c
      247    787   5280 rogue/trap.c
      578   1541  11639 rogue/use.c
      224    603   4704 rogue/zap.c
    10664  30513 217646 total

### `rogue.h`

Global defines. Common data structures.

### `curses.c`

Low-level interface code goes here. Mostly game-agnostic.

### `hit.c`

Combat. The damage values are actually "3d6" style dice roll
strings, which is cute. Also kinda stupid and makes them hard to
generate procedurally.

### `init.c`

Startup code.

Player gen actually sets up all the properties of the player's
equipment, instead of using a general factory system so this part
could set up the player with initial equipment that isn't found
anywhere elsewhere in the game.

### `instruct.c`

Help text file pager. Very simple.

### `inventory.c`

Wand and gem type strings. Scroll syllables here.

Func `inventory` is the UI for showing inventory.

Then there's the random unid'd title generation. I guess because the
module also handles the display.

Then there's a complex function for generating the string
description for an item.

### `level.c`

Map generation here. There's the 9-room mapgen in a 3x3 grid.

Also leveling up, for whatever reason.

### `machdep.c`

System dependent code.

`md_slurp`: Clear keyboard input buffer

`md_control_keyboard`: Configuring which input sequences get
through. Some terminal arcana here.

Functions to map interrupt, quit and hangup signals to game
functions. Interrupt is used to stop autorest and autofight.

Some file status operations. Reading time for save games. Reading
environment variables. Also malloc, interestingly.

Seeding the rng, this one uses process id, which seems kinda weak.

### `main.c`

Here's the pretty main game loop, very little anything else.

### `message.c`

Printing the message sting. No varargs.

Reading an input string.

Printing the stats string, with a nice visualization comment:

    Level: 99 Gold: 999999 Hp: 999(999) Str: 99(99) Arm: 99 Exp: 21/10000000 Hungry
    0    5    1    5    2    5    3    5    4    5    5    5    6    5    7    5

You don't have stats beyond hp and strength, so this is pretty
complete. Doesn't show your weapon damage though.

Using a pad function instead of the printf format strings for
numbers. I guess because that won't work when you have a pair of
numbers you want to right-justify.

There's also a (text file) screenshot function here.

### `monster.c`

The table of monster names and stats. Stats aren't tabulated or
annotated in any way, so tricky to read. Also how does this work,
the structs don't actually seem to have all the fields?

Some creatures have two damage values, like "1d3/1d2".

Wandering monsters can be created in roam mode.

Top monster AI seems to be `mv_mons`. It mixes iterating through the
monsters and running the toplevel AI. Dispatches to `mv_monster`
that does more detailed move logic. Monsters seem to just home in on
the player by default, `mv_monster` gets player pos as arguments.

`party_monsters` creates a bunch of monsters in one room.

`mv_monster` wakeup logic, figuring out where to move. Wakeup
involves player proximity and `stealthy` variable. Stealth means
player invisibility maybe?

Functions for waking individual monsters and all monsters in a room.

There's a whole separate `wanderer` function for the non-attacking
monsters.

Mixing UI with logic with `show_monsters`.

There's no complex line of sight. Monsters see everything in the
same room and everything next to them elsewhere. So the rooms and
corridors design is actually a big deal, mechanics wise, not just
the corridors being basically narrower rooms.

Also there's a separate function `mv_aquatars`, which seems to be
called before the player removes armor or weapons. So aquatars get
singled out specifically so that they can get a shot at equipment
ruining before the player can stow it away.

### `move.c`

Player movement.

`one_move_rogue` is the toplevel player movement command, which does
the smart attack, handling confusion and teleportitis and the works.
Long move is `multiple_move_rogue`. The direction values are just
the default movement key codes.

Hunger check is here. I guess because it's part of player update
tick.

`reg_move` updates monsters and status effects.

### `object.c`

A bit mixed. There's the player object, the ID data for the various
item types.

`put_objects` places the items. Makes them with `gr_object`. Global
`cur_level` is used for depth.

`gr_object` decides what to generate, then generates some. Item
generation doesn't seem to depend on current level.

It finds objects at a give position with `object_at` by just
iterating the entire list and returning the first one with given
coords. It takes the starter object as parameter, so you can repeat
the call with that object to get further objects. Clever.

`make_party` seems to be for creating a batch of new random monsters
periodically on the current map.

### `pack.c`

Inventory and item handling. Special logic hooked to the functions,
like a scare monster scroll turning to dust if you drop it and pick
it up again. (The scrolls on the ground stop monsters from entering
the cell, so having them freely movable would make them multi-use.)

You can't drop items in cells that already have an item. The
intrusive linked list pattern should let you have item stacks pretty
easily. Maybe they're an user interface headache.

A lot of UI stuff mixed with the logic again.

### `play.c`

Toplevel gameplay function `play_level`.

It's a big switch-statement for a getch. Hardcoded letters.

### `random.c`

There's a custom random number generator. Nothing particularly
interesting, and the utility functions are pretty simple.

### `ring.c`

Ring items. These grant you persistent effects. `put_on_ring` is the
command to wear one. `ring_stats` resets the ring-relevant effects,
then applies them based on the rings the player is wearing. I think
this needs to assume that nothing else than a ring can affect any of
those variables.

### `room.c`

Rooms are a special thing in Rogue.

Dungeon is the actual tile map. I think the map memory might be just
the screen buffer... At least that's the only way I see
`draw_magic_map` updating visible stuff. Though the dungeon tiles do
have a `HIDDEN` flag.

`dr_course` is some kind of monster pathfinding routine. Could maybe
use a bit more comments to figure out just what the deal is.

### `save.c`

A nice look into the overall state. There's a bunch of floating
global variables that need to get manually shoved into savefiles,
like all the player status ailments. I'm guessing monsters can't get
debuffs then.

Other than that, saving and loading is pretty simple. Most
everything is flat data except the object chains. The chains are
just written linearly. When reading the chain, it checks for stuff
flagged as player equipment and equips it.

Functions with `rw_` prefix can be parameterized to either read or
write, so you can use the same code for both saving and loading a
game. A bit like the pattern Boost::Serialize uses much later.

### `score.c`

End game stuff. Death and victory messages. Printing score.

### `spec_hit.c`

Status effects from monsters here. `special_hit` is the starting
point function.

When the player gets frozen, there's just a loop calling `mv_mons`.
Nothing more complex for mucking with the update timing system.

Other special behavior like monsters going for gold on the ground
also here (`seek_gold`).

### `throw.c`

The player throwing items. Starting point function `throw`. Complex
mix of interface, gamestate queries and update logic again. Can only
throw in the main movement directions.

You can throw daggers, shurikens or darts, or arrows if you're
wielding a bow. The weapon types are hardcoded in
`throw_at_monster`. Appropriate weapons do more damage and hit
better.

There's a complicated function `flop_weapon` for finding a spot for
the object that falls on the ground. Apparently there needs to be
free space, you can't just have the thing fall down in the same cell
a monster is occupying.

### `trap.c`

Traps are stateful, there's a table of them, and the location lookup
is done using `trap_at`. I guess ADOM does one cleverer here, by
determining trap type from position hash function, so it can have
the traps as pretty much stateless terrain. There doesn't seem to be
anything to the trap data beyond the type and the position.

Traps only get created in rooms, as usual for the rooms/corridors
dynamic.

### `use.c`

Using perishables. Potions, scrolls, food. Identification code here
too.

Hallucination just operates on the screen buffer and turns item and
monster characters on screen into random characters.

`relight` repaints the screen.

### `zap.c`

Zapping wands. These give status effects to monsters. `zap_monster`
is the effect function.

Data structures
---------------

Both monsters and items use `struct object`. The source calls items
'objects', but also uses the 'object' type for both monsters and
items. Confusing. The fields have different meanings for items.
There are defines that map the item item names into the monster
names. Ugly.

The struct has a pointer to the next object/monster. Maybe both
monsters and items are in the same list, and this is the reason
for the duality.

The player is represented by `struct fighter`. The inventory is
`object pack` (not a pointer, interestingly). Equipment slots are
object pointers in the struct. The whole player character has a
simple enough data model to be represented with the struct.

Other structs: `id`, `door`, `room`. Door and room are maybe used in
mapgen? `trap` consist of type and position.

Global variables:

- `rogue`: The player
- `rooms`
- `traps`
- `dungeon`: The level map, `unsigned short`
- `level_objects`: An object value, this uses the intrusive list then.

There are id arrays for scrolls, potions, wands, rings, weapons and
armors. The id struct has string buffers for the unidentified and
identified names. Also a value field, seems like what it'd cost at a
shop or something. It seems to be for score here.

- `mon_tab`: Prototypes for monster creation. These are objects, so
  this uses the prototype pattern I guess.
- `level_monsters`: An object value. Like `level_objects`.
