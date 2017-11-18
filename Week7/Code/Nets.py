#!/usr/bin/env python3

"""
plots a network of the QMEE partner institutes
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import networkx as nx
import pandas as pd
import scipy as sc
import matplotlib.pyplot as plt

# read in the data as pandas dataframe
links = pd.read_csv("../Data/QMEE_Net_Mat_edges.csv")
nodes = pd.read_csv("../Data/QMEE_Net_Mat_nodes.csv")

# have a look
# print(links)
# print(nodes)

################################################################################
# sorting out links
################################################################################

# rows and columns with no 0 i.e. nodes to be linked!!
rows, cols = sc.where(links > 0)

# empty lists
source = []
target = []
weight = []

# tmp matrix so you can reference and pull out weights!
tmp = pd.DataFrame.as_matrix(links)

# append lists with relevant info
for i in range(0, len(cols)):
    source.append(links.columns[cols[i]])
    target.append(links.columns[rows[i]])
    weight.append(tmp[cols[i]][rows[i]])

# join lists to dataframe
df = pd.DataFrame({'source': source, 'target': target, 'weight': weight})
# print(df)

# initialise G (the graph)
G = nx.Graph()

# add edges from df ***this is where it gets weired with the weights***
# when you add edges they are in G in a weired order!!
for i in range(0, len(df)):
    G.add_edge(df['source'][i], df['target'][i], width=df['weight'][i])

# it would be great to be able to pull out the weights from this!!!
edges = G.edges(data=True)

# instead im doing it manually
widths = [28, 6, 70, 76, 10, 12, 5, 9, 2]  # last resort!
widths1 = [x / 5 for x in widths]  # scale widths so it looks ok


################################################################################
# sorting nodes
################################################################################

# add nodes
G.add_nodes_from(nodes.id)

# initialise empty list for colours
colour_map = []

# iterate through G and appened the appropriate colour to colour_map
# the nodes are in a weird order for G
for i in G:
    if nodes.Type[sc.where(nodes.id == i)[0][0]] == 'University':
        colour_map.append('green')
    elif nodes.Type[sc.where(nodes.id == i)[0][0]] == 'Hosting Partner':
        colour_map.append('red')
    else:
        colour_map.append('blue')


################################################################################
# drawing it
################################################################################

# pos: something about the spacing of the nodes
pos = nx.spring_layout(G, iterations=50)

# draw G - fiddled with until it looked good
nx.draw(G, node_color=colour_map, with_labels=True, width=widths1,
        node_size=3000)
plt.draw()
# plt.legend(nodes.Type)  # still need to sort out legend!!
plt.show()
