//
//  CDATATagCell.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Apr 17 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "CDATATagCell.h"
#import "ElementTagView.h"
#import "PreferencesController.h"
#import "ElementTagController.h"
#import "XMLTextViewController.h"
#import "XMLDisplayNode.h"



@implementation CDATATagCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView
       characterIndex:(unsigned)charIndex
{
    NSString *string;
    ElementTagState state;
    NSAttributedString *attributedString;
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [[PreferencesController elementPreferences] objectForKey:RRCDATATagPreferences]];
    NSColor *backgroundColor = [textAttributes objectForKey:NSBackgroundColorAttributeName];
    [textAttributes removeObjectForKey:NSBackgroundColorAttributeName];
    
    if([aView respondsToSelector:@selector(textStorage)])
        attributedString = [(id)aView textStorage];

    XMLDisplayNode *displayNode = [attributedString attribute:RRXMLDisplayNodeAttributeName
                                                      atIndex:charIndex
                                               effectiveRange:nil];
    XMLNode *node = [displayNode xmlNode];
    NSString *name = [node name];
    ElementTagType type = [[attributedString attribute:RRXMLTagTypeAttributeName
                                               atIndex:charIndex
                                        effectiveRange:nil] intValue];
    [aView lockFocus];

    NSColor *c;
    switch(state) {
        case RRElementTagHovering:
            c = backgroundColor;
            [[c blendedColorWithFraction:0.25 ofColor:[NSColor whiteColor]] set];
            break;
        case RRElementTagEditing:
            [[NSColor alternateSelectedControlColor] set];
            break;
        case RRElementTagError:
            c = [NSColor redColor];
            [[c blendedColorWithFraction:0.30 ofColor:[NSColor whiteColor]] set];
            break;
        default:
            [backgroundColor set];
            break;
    }
    [[ElementTagCell backgroundPathForRect:cellFrame withType:type] fill];

    [[textAttributes objectForKey:NSForegroundColorAttributeName] set];

    switch(type) {
        case XML_TAG_START:
            [[ElementTagCell openBracketPathForRect:cellFrame] stroke];
            cellFrame.origin.x += cellFrame.size.height*3/4;
            cellFrame.size.width -= cellFrame.size.height*3/4;
            string = @"![CDATA[";
            break;
        case XML_TAG_END:
            [[ElementTagCell closeBracketPathForRect:cellFrame] stroke];
            cellFrame.origin.x += cellFrame.size.height*3/8;
            cellFrame.size.width -= cellFrame.size.height*3/8;
            string = @"]]";
            break;
        default:
            string = @"ERROR";
            break;
    }


    [string drawInRect:cellFrame withAttributes:textAttributes];

    [aView unlockFocus];
}

- (NSSize)cellSizeForString:(NSString*)name type:(ElementTagType)tagType
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences]];

    NSString *string;
    NSSize size;
    // compute size for name
    switch(tagType) {
        case XML_TAG_START:
            string = @"![CDATA[";
            size = [string sizeWithAttributes:textAttributes];
            size.width += size.height*5/4;
            break;
        case XML_TAG_END:
            string = @"]]";
            size = [string sizeWithAttributes:textAttributes];
            size.width += size.height;
            break;
        default:
            break;
    }
    return size;
}


@end

