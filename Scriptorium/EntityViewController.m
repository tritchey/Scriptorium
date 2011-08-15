//
//  EntityViewController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Dec 10 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import "EntityViewController.h"


@implementation EntityViewController

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return 1;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex
{
    if([[aTableColumn identifier] isEqual:@"Icon"])
        return [NSImage imageNamed:@"EntityIcon"];
    return @"test";
}


@end
