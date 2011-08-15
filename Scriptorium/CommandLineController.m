//
//  CommandLineController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Jan 28 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "CommandLineController.h"


@implementation CommandLineController


- (void)log:(NSString*)aString
{
    // normally we will want to keep this in a circular buffer
    // so that we can display the history of action
    [commandLine setStringValue:aString];
}

@end
