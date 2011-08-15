//
//  OutlineController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Nov 21 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "OutlineController.h"
#import "OutlineNode.h"
#import "ScriptoriumViewController.h"


@implementation OutlineController


- (void)awakeFromNib
{
    id cell;
    [outlineView setOutlineTableColumn:[outlineView tableColumnWithIdentifier:@"Outline"]];

    // make the first column use an image cell
    cell = [[NSImageCell alloc] init];
    [[outlineView tableColumnWithIdentifier:@"Icon"] setDataCell:cell];    
}

- (void)setXMLDoc:(XMLDocument*)doc
{    
    [outline release];
//    outline = [[OutlineNode alloc] initWithXMLDoc:doc attributeController:attributeController];
    [outlineView reloadData];
}

// outline view delegate implementation

- (id)outlineView:(NSOutlineView *)outlineView
objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if([[tableColumn identifier] isEqual:@"Icon"])
        return nil;
        
    return [(OutlineNode*)item name];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item hasChildren];
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(!item)
        return [[outline children] count];
    return [[item children] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    if(!item)
        return [[outline children] objectAtIndex:index];
    return [[item children] objectAtIndex:index];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    OutlineNode *outlineNode = [outlineView itemAtRow:[outlineView selectedRow]];
    [viewController scrollToNode:[outlineNode node]];
}

@end
