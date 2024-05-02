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
#include "corpus.h"
#include <fstream>
#include <iostream>
using namespace std;


corpus::corpus(string filename, bool casesensitive)
        : _filename(filename),
          _casesensitive(casesensitive)
{
    ifstream in(filename.c_str());
    if (!in) {
        cerr << "Error opening file " << filename
             << ". Corpus is empty!" << endl;
        return;
    }

    if (_casesensitive) {
        string line;
        while (getline(in,line)) {
            _v.insert(_v.end(),line);
        }
    } else {
        string line;
        while (getline(in,line)) {
            line[0] = tolower(static_cast<unsigned char>(line[0]));
            _v.insert(_v.end(),line);
        }
    }
}

corpus::~corpus()
{
}

bool corpus::valid(std::string s) const
{
    return ( _v.find(s)!=_v.end() );
}

