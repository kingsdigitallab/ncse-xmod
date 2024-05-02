
from string import Template
import sys


# string formatting

a = "abc"
b = "def"
c = "ghi"
d = "jkl"

# method 1

x = "xxx %s xxx %s xxx %s xxx %s xxx" % (a, b, c, d)


# method 2

y = "xxx %(eins)s xxx %(zwei)s xxx %(drei)s xxx %(vier)s xxx" % { "eins" : a, "zwei" : b, "drei" : c, "vier" : d }

abc = {
       "eins" : a,
       "zwei" : b,
       "drei" : c,
       "vier" : d
       }


z = "xxx %(eins)s xxx %(zwei)s xxx %(drei)s xxx %(vier)s xxx" % abc

# method 3

t = "xxx $eins xxx $zwei xxx $drei xxx $vier xxx"
s = Template(t)
r = s.substitute(abc)

print x
print y
print z
print r

print >>sys.stderr, r

