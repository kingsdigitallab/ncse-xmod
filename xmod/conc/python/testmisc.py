#!/usr/bin/env python

import sys
import os
import os.path
import textwrap


t = "Our Our shades meals and and lig those hts, who dress them I I Our Representatives , o 1 nights, ; I God bless 'em! I I The Swift plan an , d so a frequentl few other y and eat successfull writers, of y ado viewing pted b the y Voltai morals re, , I of reli some gion , , fore literature iintellect , and politics gr whether at of home India , throug or Fairy h the -lan medium d, _aud a thus clear obtaining view of gn a men high and ground , things of , migh abstraction t again wherefrom be brought to;tak irjto e ! ta operation inly _produce with a a considerable very startling sensation effect. under The ex any pose _condition would cefc _p£ - social circumstancesbut the benefit obtained might hp more essentially important , at the present time than in any previous h period ensive . The rinci world les. has Discoveries never before in been mental so open _, and to _phjfisic ccmnFpr _&amp; e- l sciences p nave p been hitherto made ..to. no enlarged and allthe embracing disco varies practical to their purpose own advantage * The kings , and and hung priests the phil turned osop and hers generall . But y now understood , if a princi , the ple peop of le general insist good upon be its d adop iscove iiofr red ; and as the main difficulty lies in producing this gejnqral underwere ficiencies standing developed , so of it those would for the individual do purpose great s service of whose showing if exterior"


print t

print textwrap.wrap(t)

print

print textwrap.fill(t)

print

bywrapper = textwrap.TextWrapper(width=50, replace_whitespace=True, break_long_words=False)

print bywrapper.fill(t)




