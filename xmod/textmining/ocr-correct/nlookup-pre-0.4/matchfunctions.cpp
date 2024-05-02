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
#include "matchfunctions.h"
#include "statistics.h"
#include "distfunctions.h"
#include <fstream>
#include <stdexcept>
#include <iterator>
#include <set>
using namespace std;

// Returns the lowercase of a character
char mytolower(char c);


int editdistancefind1(const list<string> &filenames,
                      string s, int d, bool casesensitive)
{
    // Check if the requested is in the list of known names (waterloo names)
    try {
        if ( inwaterloo(WATERLOOFILE,s) )
            cout << s << " occurs in the waterloo-index" << endl;
        else
            cout << s << " doesn't occur in the waterloo-index" << endl;
    } catch (invalid_argument &e) {
        cerr << e.what() << endl;
    }

    list<string> matches;

    for ( list<string>::const_iterator i = filenames.begin();
          i != filenames.end(); i++ )
    {
        ifstream in(i->c_str());
        if (!in)
            throw(invalid_argument("Error opening file "+*i));

        // Process in lines; edit distance *matching* used
        string line;
        while (getline(in,line)) {
            size_t pathpos = line.find('/');
            if ( pathpos==string::npos ) continue;
            string name = line.substr(0,pathpos-1);
            if ( localmatch_fast(s,name)<=d ) {
                cout << line << endl;
                matches.push_back(line);
            }
        }
    }

    // Output matching lines
    copy(matches.begin(), matches.end(), ostream_iterator<string>(cout, "\n") );

    return matches.size();
}

int editdistancefind2(const list<string> &filenames,
                      string s, int d, bool casesensitive)
{
    // Check if the requested is in the list of known names (waterloo names)
    try {
        if ( inwaterloo(WATERLOOFILE,s) )
            cout << s << " occurs in the waterloo-index" << endl;
        else
            cout << s << " doesn't occur in the waterloo-index" << endl;
    } catch (invalid_argument &e) {
        cerr << e.what() << endl;
    }

    set<string> matches;

    for ( list<string>::const_iterator i = filenames.begin();
          i != filenames.end(); i++ )
    {
        ifstream in(i->c_str());
        if (!in)
            throw(invalid_argument("Error opening file "+*i));

        // Process in (space separated) strings; edit distance used
        string str;
        while (in >> str) {
            if ( str[0]=='/' || str.size()>s.size()+d || str.size()<s.size()-d)
                continue;
            if ( matches.find(str) != matches.end() ) {
                ;
            } else if ( editdistance_fast(s,str)<=d ) {
                cout << str << endl;
                matches.insert(str);
            }
        }
    }
    // Output matches
    copy(matches.begin(), matches.end(), ostream_iterator<string>(cout, "\n") );

    return matches.size();
}

int editdistancefind3(const list<string> &filenames,
                      string s, int d, bool casesensitive)
{
    // Ignore case if casesensitive is false.
    // The local copy of s is only destroyed here
    if (!casesensitive)
        transform(s.begin(),s.end(),s.begin(),mytolower);

    // Check if the requested is in the list of known names (waterloo names)
    try {
        if ( inwaterloo(WATERLOOFILE,s) )
            cout << s << " occurs in the waterloo-index" << endl;
        else
            cout << s << " doesn't occur in the waterloo-index" << endl;
    } catch (invalid_argument &e) {
        cerr << e.what() << endl;
    }

    statistics stat(s,d);

    for ( list<string>::const_iterator i = filenames.begin();
          i != filenames.end(); i++ )
    {
        ifstream in(i->c_str());
        if (!in)
            throw(invalid_argument("Error opening file "+*i));

        // Process in (space separated) strings; edit distance used
        string str;
        while (in >> str) {
            if ( str[0]=='/' || str.size()>s.size()+d || str.size()<s.size()-d)
                continue;

            if (!casesensitive)
                transform(str.begin(),str.end(),str.begin(),mytolower);

            stat.add(str);
        }
    }

    cout << stat << endl;

    return stat.size();
}

char mytolower(char c)
{
    return std::tolower(static_cast<unsigned char>(c));
}
