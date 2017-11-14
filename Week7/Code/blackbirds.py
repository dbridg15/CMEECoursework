import re
import prettytable

# Read the file
f = open('../Data/blackbirds.txt', 'r')
text = f.read()
f.close()

# remove \t\n and put a space in:
text = text.replace('\t', ' ')
text = text.replace('\n', ' ')

# note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform
# to ASCII:
text = text.encode('ascii', 'ignore').decode()

# Now write a python script that captures the Kingdom,
# Phylum and Species name for each species and prints it out to screen neatly.

# Hint: you may want to use re.findall(my_reg, text)...
# Keep in mind that there are multiple ways to skin this cat!
# Your solution may involve multiple regular expression calls (easier!),
# or a single one (harder!)


kingdom = re.findall(r'Kingdom (\w+)', text)
phylum = re.findall(r'Phylum (\w+)', text)
species = re.findall(r'Species (\w+\s\w+)', text)
# english = re.findall(

# make table

x = prettytable.PrettyTable()

x.add_column('Kingdom', kingdom)
x.add_column('Phylum', phylum)
x.add_column('Species', species)


print(x)
