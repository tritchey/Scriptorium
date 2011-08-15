//
//  main.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Nov 13 2002.
//  Copyright (c) 2002 RedRomeLogic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <Foundation/NSDebug.h>
#include <libxml/parser.h>

int main(int argc, const char *argv[])
{
    NSZombieEnabled = YES;
    return NSApplicationMain(argc, argv);
}
