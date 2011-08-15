//
//  XMLTextView.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Dec 22 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AutoCompleteController, XMLTextViewController, XMLTextStorage, XMLLayoutManager;

@interface XMLTextView : NSTextView {

    IBOutlet XMLTextViewController *controller;
    AutoCompleteController *autoCompleteController;

    XMLTextStorage *xmlTextStorage;
    XMLLayoutManager *xmlLayoutManager;
}
- (NSRect)boundingRectForCharacterRange:(NSRange)aRange;
- (void)insertNewNode:(id)sender;
- (void)insertNewEntity:(id)sender;
@end
