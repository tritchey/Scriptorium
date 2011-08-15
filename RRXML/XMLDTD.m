//
//  XMLDTD.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLDTD.h"


@implementation XMLDTD

- (NSString*)externalID
{
    if(ExternalID)
        return [NSString stringWithCString:ExternalID];
    return nil;
}

- (NSString*)systemID
{
    if(SystemID)
        return [NSString stringWithCString:SystemID];
    return nil;
}

- (NSString*)string
{
    // check a flag to see if we want to show dtd
    return [NSString string];
}

@end
