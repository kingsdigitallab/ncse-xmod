#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <iterator>
//#include <tester/tester/timer.h>
#include <algo.h> // for iota
using namespace std;


list<string> editdistancefind(ifstream &in, string s, int d);
int localmatch_fast(string pat, string text);
int min3( int a, int b, int c);


int main(int argc, const char *argv[])
{

    if (argc<4) {
        cerr << " usage: approx-name-match <inputfile> <string> <int>" << endl;
        return 1;
    }

    ifstream in(argv[1]);
    if (!in) {
        cerr << "Unable to open input file " << argv[1] << endl;
        return 1;
    }

//    timer t; t.start();
    list<string> names = editdistancefind(in,argv[2], atoi(argv[3]));
//    t.stop();

    cout << names.size() << " entries found"
//         << "in " << t.time() << " msec."
         << endl;
//    copy(names.begin(), names.end(), ostream_iterator<string>(cout, "\n") );

	return 0;
}


list<string> editdistancefind(ifstream &in, string s, int d)
{
    list<string> matches;

    // Check if the requested is in the list of known names (waterloo names)
    ifstream waterloo("waterloo-names.txt");
    if (waterloo) {
        string line;
        while(getline(waterloo,line)) {
            if (line.find(s)!=string::npos) {
                cout << "Valid name!" << endl
                     << line << endl << endl;
                // Stop as soon as you find the surname at least once
                break;
            }
        }
    }

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

    return matches;
}


int localmatch_fast(string pat, string text)
{
    const int m = pat.size();
    const int n = text.size();

    vector<int> *prevcol = new vector<int>(m+1);
    iota(prevcol->begin(), prevcol->end(), 0 );

    vector<int> *curcol = new vector<int>(m+1);

    int min_dist = m;

//    vector<int> output(m*n);

    // Recurrence
    for ( int j=1; j<=n; j++ ) {
        (*curcol)[0] = 0;
        for ( int i=1; i<=m; i++ ) {
            const int cost = ( pat[i-1]==text[j-1] ? 0 : 1 );

            (*curcol)[i] = min3( (*curcol)[i-1]+1,
                                 (*prevcol)[i]+1,
                                 (*prevcol)[i-1]+cost );
//            output[(i-1)*n+j-1]=(*curcol)[i];
        }

        // Local match, so any value in the last row would do
        if ( (*curcol)[m]<min_dist )
            min_dist = (*curcol)[m];

        // Swap
        vector<int> *tmp = prevcol;
        prevcol = curcol;
        curcol = tmp;
    }

/*
    cout << "pat:\t" << pat << endl
         << "text:\t" << text
         << endl;
    for (int i=0; i<m*n; i++) {
        if (i%n==0) cout << endl;
        cout << output[i] << " ";
    }
    cout << endl;
    system("pause");
*/
    delete prevcol, curcol;

    return min_dist;
}

int min3( int a, int b, int c) {
    return ( a<b ? ( a<c? a : c ) : ( b<c? b : c ) );
}