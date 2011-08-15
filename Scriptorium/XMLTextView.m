//
//  XMLTextView.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Dec 22 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import "XMLTextView.h"
#import "XMLTextViewController.h"
#import "XMLTextStorage.h"
#import "XMLLayoutManager.h"
#import "AutoCompleteController.h"

@implementation XMLTextView

- (id)initWithFrame:(NSRect)aRect textContainer:(NSTextContainer*)aTextContainer
{
    xmlTextStorage = [[XMLTextStorage alloc] init];
    xmlLayoutManager = [[XMLLayoutManager alloc] init];

    [xmlTextStorage addLayoutManager:xmlLayoutManager];
    [xmlLayoutManager addTextContainer:aTextContainer];
    
    if(self = [super initWithFrame:aRect textContainer:aTextContainer]) {
        [self registerForDraggedTypes:
            [NSArray arrayWithObject:NSStringPboardType]];
    } 
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSRect)boundingRectForCharacterRange:(NSRange)aRange
{
    NSLayoutManager *lm = [self layoutManager];
    NSTextContainer *tc = [self textContainer];
    NSRange agRange = [lm glyphRangeForCharacterRange:aRange actualCharacterRange:nil];
    return [lm boundingRectForGlyphRange:agRange inTextContainer:tc];

}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *chars = [theEvent characters];
    if([chars isEqual:@"<"]
       && [[self delegate] textView:self doCommandBySelector:@selector(insertNewNode:)])
        return;
    else if([chars isEqual:@"&"]
            && [[self delegate] textView:self doCommandBySelector:@selector(insertNewEntity:)])
        return;

    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertNewNode:(id)sender
{
}

- (void)insertNewEntity:(id)sender
{
}

- (IBAction)cut:(id)sender
{
    [self copy:sender];
    [self delete:sender];
}

- (IBAction)copy:(id)sender
{
    // yeah! this is going to be sooo much fun.
 //   NSPasteboard *pb = [NSPasteboard generalPasteboard];
//    [controller writeSelectionToPasteboard:pb];

}

- (IBAction)paste:(id)sender
{
 //   NSPasteboard *pb = [NSPasteboard generalPasteboard];
 //   [controller readIntoSelectionFromPasteboard:pb];
}

- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)aPoint
{
  //  NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
 //  [controller writeSelectionToPasteboard:pb];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
  //  NSPasteboard *pb = [sender draggingPasteboard];
//    [controller readIntoSelectionFromPasteboard:pb];
    return YES;
}
@end