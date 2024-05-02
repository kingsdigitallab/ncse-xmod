/***************************************************************************
 *   Copyright (C) 2004 by Manolis Christodoulakis                         *
 *   manolis@dcs.kcl.ac.uk                                                 *
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
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
#include "timer.h"
#include <iostream>
using std::cerr;
using std::endl;

timer::timer( bool strt )
    : _started( false )
{
    if ( strt ) 
        start();
}
  
void timer::start()
{
    if ( !_started ) {
        _started = true;
        _t1 = clock();
    } else
        cerr << "Timer already started!" << endl;
}

void timer::stop()
{
    if ( !_started ) 
        cerr << "Timer already stopped!" << endl;
    else {
        _started = false;
        _t2 = clock();
    }   
}

long timer::time() const
{
    if ( _started )
        return (long)(clock() - _t1)/(CLOCKS_PER_SEC / (double) 1000.0);
    else        
        return (long)(_t2 - _t1)/(CLOCKS_PER_SEC / (double) 1000.0);
}
