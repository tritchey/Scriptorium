//
//  XMLText.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Feb 21 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLText.h"


@implementation XMLText
- (void)setContent:(NSString*)aString
{
    xmlNodeSetContent((xmlNodePtr)self, [aString cString]);
}

@end

@implementation XMLNode (XMLTextOptions)

+ (XMLNode*)xmlTextNodeWithContent:(NSString*)aString
{
    xmlNodePtr node = xmlNewText([aString cString]);
    node->_private = [XMLText class];
    return (XMLNode*)node;
}

@end