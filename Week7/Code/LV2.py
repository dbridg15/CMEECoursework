#!/usr/bin/env python3

""" The typical Lotka-Volterra Model simulated using scipy with input from the
user and prey density dependance included
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p  # Contains matplotlib for plotting
import sys


# read in the arguments from command line
if len(sys.argv) == 5:
    r = float(sys.argv[1])  # Resource growth rate
    a = float(sys.argv[2])  # Consumer search rate (determines consumption rate)
    z = float(sys.argv[3])  # Consumer mortality rate
    e = float(sys.argv[4])  # Consumer production efficiency
#    print('Four arguments given. \n r = ', str(r), '\n a = ', str(a), '\n z = ',
#          str(z), '\n d = ', str(e))
else:  # use defaults if 4 arguments not given
    r = 1.  # Resource growth rate
    a = 0.1  # Consumer search rate (determines consumption rate)
    z = 1.5  # Consumer mortality rate
    e = 0.75  # Consumer production efficiency
#    print('Incorrect number of arguments given, defaults used \n r = ', str(r),
#          '\n a = ', str(a), '\n z = ', str(z), '\n d = ', str(e))


K = 100  # carrying capacity


def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any
    given time step """

    R = pops[0]
    C = pops[1]
    dRdt = r*R*(1-(R/K)) - a*R*C
    dydt = -z*C + e*a*R*C

    return sc.array([dRdt, dydt])


# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 100,  10000)

x0 = 10
y0 = 5
z0 = sc.array([x0, y0])  # initial conditions: 10 prey and 5 predators p.u.area

pops, infodict = integrate.odeint(dR_dt, z0, t, full_output=True)

infodict['message']     # >>> 'Integration successful.'

prey, predators = pops.T  # What's this for?
f1 = p.figure()  # Open empty figure object
p.plot(t, prey, 'g-', label='Resource density')  # Plot
p.plot(t, predators, 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population')
p.title("Consumer-Resource population dynamics \n r = %s a = %s \
        z = %s e = %s K = %s" % (r, a, z, e, K))
# p.show()  # show the figure
f1.savefig('../Results/prey_and_predators_2.pdf')  # Save figure
