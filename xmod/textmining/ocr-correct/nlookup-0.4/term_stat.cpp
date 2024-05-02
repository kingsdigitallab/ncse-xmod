/***************************************************************************
    copyright            : (C) 2007 by Manolis Christodoulakis
    email                : m_christodoulakis@yahoo.co.uk
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 ***************************************************************************/
#include "term_stat.h"
#include <iomanip>
using namespace std;

term_stat::term_stat(std::string term, int dist, int count, int rank)
        : _term(term),
          _dist(dist),
          _count(count),
          _rank(rank)
{

}

term_stat::~term_stat()
{
}

ostream &operator<<(ostream &os, const term_stat &ts)
{
    os << left << setw(24) << ts._term //<< "\t"
       << ts._rank << "\t"
       << ts._count << "\t"
       << ts._dist;

    return os;
}

ostream &operator<<(ostream &os, term_stat *pts)
{
    os << *pts;

    return os;
}
