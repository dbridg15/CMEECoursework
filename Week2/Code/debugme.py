import pdb


def createabug(x):
    y = x**4
    z = 0.
    pdb.set_trace()  # BREAKPOINT!
    y = y/z
    return y


createabug(25)
