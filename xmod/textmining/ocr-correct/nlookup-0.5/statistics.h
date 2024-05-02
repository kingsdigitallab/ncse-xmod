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
#ifndef STATISTICS_H
#define STATISTICS_H

#include <string>
#include <map>
#include <iostream>
#include "term_stat.h"
#include "corpus.h"

// Make our lives easier a bit...
typedef std::map<std::string, term_stat *> PatternContainer_T;

/*
 * class statistics
 *
 * This is essentially a list of all the terms (strings) that
 * have been met so far in the search, which look "similar"
 * to the keyword being searched for.
 * By adding a string, its distance is computed (the first time
 * only), and its count and rank are updated.
 * The ranking method used at this point is simply as follows:
 * Each error counts for -10, and each repeat counts as +1.
 * Starting rank is 10*dist, such that the minimum rank any
 * term can get is 0.
 *
 */
class statistics
{
    public:
        // Associate the statistics with one keyword (the search term)
        // and the maximum distance allowed
        statistics(const std::string &keyword, int dist, const corpus &corp);
        // Destructor
        ~statistics();

        // Adds the pattern in the list (or updates the occurrence,
        // if already in the list) and returns its current rank
        int add(const std::string &pattern, int dist);
        // Returns the rank of a particular pattern
        int rank(const std::string &pattern) const;
        // Returns the count (number of occurrences) of a particular pattern
        int count(const std::string &pattern) const;
        // Returns the number of valid patterns in our list
        int size() const { return _numpat;}
        // Prints the pattern in order of rank
        friend std::ostream &operator<<(std::ostream &os,
                                        const statistics &stat);

    private:
        // The keyword input by the user (the search term)
        const std::string _keyword;
        // The maximum distance allowed
        const int _distance;
        // Holds all the "similar" keywords, the patterns
        PatternContainer_T _patterns;
        // The number of valid patterns in our list
        int _numpat;
        // The corpus containing valid names, here used for ranking purposes
        const corpus &_corp;
};

#endif // STATISTICS_H
