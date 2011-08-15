//
//  XMLDisplayNode.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Mar 06 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "XMLDisplayNode.h"
#import "PreferencesController.h"


#import "XMLDocumentDisplayNode.h"
#import "XMLElementDisplayNode.h"
#import "XMLTextDisplayNode.h"
#import "XMLCDATADisplayNode.h"
#import "XMLCommentDisplayNode.h"
#import "XMLEntityDisplayNode.h"
#import "XMLAttributeDisplayNode.h"
#import "ElementTagCell.h"

NSString *RRXMLDisplayNodeAttributeName = @"XML Display Node Attribute Name";

static NSString *attachmentString;
unichar asc = NSAttachmentCharacter;

@implementation XMLDisplayNode

+ (void)initialize
{
    attachmentString = [[NSString stringWithCharacters:&asc length:1] retain];
}

+ (id)displayNodeWithXMLNode:(XMLNode*)aNode
{
    Class displayClass = nil;

    switch([aNode type]) {
        case XML_ELEMENT_NODE:
            displayClass = [XMLElementDisplayNode class];
            break;
        case XML_TEXT_NODE:
            displayClass = [XMLTextDisplayNode class];
            break;
        case XML_CDATA_SECTION_NODE:
            displayClass = [XMLCDATADisplayNode class];
            break;
        case XML_COMMENT_NODE:
            displayClass = [XMLCommentDisplayNode class];
            break;
        case XML_ATTRIBUTE_NODE:
            displayClass = [XMLAttributeDisplayNode class];
            break;
        case XML_DOCUMENT_NODE:
            displayClass = [XMLDocumentDisplayNode class];
            break;
        case XML_DTD_NODE:
            break;
        case XML_ENTITY_REF_NODE:
            displayClass = [XMLEntityDisplayNode class];
            break;
        case XML_ENTITY_NODE:
        case XML_PI_NODE:
        case XML_DOCUMENT_TYPE_NODE:
        case XML_DOCUMENT_FRAG_NODE:
        case XML_NOTATION_NODE:
        case XML_HTML_DOCUMENT_NODE:
        case XML_ELEMENT_DECL:
        case XML_ATTRIBUTE_DECL:
        case XML_ENTITY_DECL:
        case XML_NAMESPACE_DECL:
        case XML_XINCLUDE_START:
        case XML_XINCLUDE_END:
        default:
            break;
    }

    if(displayClass) {
        return [[[displayClass alloc] initWithXMLNode:aNode] autorelease];
    }
    return nil;
}

+ (id)prototypeTagCell
{
    return nil;
}

+ (NSString*)attachmentString
{
    return attachmentString;
}

- (id)initWithXMLNode:(XMLNode*)aNode;
{
    XMLNode* child;

    if(self = [super init]) {
        xNode = aNode;
        child = [xNode children];
        while(child) {
            [self appendChild:[XMLDisplayNode displayNodeWithXMLNode:child]];
            child = [child next];
        }
        isStringDirty = YES;
        cachedString = [[NSMutableString string] retain];
    }
    return self;
}

- (XMLNode*)xmlNode
{
    return xNode;
}



- (void)insertXMLNodes:(NSArray*)nodes atIndex:(unsigned)index
{
    int type;
    NSString *string;
    XMLNode* aNode;

    NSEnumerator *e = [nodes objectEnumerator];
    while(aNode = [e nextObject]) {
        type = [aNode type];
        if(type == XML_TEXT_NODE) {
            string = [aNode content];
            [self insertText:string atIndex:index];
            index += [string length];
        } else {
            index += [self insertXMLNode:aNode atIndex:index];
        }
    }
}

