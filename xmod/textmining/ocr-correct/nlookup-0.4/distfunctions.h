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
#ifndef DISTFUNCTIONS_H
#define DISTFUNCTIONS_H

#include <string>
#include <stdexcept>

#define WATERLOOFILE "lastnames.txt"


// Locates (one of the min-distance to the pattern) *substring* of the text
int localmatch_fast(std::string pat, std::string text);

// Returns the actual edit distance
int editdistance_fast(std::string pat, std::string text);

// Looks up the string s in the waterloo index.
// Returns true if found, false otherwise.
bool inwaterloo(std::string waterloofilename, std::string s)
    throw(std::invalid_argument);


#endif // DISTFUNCTIONS_H
