//
//  ElementTagController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 23 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XMLTextViewController, AutoCompleteController, XMLTextView, ElementTagCell;

@interface ElementTagController : NSObject {
    NSString *oldTagString;
    int editingIndex;
    NSTextView *editor;
    NSCell *cell;
    XMLTextViewController *controller;
    AutoCompleteController *autoCompleteController;
}
- (id)initWithXMLTextViewController:(XMLTextViewController*)aController;
- (int)editingIndex;
- (void)editCell:(ElementTagCell*)aCell atIndex:(int)index inTextView:(XMLTextView*)view;
- (void)endEditing;
- (void)cancelEditing;
@end