- (int)insertXMLNode:(XMLNode*)aNode atIndex:(unsigned)index
{
    // get the node at the index
    NSRange effectiveRange, range;
    
    NSString *backString = @"";
    xmlElementType type = [xNode type];

    if(index = NSMaxRange(contentRange)) {
        // we are in the end tag
        [self addChild:[XMLDisplayNode displayNodeWithXMLNode:aNode]];
    } else if(index < contentRange.location) {
        [self addPrevSibling:[XMLDisplayNode displayNodeWithXMLNode:aNode]];
    }

    if(type == XML_TEXT_NODE) {
        NSString *content = [xNode content];
        range.length = index - effectiveRange.location;
        range.location = 0;
        NSString *frontString = [content substringWithRange:range];

        range.location = range.length;
        range.length = [content length] - range.location;
        backString = [content substringWithRange:range];

        // set the clipped content for the text node
        [xNode setContent:frontString];

        // add the new node to the tree, and update the text storage
        [self addNextSibling:[XMLDisplayNode displayNodeWithXMLNode:aNode]];

    } else if((type == XML_COMMENT_NODE && [aNode type] == XML_COMMENT_NODE) ||
              (type == XML_CDATA_SECTION_NODE && [aNode type] == XML_CDATA_SECTION_NODE)) {
        backString = [aNode content];
        [self insertText:backString atIndex:index];
        return [backString length];
    }

    // add the rest of the text as a new text node
    XMLNode *backNode = [XMLNode xmlTextNodeWithContent:backString];
    [self addNextSibling:[XMLDisplayNode displayNodeWithXMLNode:backNode]];
    return length;
}

- (void)addNextSibling:(XMLDisplayNode*)sibling
{
    next->previous = sibling;
    sibling->next = next;
    sibling->previous = self;
    next = sibling;
    [xNode addNextSibling:[sibling xmlNode]];
    isStringDirty = YES;
}

- (void)addPrevSibling:(XMLDisplayNode*)sibling
{
    previous->next = sibling;
    sibling->previous = previous;
    sibling->next = self;
    previous = sibling;
    [xNode addPrevSibling:[sibling xmlNode]];
    isStringDirty = YES;
}

- (void)addChild:(XMLDisplayNode*)child
{
    if(children) {
        [lastChild addNextSibling:child];
        lastChild = child;
    } else {
        children = lastChild = child;
    }
    [xNode addChild:[child xmlNode]];
    isStringDirty = YES;
}

- (void)insertText:(NSString*)aString atIndex:(unsigned)index
{
    NSMutableString *content;
    if(!(content = [[[xNode content] mutableCopy] autorelease]))
        content = [NSMutableString stringWithString:@""];

    [content replaceCharactersInRange:NSMakeRange(index,0) withString:aString];
    [xNode setContent:content];

    [self adjustLength:[aString length]];
}



- (void)pruneTreeWithRange:(NSRange)aRange
{
    XMLDisplayNode *aDisplayNode;
    XMLNode *anXMLNode;
    NSRange effectiveRange = aRange;

    // first, handle the display tree
    while(effectiveRange.location < NSMaxRange(aRange)) {
        aDisplayNode = [self displayNodeForIndex:effectiveRange.location
                                  effectiveRange:&effectiveRange];
        anXMLNode = [aDisplayNode xmlNode];

        int type = [anXMLNode type];

        if(NSEqualRanges(effectiveRange, aRange)
           && (type == XML_CDATA_SECTION_NODE || type == XML_COMMENT_NODE)) {
            [aDisplayNode prune];
        } else if(type == XML_TEXT_NODE
                  || type == XML_CDATA_SECTION_NODE
                  || type == XML_COMMENT_NODE) {

            // ignore the end-tags for comments and cdata
            if(type == XML_CDATA_SECTION_NODE || type == XML_COMMENT_NODE) {
                effectiveRange.location += 1;
                effectiveRange.length -= 2;
            }
            // prune the text node based on the intersection with aRange
            NSMutableString *content = [[anXMLNode content] mutableCopy];
            NSRange range = NSIntersectionRange(effectiveRange, aRange);
            range.location = range.location - effectiveRange.location;
            [content replaceCharactersInRange:range withString:@""];
            [anXMLNode setContent:content];
            [content release];
            [aDisplayNode adjustLength:-(range.length)];
        } else if(effectiveRange.length <= aRange.length) {
            [aDisplayNode prune];
        } else {
            return;
        }

        effectiveRange.location = NSMaxRange(effectiveRange);
        effectiveRange.length = NSMaxRange(aRange) - effectiveRange.location;
    }

}

