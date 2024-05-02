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
#ifndef CORPUS_H
#define CORPUS_H

#include <set>
#include <string>
typedef std::set<std::string> CorpusContainer_T;

/*
 * class corpus
 *
 * Holds a (huge) list of names that are considered valid.
 * Important Assumptions:
 *     1. The input file is expected to be in sorted order. If it is not,
 *        it still works ok, but the creation of the corpus is slow.
 *     2. The names in the file are extected to not contain any spaces
 *        and all have their first - and only their first - letter capital.
 *
 */
class corpus
{
    public:
        corpus(std::string filename, bool casesensitive=true);
        ~corpus();

        bool valid(std::string s) const;

    private:
        // The list of all the names
        CorpusContainer_T _v;
        // The file from which the names are read (unimportant really)
        std::string _filename;
        // Case sensitive/insensitive search
        bool _casesensitive;
};

#endif // CORPUS_H
