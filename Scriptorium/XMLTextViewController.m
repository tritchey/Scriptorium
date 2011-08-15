//
//  XMLTextViewController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 16 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "XMLTextViewController.h"
#import "XMLTextView.h"
#import "XMLDisplayNode.h"
#import "XMLTextStorage.h"
#import "ScriptoriumDocument.h"

@implementation XMLTextViewController

- (id)init
{
    if(self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [xmlTree release];
    [super dealloc];
}

- (void)setXMLDocument:(XMLDocument*)aDoc
{
    [xmlTree autorelease];
    xmlTree = [aDoc retain];
    xmlTextStorage = (XMLTextStorage*)[xmlTextView textStorage];

    [xmlTextStorage setXMLDocument:xmlTree];
    
    [xmlTextView setSelectedRange:NSMakeRange(0,0)];
}

- (void)scrollToNode:(XMLNode*)aNode
{
    int index = 0;
    [xmlTextView scrollRangeToVisible:NSMakeRange(index,1)];

}

- (XMLTextStorage*)xmlTextStorage
{
    return xmlTextStorage;
}

- (NSArray*)allowedNamesForElementAtIndex:(int)index
{
    NSArray *array;
    XMLDisplayNode *displayNode = [[xmlTextView textStorage] attribute:RRXMLDisplayNodeAttributeName
                                                               atIndex:index
                                                        effectiveRange:nil];
    XMLNode *aNode = [displayNode xmlNode];
    array = [[aNode parent] potentialChildren];
    return [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/*
- (NSRange)rangeForNodeAtIndex:(int)index
{

    NSRange effectiveRange;
    XMLNode *node, *aNode;
    ElementTagType type;

    aNode = [xmlTextStorage attribute:RRXMLNodeAttributeName
                              atIndex:index
                longestEffectiveRange:&effectiveRange
                              inRange:NSMakeRange(0,[xmlTextStorage length])];

    // depending on the type of node, we should know where to go
    // if it is a text node, we are dealing with a contiguous attribute
    int nodeType = [aNode type];
    if(nodeType == XML_TEXT_NODE
       || nodeType == XML_COMMENT_NODE
       || nodeType == XML_CDATA_SECTION_NODE)
        return effectiveRange;

    type = [[[xmlTextView textStorage] attribute:RRElementTagTypeAttributeName
                                         atIndex:effectiveRange.location
                                  effectiveRange:nil] intValue];

    int i = effectiveRange.location;
    int stop = [xmlTextStorage length];
    switch(type) {
        case XML_TAG_START:
            // search forward for the end
            i++;
            while(node != aNode && i < stop) {
                node = [xmlTextStorage attribute:RRXMLNodeAttributeName
                                         atIndex:i
                           longestEffectiveRange:&effectiveRange
                                         inRange:NSMakeRange(0,[xmlTextStorage length])];
                i = NSMaxRange(effectiveRange);
            }
                if(i < stop)
                    return NSMakeRange(effectiveRange.location, i - effectiveRange.location);
                break;
        case XML_TAG_END:
            // search backwards for the beginning
            while(node != aNode && i > -1) {
                i--;
                node = [xmlTextStorage attribute:RRXMLNodeAttributeName
                                         atIndex:i
                           longestEffectiveRange:&effectiveRange
                                         inRange:NSMakeRange(0,[xmlTextStorage length])];
                i = effectiveRange.location;
            }
            if(i > -1)
                return NSMakeRange(i, effectiveRange.location - i);
            break;
        case XML_TAG_EMPTY:
            return NSMakeRange(index, 1);
            break;
        default:
            break;
    }
     
    return NSMakeRange(NSNotFound,0);
}

*/
/*
 
- (NSArray*)copyNodesWithRange:(NSRange)aRange
{
    NSMutableArray *nodes = [NSMutableArray array];
    XMLNode *node;
    NSRange effectiveRange = aRange;

    while(effectiveRange.location < NSMaxRange(aRange)) {
        node = [xmlTextStorage attribute:RRXMLNodeAttributeName
                                 atIndex:effectiveRange.location
                          effectiveRange:nil];

        effectiveRange = [self rangeForNodeAtIndex:effectiveRange.location];
        int type = [node type];

        if(NSEqualRanges(effectiveRange, aRange)
           && (type == XML_CDATA_SECTION_NODE || type == XML_COMMENT_NODE)) {
            [nodes addObject:[node copy]];
        } else if(type == XML_TEXT_NODE
                  || type == XML_CDATA_SECTION_NODE
                  || type == XML_COMMENT_NODE) {

            // ignore the end-tags for comments and cdata
            if(type == XML_CDATA_SECTION_NODE || type == XML_COMMENT_NODE) {
                effectiveRange.location += 1;
                effectiveRange.length -= 2;
            }
            // prune the text node based on the intersection with aRange
            node = [node copy];
            NSString *content;
            NSRange range = NSIntersectionRange(effectiveRange, aRange);
            range.location = range.location - effectiveRange.location;
            content = [[node content] substringWithRange:range];
            [node setContent:content];
            [nodes addObject:node];
            [node release];
        } else if(effectiveRange.length <= aRange.length) {
            [nodes addObject:[node copy]];
        } else {
            return nil;
        }

        effectiveRange.location = NSMaxRange(effectiveRange);
        effectiveRange.length = NSMaxRange(aRange) - effectiveRange.location;
    }

    return nodes;
}

*/



/*
- (void)newElementAtIndex:(int)charIndex
{
    editingIndex = charIndex;

    int length = [self insertNode:[XMLNode xmlNodeWithName:@""]
                          atIndex:charIndex];
    [xmlTextStorage addAttribute:RRElementTagTypeAttributeName
                           value:[NSNumber numberWithInt:XML_TAG_UNKNOWN]
                           range:NSMakeRange(charIndex,1)];

    [xmlTextView setSelectedRange:NSMakeRange(charIndex + length, 0)];

    [self editElementAtIndex:charIndex];
}

- (void)newEntityAtIndex:(int)charIndex
{

}

- (void)editElementAtIndex:(int)charIndex
{
    NSRange range = NSMakeRange(charIndex, 1);
    NSTextAttachment *attachment = [xmlTextStorage attribute:NSAttachmentAttributeName
                                                     atIndex:range.location
                                              effectiveRange:&range];

    ElementTagCell *etc = (ElementTagCell*)[attachment attachmentCell];

    [xmlTextStorage addAttribute:RRElementTagStateAttributeName
                           value:[NSNumber numberWithInt:RRElementTagEditing]
                           range:NSMakeRange(charIndex,1)];

    [elementTagController editCell:etc atIndex:charIndex
                        inTextView:xmlTextView];


}

- (void)endEditingElementAtIndex:(int)charIndex
{
    NSRange range;
    ElementTagState state = [[xmlTextStorage attribute:RRElementTagStateAttributeName
                                               atIndex:charIndex
                                        effectiveRange:&range] intValue];

    if(state != RRElementTagError) {
        [xmlTextStorage addAttribute:RRElementTagStateAttributeName
                               value:[NSNumber numberWithInt:RRElementTagOff]
                               range:range];
    }

    [xmlTextView setSelectedRange:NSMakeRange(charIndex+1, 0)];
}

- (void)setElementName:(NSString*)aString atIndex:(int)charIndex
{
    // check out the element tag at that index. If it is unknown
    //
    NSRange range;
    XMLNode *node = [xmlTextStorage attribute:RRXMLNodeAttributeName
                                      atIndex:charIndex
                               effectiveRange:&range];

    ElementTagType type = [[xmlTextStorage attribute:RRElementTagTypeAttributeName
                                             atIndex:charIndex
                                      effectiveRange:&range] intValue];

    if(type == XML_TAG_UNKNOWN) {
        if([aString isEqual:@"[CDATA["]) {
            [node setType:XML_CDATA_SECTION_NODE];
            NSAttributedString *as = [attributeController attributedStringWithCDATANode:node];
            [self updateTextStorageInRange:range withAttributedString:as];
            return;

        } else if([aString isEqual:@"!--"]) {
            [node setType:XML_COMMENT_NODE];
            NSAttributedString *as = [attributeController attributedStringWithCommentNode:node];
            [self updateTextStorageInRange:range withAttributedString:as];
            return;

        }
    }



    [xmlTextStorage addAttribute:RRElementTagNameAttributeName
                           value:aString
                           range:NSMakeRange(charIndex, 1)];

    if(type == XML_TAG_START || type == XML_TAG_END) {
        // we need to find the other part of the tag and change it
        range = [self companionTagRangeForRange:range];
        [xmlTextStorage addAttribute:RRElementTagNameAttributeName
                               value:aString
                               range:range];
    }

    [node setName:aString];
}

- (void)setElementState:(ElementTagState)state atIndex:(int)charIndex
{
    [xmlTextStorage addAttribute:RRElementTagStateAttributeName
                           value:[NSNumber numberWithInt:state]
                           range:NSMakeRange(charIndex, 1)];
}

- (void)setElementType:(ElementTagType)type atIndex:(int)charIndex
{
    NSRange range;
    ElementTagType oldType = [[xmlTextStorage attribute:RRElementTagTypeAttributeName
                                                atIndex:charIndex
                                         effectiveRange:&range] intValue];

    XMLNode *node = [xmlTextStorage attribute:RRXMLNodeAttributeName
                                      atIndex:charIndex
                               effectiveRange:&range];

    if((oldType == XML_TAG_UNKNOWN || oldType == XML_TAG_EMPTY)
       && type == XML_TAG_START) {
        // add a text node as a child to the node
        [node addChild:[XMLNode xmlTextNodeWithContent:@""]];
        NSAttributedString *as = [attributeController attributedStringWithXMLNode:node];
        [xmlTextStorage beginEditing];
        [xmlTextStorage replaceCharactersInRange:range
                            withAttributedString:as];
        [xmlTextStorage endEditing];
    } else {

        [xmlTextStorage addAttribute:RRElementTagTypeAttributeName
                               value:[NSNumber numberWithInt:type]
                               range:NSMakeRange(charIndex, 1)];
    }
}

- (void)setElementAttribute:(NSString*)attributeName
                      value:(NSAttributedString*)value
                    atIndex:(int)charIndex
{


}

- (void)writeSelectionToPasteboard:(NSPasteboard*)pb
{
    NSArray *nodeArray = [self copyNodesWithRange:[xmlTextView selectedRange]];
    [pb declareTypes:
        [NSArray arrayWithObjects:NSStringPboardType, nil]
               owner:self];

    // first, provide a string version of the selection
    [pb setString:[attributeController stringForNodes:nodeArray] forType:NSStringPboardType];

}

- (BOOL)readIntoSelectionFromPasteboard:(NSPasteboard*)pb
{
    NSString* type = [pb availableTypeFromArray:
        [NSArray arrayWithObject:NSStringPboardType]];
    NSString *string;
    NSRange range = [xmlTextView selectedRange];
    NSArray* nodes;

    if(type) {

        string = [pb stringForType:NSStringPboardType];
        // now, parse the string, and insert it into the selection
        nodes = [xmlTree nodesForString:string];
        if(!nodes)
            return NO;

        if(range.length)
            [self pruneTreeWithRange:range];

        [self insertNodes:nodes atIndex:range.location];
        return YES;

    }
    return NO;
}
*/

// delegate functions for XMLTextView

- (BOOL)textView:(NSTextView *)aTextView
shouldChangeTextInRange:(NSRange)affectedCharRange 
replacementString:(NSString *)replacementString
{
    return YES;
}
// make sure that the user is selecting chunks of the tree that can be edited.
- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange
{

    int lastSelectionIndex = NSMaxRange(newSelectedCharRange) - 1;
    NSRange effectiveRange;
    NSRange unionRange = newSelectedCharRange;

    if(newSelectedCharRange.length == 0)
        return newSelectedCharRange;

    int index = newSelectedCharRange.location;
    XMLDisplayNode *node;
    XMLDisplayNode *documentDisplayNode = [xmlTextStorage xmlTree];
    while(index <= lastSelectionIndex) {
        node = [documentDisplayNode displayNodeForIndex:index
                                         effectiveRange:&effectiveRange];
        
        if(!NSLocationInRange(index - effectiveRange.location, [node relativeContentRange])) {
            // the index is in one of the tag ends, so
            // we need to select the entire node
            unionRange = NSUnionRange(unionRange,effectiveRange);
        }
        index = NSMaxRange(effectiveRange);
    }

    return unionRange;
    
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{

 XMLNode *node;
    NSRange range;
    

 if(aSelector == @selector(insertTab:)) {

    } else if(aSelector == @selector(insertNewNode:)) {
        range = [xmlTextView selectedRange];
        node = [self textNodeForIndex:range.location effectiveRange:nil];
        if([node type] == XML_TEXT_NODE) {
            if(range.length)
                [self pruneTreeWithRange:range];
            [self newElementAtIndex:range.location];
            return YES;
        }
        return NO;
    } else if(aSelector == @selector(insertNewEntity:)) {
        range = [xmlTextView selectedRange];
        node = [self textNodeForIndex:range.location effectiveRange:nil];
        if([node type] == XML_TEXT_NODE) {
            if(range.length)
                [self pruneTreeWithRange:range];
            [self newEntityAtIndex:range.location];
            return YES;
        }
        return NO;        
    }
 
    return NO;

}

@end