- (void)prune
{
    // juggle the pointers to account for the removal of this node
    // from the tree. This doesn't delete the node and its children -
    // dealloc does that.
    if(previous)
        previous->next = next;
    if(next)
        next->previous = previous;
    if(parent->lastChild = self)
        parent->children = previous;
    if(parent->children = self)
        parent->children = next;

    [parent adjustLength:-length];
    
    [xNode prune];
}


- (XMLDisplayNode*)children
{
    return children;
}

- (void)appendChild:(XMLDisplayNode*)aNode
{
    // first, check to see if there are any children
    if(!aNode) return;
    [aNode retain];
    if(children) {
        [lastChild setNext:aNode];
        [aNode setPrevious:lastChild];
    } else {
        children = aNode;
        [aNode setPrevious:nil];
    }
    [aNode setNext:nil];
    [aNode setParent:self];
    lastChild = aNode;
    
}


- (XMLDisplayNode*)next
{
    return next;
}

- (void)setNext:(XMLDisplayNode*)aNode
{
    [next autorelease];
    next = [aNode retain];
}

- (XMLDisplayNode*)previous
{
    return previous;
}

- (void)setPrevious:(XMLDisplayNode*)aNode
{
    [previous autorelease];
    previous = [aNode retain];
}

- (XMLDisplayNode*)parent
{
    return parent;
}

- (void)setParent:(XMLDisplayNode*)aNode
{
    parent = aNode;
}

- (unsigned)length
{
    return length;
}

- (void)adjustLength:(int)change
{
    // adjust the length of the node
    XMLDisplayNode *p = self;
    while(p) {
        p->length += change;
        p->isStringDirty = YES;
        p = p->parent;
    }
}    

- (NSString*)string
{
    NSMutableString *aString = [NSMutableString string];
    XMLDisplayNode *child = children;
    while(child) {
        [aString appendString:[child string]];
        child = [child next];
    }
    length = [aString length];
    return aString;
}

- (NSString*)stringForStartTag
{
    return @"";
}

- (NSString*)stringForEndTag
{
    return @"";
}

- (NSString*)stringForEmptyTag
{
    return @"";
}

- (NSRange)absoluteNodeRange
{
    XMLDisplayNode* parentNode = parent;
    XMLDisplayNode* prevNode;

    int total = 0;
    
    while(parentNode) {
        prevNode = parentNode->previous;
        while(prevNode) {
            total += [prevNode length];
            prevNode = prevNode->previous;
        }
        parentNode = [prevNode parent];
    }
    return NSMakeRange(total, [self length]);
}

- (NSRange)relativeStartTagRange
{
    return NSMakeRange(0,contentRange.location);
}

- (NSRange)relativeContentRange
{
    return contentRange;
}

- (NSRange)relativeEndTagRange
{
    unsigned start = NSMaxRange(contentRange);
    return NSMakeRange(start, length - start); 
}

- (NSDictionary*)attributesAtIndex:(unsigned)charIndex effectiveRange:(NSRangePointer)aRange
{
    NSRange absoluteStartTagRange = [self relativeStartTagRange];
    absoluteStartTagRange.location += aRange->location;
    NSRange absoluteEndTagRange = [self relativeEndTagRange];
    absoluteEndTagRange.location += aRange->location;


    if( NSLocationInRange(charIndex, absoluteStartTagRange) ) {
        *aRange = absoluteStartTagRange;
        return [self startTagAttributes];
    } else if( NSLocationInRange(charIndex, absoluteEndTagRange) ) {
        *aRange = absoluteEndTagRange;
        return [self endTagAttributes];
    } else {
        NSRange absoluteContentRange = contentRange;
        absoluteContentRange.location += aRange->location;
        *aRange = absoluteContentRange;
        return [self contentAttributes];
    }
}

