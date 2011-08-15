//
//  EntityTagCell.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Apr 17 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//
#import <RRXML/RRXML.h>
#import "EntityTagCell.h"
#import "ElementTagView.h"
#import "PreferencesController.h"
#import "ElementTagController.h"
#import "XMLTextViewController.h"
#import "XMLDisplayNode.h"


@implementation EntityTagCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView
       characterIndex:(unsigned)charIndex
{
    NSSize size = cellFrame.size;
    NSString *string;
    ElementTagState state;
    NSAttributedString *attributedString;
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [[PreferencesController elementPreferences] objectForKey:RREntityTagPreferences]];
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
    [[ElementTagCell backgroundPathForRect:cellFrame] fill];

    [[textAttributes objectForKey:NSForegroundColorAttributeName] set];

    cellFrame.origin.x += cellFrame.size.height/4;
    cellFrame.size.width -= cellFrame.size.height/4;

    string = @"&";
    [string drawInRect:cellFrame withAttributes:textAttributes];
    size = [string sizeWithAttributes:textAttributes];
    cellFrame.origin.x += size.width;
    cellFrame.size.width -= size.width;

    NSDictionary *atts;

    [name drawInRect:cellFrame withAttributes:textAttributes];

    size = [name sizeWithAttributes:textAttributes];
    cellFrame.origin.x += size.width;
    cellFrame.size.width -= size.width;

    string = @";";
    [string drawInRect:cellFrame withAttributes:textAttributes];


    [aView unlockFocus];
}

- (NSSize)cellSizeForString:(NSString*)name type:(ElementTagType)tagType
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences]];
    NSString *string;
    // compute size for name
    if(!name || [name isEqual:@""]) // hack to make sure we have at least SOME size in here
        name = @".";
    NSSize size = [name sizeWithAttributes:textAttributes];
    string = @"&";
    size.width += [string sizeWithAttributes:textAttributes].width;
    string = @";";
    size.width += [string sizeWithAttributes:textAttributes].width;
    size.width += size.height/2;
    return size;
}

@end

