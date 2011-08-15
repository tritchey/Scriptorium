//
//  XMLTextDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "XMLTextDisplayNode.h"
#import "PreferencesController.h"


@implementation XMLTextDisplayNode

- (NSString*)string
{
    NSString *c = [(XMLText*)xNode content];
    length = [c length];
    contentRange = NSMakeRange(0, length);
    return c;
}

- (NSDictionary*)startTagAttributes
{
    return [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences];
}

- (NSDictionary*)endTagAttributes
{
    return [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences];
}

- (NSDictionary*)contentAttributes
{
    return [[PreferencesController elementPreferences] objectForKey:RRElementContentPreferences];
}


@end
