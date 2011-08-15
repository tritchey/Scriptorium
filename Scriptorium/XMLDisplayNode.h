//
//  XMLDisplayNode.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Mar 06 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XMLNode, XMLDocumentDisplayNode, XMLElementDisplayNode, XMLTextDisplayNode,
XMLCDATADisplayNode, XMLCommentDisplayNode, XMLEntityDisplayNode, XMLAttributeDisplayNode;

extern NSString *RRXMLDisplayNodeAttributeName;

@interface XMLDisplayNode : NSObject {

    XMLNode *xNode;
    XMLDisplayNode *children;
    XMLDisplayNode *lastChild;
    XMLDisplayNode *next;
    XMLDisplayNode *previous;
    XMLDisplayNode *parent;


    // display information
    unsigned length;
    NSRange contentRange;
    BOOL showAttributes;
    BOOL collapsedContent;
    
    NSMutableDictionary *startTagAttributes;
    NSMutableDictionary *endTagAttributes;
    NSMutableDictionary *contentAttributes;

    NSMutableString *cachedString;
    BOOL isStringDirty;
}
+ (id)displayNodeWithXMLNode:(XMLNode*)aNode;
+ (id)prototypeTagCell;
+ (NSString*)attachmentString;

- (id)initWithXMLNode:(XMLNode*)aNode;
- (XMLNode*)xmlNode;

- (void)insertXMLNodes:(NSArray*)nodes atIndex:(unsigned)index;
- (int)insertXMLNode:(XMLNode*)aNode atIndex:(unsigned)index;
- (void)insertText:(NSString*)aString atIndex:(unsigned)index;
- (void)pruneTreeWithRange:(NSRange)aRange;
- (void)prune;

- (XMLDisplayNode*)children;
- (void)appendChild:(XMLDisplayNode*)aNode;
- (XMLDisplayNode*)next;
- (void)setNext:(XMLDisplayNode*)aNode;
- (XMLDisplayNode*)previous;
- (void)setPrevious:(XMLDisplayNode*)aNode;
- (XMLDisplayNode*)parent;
- (void)setParent:(XMLDisplayNode*)aNode;

- (void)addNextSibling:(XMLDisplayNode*)sibling;
- (void)addPrevSibling:(XMLDisplayNode*)sibling;
- (void)addChild:(XMLDisplayNode*)child;

- (unsigned)length;
- (void)adjustLength:(int)change;
- (NSString*)string;
- (NSString*)stringForStartTag;
- (NSString*)stringForEndTag;
- (NSString*)stringForEmptyTag;
- (NSRange)absoluteNodeRange;
- (NSRange)relativeStartTagRange;
- (NSRange)relativeContentRange;
- (NSRange)relativeEndTagRange;

- (XMLDisplayNode*)displayNodeForIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange;
- (NSDictionary*)attributesAtIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange;
- (XMLDisplayNode*)textNodeForIndex:(int)index effectiveRange:(NSRangePointer)eRange;

- (NSDictionary*)startTagAttributes;
- (NSDictionary*)endTagAttributes;
- (NSDictionary*)contentAttributes;
@end
