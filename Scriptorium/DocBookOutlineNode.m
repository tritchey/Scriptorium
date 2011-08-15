//
//  DocBookOutlineNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Nov 18 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "DocBookOutlineNode.h"
#import "AttributeController.h"


@implementation DocBookOutlineNode

- (id)initWithXMLDoc:(XMLDoc*)doc attributeController:(AttributeController*)attributeController
{
    NSAttributedString *title;
    XMLNode* child;
    if(self = [super init]) {
        [self setNode:nil];
        [self setName:nil];
        children = [[NSMutableArray alloc] init];
        // now, recursively go through children looking for nodes with titles
        NSEnumerator *e = [[doc children] objectEnumerator];
        while(child = [e nextObject]) {
            if([child type] == XML_ELEMENT_NODE) {
                // search to see if there is a title somewhere
                if(title = [attributeController attributedStringWithNode:child name:@"title"
                                                   defaultAttributes:nil])
                    [children addObject:[[DocBookOutlineNode alloc]
                                               initWithXMLNode:child
                                           attributeController:attributeController]];
            }
        }
    }
    return self;
}

- (id)initWithXMLNode:(XMLNode*)aNode attributeController:(AttributeController*)attributeController
{
    NSAttributedString *title;
    XMLNode* child;
    if(self = [super init]) {
        [self setNode:aNode];
        [self setName:[attributeController attributedStringWithNode:node name:@"title"
                                              defaultAttributes:nil]];
        children = [[NSMutableArray alloc] init];
        // now, recursively go through children looking for nodes with titles
        NSEnumerator *e = [[aNode children] objectEnumerator];
        while(child = [e nextObject]) {
            if([child type] == XML_ELEMENT_NODE) {
                // search to see if there is a title somewhere
                if(title = [attributeController attributedStringWithNode:child name:@"title"
                                                       defaultAttributes:nil])
                    [children addObject:[[DocBookOutlineNode alloc]
                                            initWithXMLNode:child
                                        attributeController:attributeController]];
            }
        }
    }
    return self;
}


@end
