#!/usr/bin/env python3

"""
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import networkx as nx
import pandas
import scipy as sc
import matplotlib.pyplot as plt


links = pandas.read_csv("../Data/QMEE_Net_Mat_edges.csv", header = 0)
nodes = pandas.read_csv("../Data/QMEE_Net_Mat_nodes.csv", header = 0)


rows, cols = sc.where(links>0)
links = zip(rows.tolist(), cols.tolist())
print(links)


#print(links)
print(nodes)
#G = nx.Graph()

#for i in range(0, len(a)):
#    G.add_node(a[i])

#nx.draw(G, with_labels = True)
#plt.draw()
#plt.show()
