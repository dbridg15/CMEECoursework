#!/usr/bin/env python3

"""Run and profile LV1.py and LV2.py"""

import cProfile
import pstats
import io.StringIO as StringIO

pr = cProfile.Profile()

# LV1.py profiling

pr.enable()
import LV1  # this opens LV1.py
pr.disable()
s = StringIO.StringIO()
ps = pstats.Stats(pr, stream=s)
ps.print_stats(0).sort_stats('calls')  # order by calls
print("Profiling data for LV1.py:")
print(s.getvalue())

# LV2.py profiling

pr.enable()
import LV2
pr.disable()
s = StringIO.StringIO()
ps = pstats.Stats(pr, stream=s)
ps.print_stats(0).sort_stats('calls')  # order by calls
print("Profiling data for LV2.py:")
print(s.getvalue())
