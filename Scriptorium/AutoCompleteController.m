//
//  AutoCompleteController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sat Jan 11 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "AutoCompleteController.h"
#import "AutoCompleteView.h"

@implementation AutoCompleteWindow
- (NSTimeInterval)animationResizeTime:(NSRect)newFrame
{
    return 0.10;
}
@end


@implementation AutoCompleteController

- (id)init
{
    if(self = [super init]) {
        view = [[AutoCompleteView alloc] initWithFrame:NSMakeRect(0,0,0,0)];
        [view setController:self];
        window = [[AutoCompleteWindow alloc] initWithContentRect:NSMakeRect(0,0,1.0,1.0)
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
        [window setContentView:view];
        [window setBackgroundColor:[NSColor clearColor]];
        [window setAlphaValue:0.85];
        [window setOpaque:NO];
        [window setLevel:NSFloatingWindowLevel];
        [window setHasShadow:YES];
        [window setDelegate:self];
        completing = NO;

    }
    return self;
    
}

- (BOOL)completing
{
    return completing;
}

- (void)setBackgroundColor:(NSColor*)aColor
{
    [view setBackgroundColor:aColor];
}

- (void)setTextAttributes:(NSDictionary*)attributes
{
    [view setTextAttributes:attributes];
}

- (void)setCompletionArray:(NSArray*)anArray
{
    [completionArray release];
    completionArray = [anArray copy];
    [view setCompletionArray:anArray];
    
}

- (NSString*)completionForPrefix:(NSString*)aString
{
    // find the prefix
    NSEnumerator *e = [completionArray objectEnumerator];
    NSString *string;
    int i = 0;

    if([aString isEqual:@""] && [completionArray count]) {
        [self setCompletionIndex:0];
        return [completionArray objectAtIndex:0];
    }
    
    while(string = [e nextObject]) {
        if([string hasPrefix:aString]) {
            [self setCompletionIndex:i];
            return [string substringFromIndex:[aString length]];
        }
        i++;
    }
    return nil;
}

- (void)completeAtPoint:(NSPoint)aPoint inView:(NSView*)aView withCompletionArray:(NSArray*)anArray
{
    completionPoint = [[aView window] convertBaseToScreen:[aView convertPoint:aPoint toView:nil]];
    NSRect frame = {completionPoint, {1,1}};
    [view setCompletionPoint:completionPoint];
    [self setCompletionArray:anArray];
    [window setFrame:frame display:NO animate:NO];
    [window orderFront:self];
    [[aView window] addChildWindow:window ordered:NSWindowAbove];
    completionIndex = -1;
    [view setCompletionIndex:-1];
    completing = YES;
}

- (void)completionFinished
{
    NSWindow *pw = [window parentWindow];
    [window retain];
    [pw removeChildWindow:window];
    [window orderOut:self];
    [self setCompletionArray:nil];
    completing = NO;
}

- (void)setCompletionIndex:(int)index
{
    if(index >= 0 && index < [completionArray count]) {
        completionIndex = index;
        [view setCompletionIndex:index];
    }
}

- (int)completionIndex
{
    return completionIndex;
}

- (NSString*)moveUp:(int)num
{
    [self setCompletionIndex:completionIndex - num];
    return [completionArray objectAtIndex:completionIndex];
}

- (NSString*)moveDown:(int)num
{
    [self setCompletionIndex:completionIndex + num];
    return [completionArray objectAtIndex:completionIndex];
}

- (void)dealloc
{
    [view release];
    [window release];
}


@end
