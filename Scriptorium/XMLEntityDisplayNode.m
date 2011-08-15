//
//  XMLEntityDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "XMLEntityDisplayNode.h"
#import "PreferencesController.h"
#import "EntityTagCell.h"

static EntityTagCell *prototypeEntityTagCell;

@implementation XMLEntityDisplayNode

+ (void)initialize
{
    prototypeEntityTagCell = [[EntityTagCell alloc] init];
}

+ (id)prototypeTagCell
{
    return prototypeEntityTagCell;
}

- (NSString*)string
{
    NSString *s;
    if([xNode name])
        s = [XMLDisplayNode attachmentString];
    else
        s = nil;

    // cache display info
    length = [s length];
    contentRange = NSMakeRange(1,0);
    return s;
}

- (NSDictionary*)startTagAttributes
{
    if(!startTagAttributes) {

        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        [attachment setAttachmentCell:[[self class] prototypeTagCell]];

        startTagAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RREntityTagPreferences]];

        [startTagAttributes setObject:attachment forKey:NSAttachmentAttributeName];


        [startTagAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [startTagAttributes setObject:[NSNumber numberWithInt:XML_TAG_EMPTY] forKey:RRXMLTagTypeAttributeName];
        [startTagAttributes retain];
        [attachment release];
    }
    return startTagAttributes;
}

- (NSDictionary*)endTagAttributes
{
    return nil;
}

- (NSDictionary*)contentAttributes
{
    return nil;
}


@end
