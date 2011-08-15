//
//  XMLTextViewController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 16 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ElementTagCell.h"

@class XMLTextStorage, XMLTextView, XMLDocument, XMLNode, ScriptoriumDocument, ElementTagController;

@interface XMLTextViewController : NSObject {
    IBOutlet ScriptoriumDocument *document;
    IBOutlet XMLTextView *xmlTextView;

    XMLDocument *xmlTree;

    XMLTextStorage *xmlTextStorage;
    ElementTagController *elementTagController;

    // element tag editing bits and pieces
    int editingIndex;    
    NSRange currentNodeRange;

}
- (void)setXMLDocument:(XMLDocument*)aDoc;
- (void)scrollToNode:(XMLNode*)aNode;
- (NSRange)companionTagRangeForRange:(NSRange)aRange;
- (NSArray*)allowedNamesForElementAtIndex:(int)index;
- (XMLTextStorage*)xmlTextStorage;
- (NSRange)rangeForNodeAtIndex:(int)index;
- (NSArray*)copyNodesWithRange:(NSRange)aRange;
- (void)newElementAtIndex:(int)charIndex;
- (void)newEntityAtIndex:(int)charIndex;
- (void)editElementAtIndex:(int)charIndex;
- (void)endEditingElementAtIndex:(int)charIndex;
- (void)setElementAttribute:(NSString*)attributeName
                      value:(NSAttributedString*)value
                    atIndex:(int)charIndex;
- (void)setElementName:(NSString*)aString atIndex:(int)charIndex;
- (void)setElementState:(ElementTagState)state atIndex:(int)charIndex;
- (void)setElementType:(ElementTagType)type atIndex:(int)charIndex;

- (void)writeSelectionToPasteboard:(NSPasteboard*)pb;
- (BOOL)readIntoSelectionFromPasteboard:(NSPasteboard*)pb;
@end
