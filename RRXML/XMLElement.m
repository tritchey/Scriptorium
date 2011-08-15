//
//  XMLElement.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLElement.h"


@implementation XMLElement

- (NSString*)content
{
    if(content)
        return [NSString stringWithCString:content];
    return nil;
}

- (void)setContent:(NSString*)aString
{
    // do something
}

- (void)replaceContentInRange:(NSRange)aRange withString:(NSString*)aString
{
    // do something
}

- (XMLAttribute*)properties
{
    return properties;
}

@end

@implementation XMLNode (XMLElementOptions)

+ (XMLNode*)xmlElementNodeWithName:(NSString*)aString
{
    xmlNodePtr node = xmlNewNode(NULL, [aString cString]);
    node->_private = [XMLElement class];
    return (XMLNode*)node;
}

@end