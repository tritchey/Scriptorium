//
//  XMLTextStorage.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Feb 16 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

/* NOTE:
Beyond these requirements, if a subclass overrides or adds any methods that change its characters or attributes directly (not using the primitive methods or making extra changes after invoking the primitives), those methods must invoke editedInRangeedited:range:changeInLength: after performing the change in order to keep the change-tracking information up to date. See the description of this method for more information.
*/

#import <RRXML/RRXML.h>
#import "XMLTextStorage.h"
#import "PreferencesController.h"
#import "XMLDisplayNode.h"
#import "XMLDocumentDisplayNode.h"
#import "XMLDisplayString.h"

@implementation XMLTextStorage

+ (id)xmlTextStorage
{
    return [[[XMLTextStorage alloc] init] autorelease];
}

- (void)setXMLDocument:(XMLDocument*)aDoc
{
    int oldLength = [string length];
    [xmlTree autorelease];
    [string autorelease];

    xmlTree = [[XMLDisplayNode displayNodeWithXMLNode:aDoc] retain];
    string = [[XMLDisplayString alloc] initWithXMLTree:xmlTree];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
           range:NSMakeRange(0, oldLength) changeInLength:[string length] - oldLength];

}

- (XMLDisplayNode*)xmlTree
{
    return xmlTree;
}

- (NSString*)string
{
    return string;
}

- (NSDictionary*)attributesAtIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange
{
    if(!aRange) {
        NSRange tmpRange = NSMakeRange(NSNotFound,0);
        aRange = &tmpRange;
    }
    XMLDisplayNode *node = [xmlTree displayNodeForIndex:index effectiveRange:aRange];
    NSDictionary *atts = [node attributesAtIndex:index effectiveRange:aRange];
    return atts;
}

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString
{
    [string replaceCharactersInRange:aRange withString:aString];

    // let the text system know things have changed
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
           range:aRange changeInLength:[aString length] - aRange.length];
    
}

- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange
{
    
}

- (void)invalidateAttributesInRange:(NSRange)range
{
    // do nothing
}

@end
