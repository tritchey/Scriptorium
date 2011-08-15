/*
 *  coreDump.c
 *  Scriptorium
 *
 *  Created by Timothy Ritchey on Sun Feb 16 2003.
 *  Copyright (c) 2003 Red Rome Logic. All rights reserved.
 *
 */

#include "coreDump.h"
#import <sys/types.h>
#import <sys/time.h>
#import <sys/resource.h>
#include <stdio.h>
#include <errno.h>

void enableCoreDumps ()
{
    struct rlimit rl;

    rl.rlim_cur = RLIM_INFINITY;
    rl.rlim_max = RLIM_INFINITY;

    if (setrlimit (RLIMIT_CORE, &rl) == -1) {
        fprintf (stderr,
                 "error in setrlimit for RLIMIT_CORE: %d (%s)\n",
                 errno, strerror(errno));
    }

} // enableCoreDumps
