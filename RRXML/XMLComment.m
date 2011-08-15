//
//  XMLComment.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Feb 21 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLComment.h"


@implementation XMLComment

- (void)setContent:(NSString*)aString
{
    xmlNodeSetContent((xmlNodePtr)self, [aString cString]);
}


@end
