//
//  ElementTagCell.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Dec 30 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "ElementTagCell.h"
#import "ElementTagView.h"
#import "PreferencesController.h"
#import "ElementTagController.h"
#import "XMLTextViewController.h"
#import "XMLDisplayNode.h"

NSString *RRXMLTagTypeAttributeName = @"XML Tag Type Attribute Name";

@implementation ElementTagCell

+ (ElementTagCell*)elementTagCell
{
    return [[[ElementTagCell alloc] init] autorelease];
}

+ (NSTextView*)elementTagEditor
{
    NSTextView *editor;
    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
    [selectedAttributes setObject:[[NSColor alternateSelectedControlColor]
        blendedColorWithFraction:0.30 ofColor:[NSColor blackColor]]
                           forKey:NSBackgroundColorAttributeName];
    
    editor = [[[NSTextView alloc] initWithFrame:NSMakeRect(0,0,1000,100)] autorelease];

    [editor setFieldEditor:NO];
    [editor setDrawsBackground:NO];
    [editor setHorizontallyResizable:YES];
    [editor setVerticallyResizable:NO];
    [editor setAutoresizingMask:NSViewWidthSizable];
    [editor setSelectedTextAttributes:selectedAttributes];
    [[editor textContainer] setHeightTracksTextView:YES];
    [[editor textContainer] setWidthTracksTextView:NO];


    return editor;
}

- (id)copyWithZone:(NSZone*)zone
{
    id copy = [[[self class] allocWithZone:zone] init];
    [copy setAttachment:attachment];
    return copy;
}

- (void)setAttachment:(NSTextAttachment*)anAttachment
{
    attachment = anAttachment;
}

- (NSTextAttachment*)attachment
{
    return attachment;
}

 - (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
       characterIndex:(unsigned)charIndex
        layoutManager:(NSLayoutManager *)layoutManager
{
    [self drawWithFrame:cellFrame inView:controlView characterIndex:charIndex];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView
       characterIndex:(unsigned)charIndex
{
    NSSize size = cellFrame.size;
    ElementTagState state;
    NSAttributedString *attributedString;
//    [textAttributes removeObjectForKey:NSBackgroundColorAttributeName];

    if([aView respondsToSelector:@selector(textStorage)])
        attributedString = [(id)aView textStorage];

    NSDictionary *textAttributes = [attributedString attributesAtIndex:charIndex
                                                        effectiveRange:nil];
    NSColor *backgroundColor = [textAttributes objectForKey:NSBackgroundColorAttributeName];
    
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
    [[ElementTagCell openBracketPathForRect:cellFrame] stroke];
    [[ElementTagCell closeBracketPathForRect:cellFrame] stroke];
    
    switch(type) {
        case XML_TAG_UNKNOWN:
        case XML_TAG_START:
            cellFrame.origin.x += (size.height/2 + 2);
            cellFrame.size.width -= (size.height + 4);
            break;
        case XML_TAG_END:
            [[ElementTagCell endSlashPathForRect:cellFrame] stroke];
            cellFrame.origin.x += (size.height/2 + size.height*1/3 + 4);
            cellFrame.size.width -= (size.height*4/3 + 6);
            break;
        case XML_TAG_EMPTY:
            [[ElementTagCell emptySlashPathForRect:cellFrame] stroke];
            cellFrame.origin.x += (size.height/2 + 2);
            cellFrame.size.width -= (size.height + 4);
            break;
        default:
            break;
    }

    [name drawInRect:cellFrame withAttributes:textAttributes];
    
    [aView unlockFocus];
 
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView
{
    cellFrame.size = [self cellSize];
    [self drawWithFrame:cellFrame inView:aView characterIndex:0];
}

- (BOOL)wantsToTrackMouseForEvent:(NSEvent *)theEvent
                           inRect:(NSRect)cellFrame
                           ofView:(NSView *)controlView
                 atCharacterIndex:(unsigned)charIndex
{
    return YES;
}

- (BOOL)wantsToTrackMouse
{
    return YES;
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame
            ofView:(NSView *)aTextView atCharacterIndex:(unsigned)charIndex
      untilMouseUp:(BOOL)flag
{
    
    
    if([theEvent clickCount] == 1) {
        // there has been a click in a tag
        // tell the text view to highlight the tag pair
        [(NSTextView*)aTextView setSelectedRange:NSMakeRange(charIndex, 1)];

    } else if([theEvent clickCount] == 2) {
        [[(NSTextView*)aTextView delegate] editElementAtIndex:charIndex];
        
    }

    return YES;
}


- (NSPoint)cellBaselineOffset
{
    int decender = [[[[PreferencesController elementPreferences]
                       objectForKey:RRElementTagPreferences]
                       objectForKey:NSFontAttributeName] descender] - 2;
    return NSMakePoint(0, decender);
}

- (NSRect)cellFrameForTextContainer:(NSTextContainer *)textContainer
               proposedLineFragment:(NSRect)lineFrag
                      glyphPosition:(NSPoint)position
                     characterIndex:(unsigned)charIndex
{
    // get the attributes for the characterIndex
    NSTextStorage *textStorage = [[textContainer textView] textStorage];
    NSDictionary *attributes = [textStorage attributesAtIndex:charIndex effectiveRange:nil];
    ElementTagType type = [[attributes objectForKey:RRXMLTagTypeAttributeName] intValue];
    XMLDisplayNode *displayNode = [attributes objectForKey:RRXMLDisplayNodeAttributeName];
    NSString *name = [[displayNode xmlNode] name];
    NSRect frame = {[self cellBaselineOffset], [self cellSizeForString:name type:type]};
    return frame;
}

- (NSSize)cellSize
{
    // need something else here
    return NSMakeSize(10.0, 10.0);
}


- (NSSize)cellSizeForString:(NSString*)name
                       type:(ElementTagType)tagType
{
    NSMutableDictionary *textAttributes
    = [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences];
    // compute size for name
    if(!name || [name isEqual:@""]) // hack to make sure we have at least SOME size in here
        name = @".";
    NSSize size = [name sizeWithAttributes:textAttributes];
    size.width += size.height + 4;
    if(tagType == XML_TAG_END || tagType == XML_TAG_EMPTY)
        size.width += (size.height*1/3+2);
    return size;
}

/// editing functionality
- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj
             delegate:(id)anObject event:(NSEvent *)theEvent
{
    NSTextView* editor = (NSTextView*)textObj;
    NSAttributedString *attributedString;
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences]];
    NSColor *backgroundColor = [textAttributes objectForKey:NSBackgroundColorAttributeName];
    [textAttributes removeObjectForKey:NSBackgroundColorAttributeName];

    int charIndex = [anObject editingIndex];
    
    if([controlView respondsToSelector:@selector(textStorage)])
        attributedString = [(id)controlView textStorage];

    XMLDisplayNode *displayNode = [attributedString attribute:RRXMLDisplayNodeAttributeName
                                                      atIndex:charIndex
                                               effectiveRange:nil];
    NSString *name = [[displayNode xmlNode] name];

    [[editor textContainer] setContainerSize:NSMakeSize(1e7, aRect.size.height)];
    [editor setTypingAttributes:textAttributes];
    [editor setMaxSize:NSMakeSize(1e7, aRect.size.height)];
    aRect.origin.x += 3;
    [editor setFrame:aRect];
    [editor setDelegate:anObject];
    [editor setBackgroundColor:backgroundColor];
    [editor setInsertionPointColor:
        [textAttributes objectForKey:NSForegroundColorAttributeName]];
    if(name)
        [editor setString:name];
    [controlView addSubview:editor];
    [[controlView window] makeFirstResponder:editor];
}

- (void)endEditing:(NSText*)textObj
{
    [[textObj window] makeFirstResponder:[textObj nextResponder]];
    [textObj setDelegate:nil];
    [textObj removeFromSuperview];
    [textObj setString:@""];    
}



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

+ (NSBezierPath*)openBracketPathForRect:(NSRect)aRect
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    float third = hh/3;
    float thickness = size.height/10;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path setLineWidth:thickness];
    origin.x += hh; origin.y += third;
    [path moveToPoint:origin];
    origin.x -= (hh - third); origin.y += third*2;
    [path lineToPoint:origin];
    origin.x += (hh - third); origin.y += third*2;
    [path lineToPoint:origin];

    return path;
    
}

