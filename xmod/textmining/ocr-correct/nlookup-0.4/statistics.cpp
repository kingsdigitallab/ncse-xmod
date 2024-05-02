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
#include "statistics.h"
#include <iterator>
#include <iomanip>
#include <set>
using namespace std;
#include "distfunctions.h"

#define DISTANCE_WEIGHT 100


statistics::statistics(const string &keyword, int dist, const corpus &corp)
        : _keyword(keyword),
          _distance(dist),
          _numpat(0),
          _corp(corp)
{
}

statistics::~statistics()
{
    // Clean up
    for ( PatternContainer_T::iterator i = _patterns.begin();
                                       i != _patterns.end(); i++ )
    {
        if ( i->second != NULL )
            delete i->second;
    }
}

int statistics::add(const std::string &pattern)
{
    int rank = 0;

    // Look for the pattern in the current list
    PatternContainer_T::iterator p = _patterns.find(pattern);

    // Not in the list?
    if ( p == _patterns.end() ) {

        // Compute its distance
        const int dist = editdistance_fast(_keyword,pattern);

        // Set number of occurrence to one (this is the first occurrence)
        const int count = 1;

        // Compute the rank
        // At this stage the rank is simply 100+count-10*dist
        rank = DISTANCE_WEIGHT*_distance - DISTANCE_WEIGHT*dist + count;

        if ( _corp.valid(pattern) )
            rank += DISTANCE_WEIGHT;

        // Add it in the list
        if ( dist<=_distance ) {
            _patterns[pattern] = new term_stat(pattern,dist,count,rank);
            _numpat++;
        } else {
            _patterns[pattern] = NULL;
        }

    // Has been seen before but its distance
    // was too large and thus it was not saved?
    } else if ( p->second==NULL ) {

        return rank;

    // Is it already there?
    } else {

        // Increase its counter
        p->second->_count++;

        // and update its rank
        rank = ++(p->second->_rank);

    }

    return rank;
}

int statistics::rank(const std::string &pattern) const
{
    PatternContainer_T::const_iterator p = _patterns.find(pattern);
    if ( p != _patterns.end() )
        return p->second->_rank;
    else
        return 0;

}

int statistics::count(const std::string &pattern) const
{
    const PatternContainer_T::const_iterator p = _patterns.find(pattern);
    if ( p != _patterns.end() )
        return p->second->_count;
    else
        return 0;
}

ostream &operator<<(ostream &os, const statistics &stat)
{

    os << left << setw(24) << "Pattern" //<< "\t\t"
       << "Rank" << "\t"
       << "Count" << "\t"
       << "Distance" << endl;

    set<term_stat *,lt_termstat_ptr> v;
    for (PatternContainer_T::const_iterator i=stat._patterns.begin();
            i!=stat._patterns.end(); i++)
    {
        if (i->second!=NULL)
            v.insert(i->second);
    }

    copy(v.begin(), v.end(), ostream_iterator<term_stat *>(cout,"\n"));

    return os;

}
