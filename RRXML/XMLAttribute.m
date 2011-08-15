//
//  XMLAttribute.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLAttribute.h"


@implementation XMLAttribute

- (XMLNode*)value
{
    return children;
}


- (xmlAttributeType)attributeType
{
    return atype;
}

@end
