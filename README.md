Roguelike source code review project
====================================

(C) Risto Saarelma 2013

The plan: Study major and not-so-major open source roguelikes and
write articles about interesting implementation details and how they
solve the common problems in roguelike development.

Question list:

- What are the main data structures?
- What is the overall program flow starting from the main function
  like?
- What are the source code files and what do they deal with?

----

- How do you tell whose turn to act it is?
- How are creature speeds and changing the speed handled?
- Can events be scheduled to happen in future?

----

- How are save games implemented?

----

- What's the map representation like?
- How are mobs and items found on the map?
- How do ranged effects work?
- How do area effects work?
- How does runtime map alteration work?
- How does FOV work?
- Is there a map memory? Can it handle the map changing outside FOV?
- How does illumination work?
- Is there pathfinding? How does it work?

----

- How does level generation work?
- Is there an easy way to plug in different generators? How do you
  choose between them?
- Are there vaults? How are they specified? How are they placed on
  the map during map generation?
- How do you pick open spots to spawn items and mobs? What if there
  isn't an open spot left?
- Do you spawn monster bands?

----

- How are item and mob types specified?
- How do you decide which items to generate on level?
- How are mobs or items generated and destroyed?
- Are there status effects? How do you determine what they do? (Eg.
  confusion)
- Is player conduct and kill lists tracked?
- How does the mob AI work?
- Can you get mob infighting?
- Can you get pets?
- Can monsters have inventories?
- Can the player be stealthy? What makes the monsters pay attention?

----

- How is item randomization implemented?
- How does the player inventory work?
- How do equipment slots work?
- How do you calculate the player stats modified by equipment?
- Are there containers?
- Is there item stacking? How does it work?

----

- What kind of stat system is used?
- What kind of score system is used?

----

- How are the messages formatted?
- How is the UI done?
- What's the console backend like?

----

- Is there polymorph? How does is work?
- Is there wishing? How does it work?
- How does invisibility work?

----

- How would you add new monsters or items?
- How would you add new effects or spells?
- How would you attack new other rules?

----

- What's particularly clever?
- What's particularly ugly?
