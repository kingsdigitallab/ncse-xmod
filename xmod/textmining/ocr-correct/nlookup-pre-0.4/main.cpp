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
#include <iostream>
#include <fstream>
//#include <tester/tester/timer.h>
#include "matchfunctions.h"
using namespace std;

// Prints version information
void version();

// Prints usage information, preceded by the message msg
void usage(const string &msg="");


int main(int argc, const char *argv[])
{
    bool casesensitive=true;
    int algorithm=3;
    int distance=1;
    string name="";
    list<string> files;

    for ( int i=1; i<argc; i++ ) {
        // Which algorithm? 1, 2, or 3
//        if ( strcmp(argv[i],"-a") == 0 && i<argc-1 )
//            algorithm = atoi( argv[++i] );
//        else
        // The name to search for
        if ( strcmp(argv[i],"-n") == 0 && i<argc-1 )
            name = argv[++i];
        // The maximum distance allowed
        else if ( strcmp(argv[i],"-d") == 0 && i<argc-1 )
            distance = atoi( argv[++i] );
        // Case-insensitive search
        else if ( strcmp(argv[i],"-i") == 0 )
            casesensitive = false;
        // Print version and exit
        else if ( strcmp(argv[i],"-V") == 0 )
            version(), exit(0);
        // Print help message and exit
        else if ( strcmp(argv[i],"-h") == 0 )
            usage(), exit(0);
        else if ( strncmp(argv[i],"-",1) == 0 )
            cerr << "Unprocessed option " << argv[i] << endl;
        // Save in the file list (file to be processed)
        else
            files.push_back( argv[i] );
    }

    // Check error conditions

    if ( name=="" ) {
        usage("You must provide a name to search for. Use the -n option.\n");
        exit(0);
    }

    if ( files.empty() ) {
        usage("You must provide at least one file to search into.\n");
        exit(0);
    }


//    timer t; t.start();
    int nummatches = editdistancefind3(files,name,distance,casesensitive);
//    t.stop();

    cout << nummatches << " entries found"
//         << " in " << t.time() << " msec."
         << endl;

	return 0;
}

void version()
{
    cerr << "\nnlookup 0.3\n"
         << "Copyright (C) 2007 by Manolis Christodoulakis\n"
         << "m_christodoulakis@yahoo.co.uk\n";
}

void usage(const string &msg)
{
    if ( msg!="")
        cerr << "Error: " << msg << endl;

    cerr << endl
         << "nlookup is a tool to look for names within files" << endl
         << endl
         << "Usage" << endl
         << "-----" << endl
         << "nlookup  -n <string> " << endl
         << "         [-d <int>]" << endl
         << "         [-i] [-V] [-h]" << endl
         << "         <file1>...<filen>" << endl
         << endl
         << "Options" << endl
         << "-------" << endl
         << "-n <string> : Defines the term (name) to be searched for" << endl
         << "-d <int>    : Defines the maximum distance allowed (defaults to 1)" << endl
         << "-i          : Case-insensitive search" << endl
         << "-V          : Prints version information and exits" << endl
         << "-h          : Prints usage information and exits" << endl
         << "<file1>...<filen> : The files to search into" << endl
         << endl;
}
