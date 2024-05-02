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
#include "distfunctions.h"
#include <vector>
#include <iterator>
#include <algo.h> // for iota
#include <fstream>
#include <set>
using namespace std;


// The minimum of three integers
int min3( int a, int b, int c);


int localmatch_fast(string pat, string text)
{
    const int m = pat.size();
    const int n = text.size();

    vector<int> *prevcol = new vector<int>(m+1);
    iota(prevcol->begin(), prevcol->end(), 0 );

    vector<int> *curcol = new vector<int>(m+1);

    int min_dist = m;

    // Recurrence
    for ( int j=1; j<=n; j++ ) {
        (*curcol)[0] = 0;
        for ( int i=1; i<=m; i++ ) {
            const int cost = ( pat[i-1]==text[j-1] ? 0 : 1 );

            (*curcol)[i] = min3( (*curcol)[i-1]+1,
                                 (*prevcol)[i]+1,
                                 (*prevcol)[i-1]+cost );
        }

        // Local match, so any value in the last row would do
        if ( (*curcol)[m]<min_dist )
            min_dist = (*curcol)[m];

        // Swap
        vector<int> *tmp = prevcol;
        prevcol = curcol;
        curcol = tmp;
    }

    delete prevcol, curcol;

    return min_dist;
}

int editdistance_fast(string pat, string text)
{
    const int m = pat.size();
    const int n = text.size();

    vector<int> *prevcol = new vector<int>(m+1);
    iota(prevcol->begin(), prevcol->end(), 0 );

    vector<int> *curcol = new vector<int>(m+1);


    // Recurrence
    for ( int j=1; j<=n; j++ ) {
        (*curcol)[0] = j;
        for ( int i=1; i<=m; i++ ) {
            const int cost = ( pat[i-1]==text[j-1] ? 0 : 1 );

            (*curcol)[i] = min3( (*curcol)[i-1]+1,
                                 (*prevcol)[i]+1,
                                 (*prevcol)[i-1]+cost );
        }


        // Swap
        vector<int> *tmp = prevcol;
        prevcol = curcol;
        curcol = tmp;
    }

    int dist = (*prevcol)[m];
    delete prevcol, curcol;

    return dist;
}

int gramcount_dist(std::string pat, std::string text, int ngram)
{
    const int m = pat.size();
    const int n = text.size();

    set<string> pat_ngrams;
    for (int i=0; i<m-ngram; i++)
        pat_ngrams.insert(pat.substr(i,ngram));

    set<string> text_ngrams;
    for (int i=0; i<n-ngram; i++)
        text_ngrams.insert(text.substr(i,ngram));

    set<string> commongrams;
    set_intersection(pat_ngrams.begin(), pat_ngrams.end(),
                     text_ngrams.begin(), text_ngrams.end(),
                     insert_iterator<set<string> >(commongrams, commongrams.begin()));

    return (m-ngram+1)-commongrams.size();
}

bool inwaterloo(string waterloofilename, string s) throw(invalid_argument)
{
    ifstream waterloo(waterloofilename.c_str());
    if (!waterloo)
        throw(invalid_argument("Error opening file "+waterloofilename));

    string line;
    while(getline(waterloo,line)) {
        if (line.find(s)!=string::npos)
            return true;
    }

    return false;
}

int min3( int a, int b, int c) {
    return ( a<b ? ( a<c? a : c ) : ( b<c? b : c ) );
}