+ (NSBezierPath*)closeBracketPathForRect:(NSRect)aRect
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    float third = hh/3;
    float thickness = size.height/10;

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:thickness];
    origin.x += (aRect.size.width - hh); origin.y += third;
    [path moveToPoint:origin];
    origin.x += (hh - third); origin.y += third*2;
    [path lineToPoint:origin];
    origin.x -= (hh - third); origin.y += third*2;
    [path lineToPoint:origin];

    return path;
    
}

+ (NSBezierPath*)endSlashPathForRect:(NSRect)aRect
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    float third = hh/3;
    float thickness = size.height/10;

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:thickness];
    origin.x += (hh + 2); origin.y += third;
    [path moveToPoint:origin];
    origin.x += (third*2); origin.y += third*4;
    [path lineToPoint:origin];

    return path;

}

+ (NSBezierPath*)emptySlashPathForRect:(NSRect)aRect
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    float third = hh/3;
    float thickness = size.height/10;

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:thickness];
    origin.x += (aRect.size.width - hh*5/3 - 2); origin.y += third;
    [path moveToPoint:origin];
    origin.x += (third*2); origin.y += third*4;
    [path lineToPoint:origin];

    return path;

}

+ (NSBezierPath*)backgroundPathForRect:(NSRect)aRect withType:(ElementTagType)type
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float hh = size.height/2;
    NSBezierPath *path = [NSBezierPath bezierPath];
    if(type == XML_TAG_START) {
        origin.x += hh;
        [path moveToPoint:origin];
        origin.y += hh;
        [path appendBezierPathWithArcWithCenter:origin radius:hh startAngle:270.0
                                       endAngle:90.0 clockwise:YES];
        origin.x += (size.width - hh); origin.y += hh;
        [path lineToPoint:origin];
        origin.y -= size.height;
        [path lineToPoint:origin];
        [path closePath];
        
    } else if(type == XML_TAG_END) {
        [path moveToPoint:origin];
        origin.y += size.height;
        [path lineToPoint:origin];
        origin.x += (size.width - hh);
        [path lineToPoint:origin];
        origin.y -= hh;
        [path appendBezierPathWithArcWithCenter:origin radius:hh startAngle:90.0
                                       endAngle:270.0 clockwise:YES];
        [path closePath];
    } else if(type = XML_TAG_EMPTY) {
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
        
    }
    return path;
}

- (void)dealloc
{
    [super dealloc];
}

@end