- (XMLDisplayNode*)displayNodeForIndex:(unsigned)index effectiveRange:(NSRangePointer)aRange
{
    unsigned total = 0;
    XMLDisplayNode *child = children;
    NSRange currentRange;
    NSRange absoluteContentRange;

    while(child) {
        currentRange = NSMakeRange(total, [child length]);

        if(NSLocationInRange(index, currentRange) && currentRange.length) {

            absoluteContentRange = [child relativeContentRange];
            absoluteContentRange.location += currentRange.location;

            if([child children] && NSLocationInRange(index, absoluteContentRange)) {
                total = absoluteContentRange.location;
                child = [child children];
            } else {
                *aRange = currentRange;
                return child;

            }

        } else {
            total += currentRange.length;
            child = [child next];
        }
    }
    NSAssert(0, @"unable to find node");
    return nil;
}

// return the text node into which text can be written at index
// if there is no text node currently, create one, and insert it into the tree
// index is considered relative to this node
- (XMLDisplayNode*)textNodeForIndex:(int)index effectiveRange:(NSRangePointer)eRange
{
    XMLDisplayNode *aDisplayNode;
    NSRange r;

    if(!eRange)
        eRange = &r;

    int nodeType = [xNode type];

    if(nodeType == XML_TEXT_NODE) {
        *eRange = [self absoluteNodeRange];
        return self;
    } else if(nodeType == XML_CDATA_SECTION_NODE
              || nodeType == XML_COMMENT_NODE) {

        // get rid of the tags in the range -- this is the text only
        *eRange = [self absoluteNodeRange];
        eRange->location += 1;
        eRange->length -= 2;
        return self;
    } else if(index >= NSMaxRange(contentRange)) {
        // the last child of
        aDisplayNode = lastChild;
    } else if(index < contentRange.location || contentRange.length == 0) {
        // return the last text node before this element tag
       aDisplayNode = [self previous];
    }

    if([[aDisplayNode xmlNode] type] != XML_TEXT_NODE) {
        // create a text node, and make it a next sibling of node
        XMLNode *newNode = [XMLNode xmlTextNodeWithContent:@""];
        [self insertXMLNode:newNode atIndex:index];
        aDisplayNode = [self displayNodeForIndex:index effectiveRange:nil];
    }

    *eRange = [aDisplayNode absoluteNodeRange];
    return aDisplayNode;
}


- (NSDictionary*)startTagAttributes
{
    if(!startTagAttributes) {

        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        [attachment setAttachmentCell:[[self class] prototypeTagCell]];
        
        startTagAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences]];

        [startTagAttributes setObject:attachment forKey:NSAttachmentAttributeName];


        [startTagAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [startTagAttributes setObject:[NSNumber numberWithInt:XML_TAG_START] forKey:RRXMLTagTypeAttributeName];
        [startTagAttributes retain];
        [attachment release];
    }
    return startTagAttributes;
}

- (NSDictionary*)endTagAttributes
{
    NSTextAttachment *attachment;

    if(!endTagAttributes) {
        attachment = [[NSTextAttachment alloc] init];
        [attachment setAttachmentCell:[[self class] prototypeTagCell]];
        endTagAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRElementTagPreferences]];
        [endTagAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [endTagAttributes setObject:attachment forKey:NSAttachmentAttributeName];
        [endTagAttributes setObject:[NSNumber numberWithInt:XML_TAG_END] forKey:RRXMLTagTypeAttributeName];
        [endTagAttributes retain];
        [attachment release];
    }
    return endTagAttributes;
}


- (NSDictionary*)contentAttributes
{
    if(!contentAttributes) {
        contentAttributes = [NSMutableDictionary dictionaryWithDictionary:
            [[PreferencesController elementPreferences] objectForKey:RRElementContentPreferences]];
        [contentAttributes setObject:self forKey:RRXMLDisplayNodeAttributeName];
        [contentAttributes retain];
    }
    return contentAttributes;
}

- (void)dealloc
{

    // first, release all of the children of this node
    XMLDisplayNode *child;
    while(children) {
        child = children;
        children = children->next;
        [child release];
    }

    // now, prune the node from the tree
    [self prune];
    
    [startTagAttributes release];
    [endTagAttributes release];
    [contentAttributes release];
    [cachedString release];
    [super dealloc];
}
@end
