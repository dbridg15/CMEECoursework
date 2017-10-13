#! /usr/bin/env python3

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.

latin_lc = set([entry[0] for entry in birds])
print(latin_lc)

common_lc = set([entry[1] for entry in birds])
print(common_lc)

mass_lc = set([entry[2] for entry in birds])
print(mass_lc)


# (2) Now do the same using conventional loops (you can shoose to do this
# before 1 !).

latin_lp = set()
for entry in birds:
    latin_lp.add(entry[0])
print(latin_lp)


common_lp = set()
for entry in birds:
    common_lp.add(entry[1])
print(common_lp)


mass_lp = set()
for entry in birds:
    mass_lp.add(entry[2])
print(mass_lp)



# ANNOTATE WHAT EVERY BLOCK OR, IF NECESSARY, LINE IS DOING!

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS
