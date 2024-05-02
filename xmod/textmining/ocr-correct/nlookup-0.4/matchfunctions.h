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
#ifndef MATCHFUNCTIONS_H
#define MATCHFUNCTIONS_H

#include <list>


// Scans the whole file and returns the lines that contain at least one
// substring of distance at most d from the pattern
// Uses localmatch_fast
int editdistancefind1(const std::list<std::string> &filenames,
                        std::string s, float d, bool casesensitive=true);

// As above but now instead of scanning the whole line of the file for
// a similar substring, it just compares similar-length substrings of
// each line.
// Uses editdistance_fast
int editdistancefind2(const std::list<std::string> &filenames,
                        std::string s, float d, bool casesensitive=true);

// As above but now editdistancefind2, but using statistic information
// Returns the number of matches
int editdistancefind3(const std::list<std::string> &filenames,
                        std::string s, float d, bool casesensitive=true);


#endif // MATCHFUNCTIONS_H
