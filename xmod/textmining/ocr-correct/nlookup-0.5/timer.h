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
#ifndef TIMER_H
#define TIMER_H

#include <ctime>


/**
Used for counting elapsed time in milliseconds

@author Manolis Christodoulakis
*/
class timer {
public:
    timer( bool strt = false );
    ~timer() {}

    void start();
    void stop();
    bool started() const { return _started; }

    // If the timer is still running, it returns the time elapsed
    // between the start time and now, in MILLISECONDS.
    // If it's stopped, it returns the time between start-stop
    long time() const;

private:
    clock_t _t1, _t2;
    bool _started;
};

#endif
