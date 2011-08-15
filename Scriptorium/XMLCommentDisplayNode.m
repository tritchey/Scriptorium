//
//  XMLCommentDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Mar 14 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "XMLCommentDisplayNode.h"
#import "PreferencesController.h"
#import "CommentTagCell.h"

static CommentTagCell *prototypeCommentTagCell;

@implementation XMLCommentDisplayNode

+ (void)initialize
{
    prototypeCommentTagCell = [[CommentTagCell alloc] init];
}

+ (id)prototypeTagCell
{
    return prototypeCommentTagCell;
}

- (NSString*)string
{
    NSMutableString *string = [NSMutableString string];
    
    if([(XMLComment*)xNode content]) {
        [string appendString:[XMLDisplayNode attachmentString]];
        [string appendString:[(XMLComment*)xNode content]];
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
            [[PreferencesController elementPreferences] objectForKey:RRCommentTagPreferences]];

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
            [[PreferencesController elementPreferences] objectForKey:RRCommentTagPreferences]];
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
            [[PreferencesController elementPreferences] objectForKey:RRCommentContentPreferences]];
        [contentAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [contentAttributes retain];
    }
    return contentAttributes;
}


@end
