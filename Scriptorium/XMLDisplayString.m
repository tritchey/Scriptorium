//
//  XMLDisplayString.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Jun 08 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLDisplayString.h"


@implementation XMLDisplayString

- (id)initWithXMLTree:(XMLDisplayNode*)aNode
{
    if(self = [super init]) {
        currentRange = NSMakeRange(NSNotFound, 0);
        xmlTree = [aNode retain];
        // generate the string
        [xmlTree string];
    }
    return self;
}

- (unsigned int)length
{
    return [xmlTree length];
}

- (unichar)characterAtIndex:(unsigned)index
{
    if(!NSLocationInRange(index, currentRange)) {
        currentNode = [xmlTree displayNodeForIndex:index effectiveRange:&currentRange];
    }
    return [[currentNode string] characterAtIndex:(index - currentRange.location)];

}

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString
{
    // if we are actually replacing characters (and not just inserting)
    // then prune the tree
    if(aRange.length)
        [xmlTree pruneTreeWithRange:aRange];

    // find the node that into which the string is being inserted
    NSRange eRange = NSMakeRange(0,0);
    XMLDisplayNode *aNode = [xmlTree displayNodeForIndex:aRange.location effectiveRange:&eRange];

    int charIndex = (aRange.location - eRange.location);

    // we need to get the closest text node, creating one if necessary
    XMLDisplayNode *textNode = [aNode textNodeForIndex:charIndex
                                        effectiveRange:nil];

    // pass the index relative to the start of the node in question
    [textNode insertText:aString atIndex:charIndex];
    
}

- (void)dealloc
{
    [xmlTree release];
    [super dealloc];
}

@end
