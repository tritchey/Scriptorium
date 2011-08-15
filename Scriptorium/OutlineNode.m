//
//  OutlineNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Nov 17 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "OutlineNode.h"
#import "DocBookOutlineNode.h"
#import "AttributeController.h"

@implementation OutlineNode

- (id)initWithXMLDoc:(XMLDoc*)doc attributeController:(AttributeController*)attributeController
{
    XMLNode *child;
    NSEnumerator *e;
    NSString *dtdString = [doc externalID];
    if([dtdString isEqual:@"-//OASIS//DTD DocBook XML V4.2//EN"])
        self = [[DocBookOutlineNode alloc] initWithXMLDoc:doc attributeController:attributeController];
    else {
        if(self = [super init]) {
            [self setNode:doc];
       //     [self setName:[attributeController attributedStringWithString:[doc name] type:0]];
            children = [[NSMutableArray alloc] init];
            e = [[doc children] objectEnumerator];
            while(child = [e nextObject]) {
                if([child type] == XML_ELEMENT_NODE)
        //            [children addObject:[[OutlineNode alloc] initWithXMLNode:child
          //                                               attributeController:attributeController]];
            }
        }
    }
    return self;
    
}

- (id)initWithXMLNode:(XMLNode*)aNode attributeController:(AttributeController*)attributeController
{
    XMLNode *child;
    NSEnumerator *e;
    if(self = [super init]) {
        [self setNode:aNode];
            name = [[NSAttributedString alloc] initWithString:[node name]];
        children = [[NSMutableArray alloc] init];
        // now, recursively go through children looking for nodes with titles
        e = [[aNode children] objectEnumerator];
        while(child = [e nextObject]) {
            if([child type] == XML_ELEMENT_NODE)
  //              [children addObject:[[OutlineNode alloc] initWithXMLNode:child
    //                                                 attributeController:attributeController]];
        }
    }
    return self;
}

- (XMLNode*)node
{
    return node;
}

- (void)setNode:(XMLNode*)aNode
{
    [node release];
    node = [aNode retain];
}

- (NSAttributedString*)name
{
    return name;
}

- (void)setName:(NSAttributedString*)aString
{
    [name release];
    name = [aString copy];
}

- (BOOL)hasChildren
{
    return [children count];
}

- (NSMutableArray*)children
{
    return children;
}


@end
