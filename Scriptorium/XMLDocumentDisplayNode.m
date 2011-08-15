//
//  XMLDocumentDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLDocumentDisplayNode.h"
#import "ElementTagCell.h"

static ElementTagCell *prototypeDocumentTagCell;

@implementation XMLDocumentDisplayNode

+ (void)initialize
{
    prototypeDocumentTagCell = [[ElementTagCell alloc] init];
}

+ (id)prototypeTagCell
{
    return prototypeDocumentTagCell;
}


@end
