//
//  AutoCompleteController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sat Jan 11 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AutoCompleteView;

@interface AutoCompleteWindow : NSWindow {
}
@end

@interface AutoCompleteController : NSObject {
    AutoCompleteWindow *window;
    AutoCompleteView *view;

    NSArray *completionArray;
    NSPoint completionPoint;
    NSDictionary *textAttributes;
    int completionIndex;

    BOOL completing;
    
}
- (BOOL)completing;
- (void)setBackgroundColor:(NSColor*)aColor;
- (void)setTextAttributes:(NSDictionary*)attributes;
- (void)setCompletionArray:(NSArray*)anArray;
- (NSString*)completionForPrefix:(NSString*)aString;
- (void)completeAtPoint:(NSPoint)aPoint inView:(NSView*)aView withCompletionArray:(NSArray*)anArray;
- (void)completionFinished;
- (void)setCompletionIndex:(int)index;
- (int)completionIndex;
- (NSString*)moveUp:(int)num;
- (NSString*)moveDown:(int)num;
@end
