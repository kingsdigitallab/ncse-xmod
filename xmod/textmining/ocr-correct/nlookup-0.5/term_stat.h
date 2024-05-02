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
#ifndef TERM_STAT_H
#define TERM_STAT_H

#include <string>
#include <iostream>

/*
 * class term_stat
 *
 * Holds one term (string) that looks "similar" to the keyword
 * being searched for. Together with the string itself, it stores
 * ranking-related information: the distance from the keyword we
 * are after, the number of occurrences of the actual term,
 *  and an integer representing its rank.
 */
class term_stat
{
    public:
        term_stat(std::string term, int dist, int count=1, int rank=0);
        ~term_stat();

        // Ordering by rank (highter rank comes before lower rank)
        // ts1 < ts2 iff ts1.rank>=ts2.rank
        bool operator<(const term_stat &ts) const { return _rank>=ts._rank; }

        // Outputing in a stream
        friend std::ostream &operator<<(std::ostream &os, const term_stat &ts);
        friend std::ostream &operator<<(std::ostream &os, term_stat *pts);

        // The term for which this statistic info is for
        const std::string _term;
        // The actual distance of this term from the pattern being searched for
        const int _dist;
        // The number of times this term has been met
        int _count;
        // The overall rank of the term, in whatever ranking system we use
        int _rank;
};

struct lt_termstat_ptr {
    bool operator()(term_stat *p1, term_stat *p2) const {
        return *p1<*p2;
    }
};

#endif // TERM_STAT_H
