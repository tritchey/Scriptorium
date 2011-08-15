//
//  XMLLayoutManager.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Feb 19 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLLayoutManager.h"

@implementation XMLLayoutManager

+ (NSBezierPath*)backgroundPathForRect:(NSRect)aRect
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    NSBezierPath *path = [NSBezierPath bezierPath];
    origin.x += hh;
    [path moveToPoint:origin];
    origin.y += hh;
    [path appendBezierPathWithArcWithCenter:origin radius:hh startAngle:270.0
                                   endAngle:90.0 clockwise:YES];
    origin.x += (size.width - size.height); origin.y += hh;
    [path lineToPoint:origin];
    origin.y -= hh;
    [path appendBezierPathWithArcWithCenter:origin radius:hh startAngle:90.0
                                   endAngle:270.0 clockwise:YES];
    [path closePath];
    return path;
}


- (void)drawTagBackgroundColor:(NSColor*)color
             forCharacterRange:(NSRange)aRange atPoint:(NSPoint)origin
{
    NSRectArray rectangles;
    unsigned rectCount;
    NSRange glyphRange = [self glyphRangeForCharacterRange:aRange
                                      actualCharacterRange:nil];
    NSTextContainer *tc = [self textContainerForGlyphAtIndex:glyphRange.location
                                              effectiveRange:nil];

    rectangles = [self rectArrayForGlyphRange:glyphRange
                     withinSelectedGlyphRange:NSMakeRange(NSNotFound,0)
                              inTextContainer:tc
                                    rectCount:&rectCount];
/*
    while(i < rectCount) {
        rectangles[i].origin.y += 1;
        rectangles[i].size.height -= 2;
        NSBezierPath *path = [XMLLayoutManager backgroundPathForRect:rectangles[i]];
        [color set];
        [path fill];
        i++;
    }
*/    
}




 - (void)drawSelectedBackgroundColor:(NSColor*)color
 forCharacterRange:(NSRange)aRange atPoint:(NSPoint)origin
 {
     NSRectArray rectangles;
     unsigned rectCount, i = 0;
     NSRange glyphRange = [self glyphRangeForCharacterRange:aRange
                                       actualCharacterRange:nil];
     NSTextContainer *tc = [self textContainerForGlyphAtIndex:glyphRange.location
                                               effectiveRange:nil];

     rectangles = [self rectArrayForGlyphRange:glyphRange
                      withinSelectedGlyphRange:glyphRange
                               inTextContainer:tc
                                     rectCount:&rectCount];

     [color set];
     while(i < rectCount) {
         [NSBezierPath fillRect:rectangles[i]];
         i++;
     }
 }

 - (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(NSPoint)origin
 {
     NSRange charRange = [self characterRangeForGlyphRange:glyphsToShow
                                          actualGlyphRange:nil];

     NSRange effectiveRange = {charRange.location,0};
     unsigned charIndex = NSMaxRange(effectiveRange);
     NSDictionary *att;
     NSColor *backgroundColor;

     // let this draw the selection
     [self drawSelectedBackgroundColor:[NSColor selectedTextBackgroundColor]
                     forCharacterRange:[[self textViewForBeginningOfSelection] selectedRange]
                               atPoint:origin];

     // now overlay with the markers
     while(charIndex < NSMaxRange(charRange)) {
         att = [[self textStorage] attributesAtIndex:charIndex
                                      effectiveRange:&effectiveRange];
         if(backgroundColor = [att objectForKey:NSBackgroundColorAttributeName]) {
             [self drawTagBackgroundColor:backgroundColor
                        forCharacterRange:effectiveRange
                                  atPoint:origin];
         }
         charIndex = NSMaxRange(effectiveRange);
     }
 }

@end
