//
//  ElementTagView.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 02 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "ElementTagView.h"
#import "ElementTagCell.h"


@implementation ElementTagView

- (id)initWithTextView:(NSTextView*)aTextView characterIndex:(int)charIndex cellClass:(Class)aClass
{
    NSTextStorage *aTextStorage = [(NSTextView*)aTextView textStorage];
    
    return [self initWithAttributedString:
        [aTextStorage attributedSubstringFromRange:NSMakeRange(charIndex, 1)]
                                cellClass:aClass];
}

- (id)initWithAttributedString:(NSAttributedString*)aString cellClass:(Class)aClass
{
    if(self = [super init]) {
        [self setAttributedString:aString];
        elementTagCell = [[aClass alloc] init];
        [self setFrameSize:[elementTagCell cellSize]];
    }
    return self;
}

- (id)initWithFrame:(NSRect)aRect
{
    NSMutableAttributedString *string
    = [[NSAttributedString attributedStringWithAttachment:nil] mutableCopy];
    [string addAttribute:RRXMLTagTypeAttributeName
                   value:[NSNumber numberWithInt:XML_TAG_START]
                   range:NSMakeRange(0, 1)];
    [string autorelease];
    if(self = [super initWithFrame:aRect]) {
        [self setAttributedString:string];
        elementTagCell = [[ElementTagCell alloc] initWithAttributedString:textStorage];
        [self setFrameSize:[elementTagCell cellSize]];
    }
    return self;
}

- (NSAttributedString*)textStorage
{
    return textStorage;
}

- (void)setAttributedString:(NSAttributedString*)aString
{
    [textStorage autorelease];
    textStorage = [aString copy];
    [elementTagCell setAttributedString:textStorage];
    if(elementTagCell)
        [self setFrameSize:[elementTagCell cellSize]];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
    [elementTagCell drawWithFrame:rect inView:self];
}

- (void)dealloc
{
    [elementTagCell release];
    [textStorage release];
    [super dealloc];
}

@end
