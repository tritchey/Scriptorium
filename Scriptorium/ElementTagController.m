//
//  ElementTagController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 23 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "ElementTagController.h"
#import "XMLTextViewController.h"
#import "XMLTextView.h"
#import "ElementTagCell.h"
#import "AutoCompleteController.h"

@implementation ElementTagController

- (id)initWithXMLTextViewController:(XMLTextViewController*)aController
{
    if(self = [super init]) {
        controller = aController;
        autoCompleteController = [[AutoCompleteController alloc] init];
    }
    return self;
}

- (int)editingIndex
{
    return editingIndex;
}

- (void)editCell:(ElementTagCell*)aCell atIndex:(int)index inTextView:(XMLTextView*)view
{


    NSRange range = NSMakeRange(index, 1);
    editingIndex = index;
    editor = (NSTextView*)[[view window] fieldEditor:YES forObject:aCell];

    // set up the editor like we want it.
    
    cell = aCell;
    
    NSRect rect = [view boundingRectForCharacterRange:range];
    [cell editWithFrame:rect
                 inView:view
                 editor:editor
               delegate:self
                  event:[[view window] currentEvent]];    
    
    [autoCompleteController setTextAttributes:[aCell textAttributes]];
    [autoCompleteController setBackgroundColor:[NSColor alternateSelectedControlColor]];
    [autoCompleteController completeAtPoint:[editor frame].origin inView:view
                        withCompletionArray:[controller allowedNamesForElementAtIndex:index]];
    
    
}


- (void)endEditing
{        
    [[NSRunLoop currentRunLoop] performSelector:@selector(endEditing:)
                                         target:cell
                                       argument:editor
                                          order:1
                                          modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    
}

- (void)cancelEditing
{

}

// the elementTagEditor delegate that tells us we need to change
// the size of our underlying elementTagCell

- (BOOL)textView:(NSTextView *)aTextView
shouldChangeTextInRange:(NSRange)affectedCharRange 
replacementString:(NSString *)replacementString
{
    NSMutableString *string = [[[aTextView string] mutableCopy] autorelease];

    // see if we are just completing an already found item
    NSString *original = [string substringWithRange:affectedCharRange];
    if([original hasPrefix:replacementString]) {
        // no need to change the text, just move selection
        affectedCharRange.location += [replacementString length];
        affectedCharRange.length -= [replacementString length];
        [aTextView setSelectedRange:affectedCharRange];
        return NO;
    }

    // see if we are trying to close out the tag
    if([replacementString isEqual:@"\\"]) {
        // empty tag
        [self endEditing];
        [controller setElementType:XML_TAG_EMPTY atIndex:editingIndex];
        return NO;
    } else if([replacementString isEqual:@">"]) {
        // close tag
        [self endEditing];
        [controller setElementType:XML_TAG_START atIndex:editingIndex];
        return NO;
    } else if([replacementString isEqual:@" "]) {
        NSLog(@"we are going to start editing attributes here");
        return NO;
    }


    
    if([replacementString isEqual:@"["] && affectedCharRange.location == 0) {
        [controller setElementName:@"[CDATA[" atIndex:editingIndex];
        [self endEditing];
        return NO;
    } else if([replacementString isEqual:@"!"]  && affectedCharRange.location == 0) {
        [controller setElementName:@"!--" atIndex:editingIndex];
        [self endEditing];
        return NO;
    }

    //make the replacement
    if(![autoCompleteController completing])
        [autoCompleteController completeAtPoint:[editor frame].origin inView:aTextView
                            withCompletionArray:
            [controller allowedNamesForElementAtIndex:editingIndex]];
    
    
    [string replaceCharactersInRange:affectedCharRange withString:replacementString];
    NSString *completion = [autoCompleteController completionForPrefix:string];
    if(completion) {
        affectedCharRange = NSMakeRange([string length], [completion length]);
        [string appendString:completion];
        [aTextView setString:string];
        [aTextView setSelectedRange:affectedCharRange];
        [controller setElementName:string atIndex:editingIndex];
        [controller setElementState:RRElementTagEditing atIndex:editingIndex];
        return NO;
    }
    [controller setElementState:RRElementTagError atIndex:editingIndex];
    [controller setElementName:string atIndex:editingIndex];
    return YES;
}

// note: this method are ONLY for the element/entity/etc. tag editors, not
// the xmltextview itself


- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [autoCompleteController completionFinished];
    [controller endEditingElementAtIndex:editingIndex];
    editingIndex = -1;
}



- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{
/*
 NSString *completion;
    NSTextStorage *ts = [controller xmlTextStorage];
    if(aSelector == @selector(moveUp:)) {
        completion = [autoCompleteController moveUp:1];
    } else if(aSelector == @selector(moveDown:)) {
        completion = [autoCompleteController moveDown:1];
    } else if(aSelector == @selector(deleteBackward:)) {
        NSRange r = [aTextView selectedRange];
        if(r.length < 1) {
            // remove the tag at this point
            return NO;
        }
        NSString *s = [[aTextView string]substringToIndex:r.location];
        [aTextView setString:s];
        r = NSMakeRange(editingIndex, 1);
        [ts addAttribute:RRElementTagNameAttributeName
                                   value:s
                                   range:r];
        return YES;
    } else if(aSelector == @selector(insertTab:)) {
        [controller setElementType:XML_TAG_START atIndex:editingIndex];
        [self endEditing];
        return NO;
    } else if(aSelector == @selector(insertNewline:)) {
        return YES;
    } else if(aSelector == @selector(cancel:)) {
        [self cancelEditing];
        return NO;
    } else {
        return NO;
    }

    [aTextView setString:completion];
    [controller setElementName:completion atIndex:editingIndex];
    NSRange range = NSMakeRange(editingIndex, 1);
    [ts addAttribute:RRElementTagStateAttributeName
                               value:[NSNumber numberWithInt:RRElementTagEditing]
                               range:range];

    [ts addAttribute:RRElementTagNameAttributeName
                               value:completion
                               range:range];
    [aTextView setSelectedRange:NSMakeRange(0,[completion length])];
*/    return YES;

}

@end
