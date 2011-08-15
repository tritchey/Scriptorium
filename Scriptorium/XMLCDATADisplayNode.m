//
//  XMLCDATADisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "XMLCDATADisplayNode.h"
#import "PreferencesController.h"
#import "CDATATagCell.h"

static CDATATagCell *prototypeCDATATagCell;


@implementation XMLCDATADisplayNode

+ (void)initialize
{
    prototypeCDATATagCell = [[CDATATagCell alloc] init];
}

+ (id)prototypeTagCell
{
    return prototypeCDATATagCell;
}

- (NSString*)string
{
    NSMutableString *string = [NSMutableString string];

    if([(XMLCDATA*)xNode content]) {
        [string appendString:[XMLDisplayNode attachmentString]];
        [string appendString:[(XMLCDATA*)xNode content]];
        [string appendString:[XMLDisplayNode attachmentString]];
    } else
        string = nil;

    length = [string length];
    contentRange = NSMakeRange(1, length-2);
    return string;
}

- (NSDictionary*)startTagAttributes
{
    if(!startTagAttributes) {

        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        [attachment setAttachmentCell:[[self class] prototypeTagCell]];

        startTagAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRCDATATagPreferences]];

        [startTagAttributes setObject:attachment forKey:NSAttachmentAttributeName];


        [startTagAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [startTagAttributes setObject:[NSNumber numberWithInt:XML_TAG_START] forKey:RRXMLTagTypeAttributeName];
        [startTagAttributes retain];
        [attachment release];
    }
    return startTagAttributes;
}

- (NSDictionary*)endTagAttributes
{
    NSTextAttachment *attachment;

    if(!endTagAttributes) {
        attachment = [[NSTextAttachment alloc] init];
        [attachment setAttachmentCell:[[self class] prototypeTagCell]];
        endTagAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRCDATATagPreferences]];
        [endTagAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [endTagAttributes setObject:attachment forKey:NSAttachmentAttributeName];
        [endTagAttributes setObject:[NSNumber numberWithInt:XML_TAG_END] forKey:RRXMLTagTypeAttributeName];
        [endTagAttributes retain];
        [attachment release];
    }
    return endTagAttributes;
}

- (NSDictionary*)contentAttributes
{
    if(!contentAttributes) {
        contentAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRCDATAContentPreferences]];
        [contentAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [contentAttributes retain];
    }
    return contentAttributes;
}

@end
