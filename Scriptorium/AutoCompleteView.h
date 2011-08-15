//
//  AutoCompleteView.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sat Jan 11 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <AppKit/AppKit.h>

@class AutoCompleteController;

@interface AutoCompleteView : NSView {
    AutoCompleteController *controller;
    
    NSMatrix *upperMatrix;
    NSMatrix *lowerMatrix;

    NSRect lowerFrame;
    NSRect upperFrame;

    NSImageView *upArrowView;
    NSImageView *downArrowView;

    BOOL showUpper;
    BOOL showLower;

    NSArray *completionArray;
    NSColor *backgroundColor;
    NSDictionary *textAttributes;
    NSPoint completionPoint;
    float cpDelta;
}
- (NSBezierPath*)backgroundPathForRect:(NSRect)aRect isUpper:(BOOL)flag;
- (void)setBackgroundColor:(NSColor*)aColor;
- (void)setTextAttributes:(NSDictionary*)attributes;
- (void)setCompletionArray:(NSArray*)anArray;
- (void)setCompletionPoint:(NSPoint)aPoint;
- (void)setCompletionIndex:(int)index;
- (void)setController:(AutoCompleteController*)aController;
@end
