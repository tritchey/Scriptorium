//
//  XMLElementDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "XMLElementDisplayNode.h"
#import "ElementTagCell.h"

static ElementTagCell *prototypeElementTagCell;

@implementation XMLElementDisplayNode

+ (void)initialize
{
    prototypeElementTagCell = [[ElementTagCell alloc] init];
}

+ (id)prototypeTagCell
{
    return prototypeElementTagCell;
}

- (NSString*)string
{
    if(isStringDirty) {
        [cachedString setString:@""];
        XMLDisplayNode* child = children;

        [cachedString appendString:[XMLDisplayNode attachmentString]];
        if(child) {
            while(child) {
                [cachedString appendString:[child string]];
                child = [child next];
            }
            [cachedString appendString:[XMLDisplayNode attachmentString]];
        }

        length = [cachedString length];
        contentRange = NSMakeRange(1,length-2);
        isStringDirty = NO;
    }
    return cachedString;
}

@end
