//
//  XMLDocument.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLDocument.h"


@implementation XMLDocument

+ (void)initialize
{
    xmlInitParser();
}

+ (XMLDocument*)xmlDocumentWithFile:(NSString*)fileName
{
    // disable validity checking for the first run
    xmlDoValidityCheckingDefaultValue = 1;
    XMLDocument* document = (XMLDocument*)[self xmlNodeWithNode:
        (xmlNodePtr)xmlRecoverFile([fileName cString])];

    // set up document tree

    
    // later, we are going to have to spend some time
    // thinking about how to deal with includes
    //xmlXIncludeProcess(document);

    return document;
}

- (int)compression
{
    return compression;
}

- (int)standalone
{
    return standalone;
}

- (XMLDTD*)intSubset
{
    return (XMLDTD*)intSubset;
}

- (XMLDTD*)extSubset
{
    return (XMLDTD*)extSubset;
}

- (NSString*)version
{
    if(version)
        return [NSString stringWithCString:version];
    return nil;
}

- (NSString*)encoding
{
    if(version)
        return [NSString stringWithCString:encoding];
    return nil;
}

- (NSString*)url
{
    if(version)
        return [NSString stringWithCString:URL];
    return nil;
}

- (int)charset
{
    return charset;
}


- (void)replaceNode:(XMLNode*)old withNode:(XMLNode*)aNode
{
    xmlReplaceNode((xmlNodePtr)old, (xmlNodePtr)aNode);
}

- (void)addChild:(XMLNode*)child toNode:(XMLNode*)aNode
{
    xmlAddChild((xmlNodePtr)aNode, (xmlNodePtr)child);

}

- (void)addPrevSibling:(XMLNode*)sibling forNode:(XMLNode*)aNode
{
    xmlAddPrevSibling((xmlNodePtr)aNode, (xmlNodePtr)sibling);
}

- (void)addNextSibling:(XMLNode*)sibling forNode:(XMLNode*)aNode
{
    xmlAddNextSibling((xmlNodePtr)aNode, (xmlNodePtr)sibling);
}

- (void)pruneNode:(XMLNode*)aNode
{
    xmlUnlinkNode((xmlNodePtr)aNode);
    // ??
    xmlFreeNode((xmlNodePtr)aNode);
}

- (NSArray*)validReplacementNamesForNode:(XMLNode*)aNode
{
    return [self allowedElementsForPrevNode:[aNode prev]
                                   nextNode:[aNode next]];
}

- (NSArray*)allowedElementsForPrevNode:(XMLNode*)prevNode nextNode:(XMLNode*)nextNode
{
    int max = 32;
    int count = max, i;
    xmlChar **list = NULL;
    NSMutableArray *array = [NSMutableArray array];

    while(count == max) {
        if(list)
            free(list);
        max += max;
        list = (xmlChar**)malloc(sizeof(xmlChar[64])*max);
        count = xmlValidGetValidElements((xmlNodePtr)prevNode,
                                         (xmlNodePtr)nextNode,
                                         (const xmlChar**)list, max);
    }

    for(i = 0; i < count; ++i) {
        [array addObject:[NSString stringWithCString:list[i]]];
    }

    free(list);
    return array;

}

- (NSArray*)nodesForString:(NSString*)string
{
    xmlNodePtr node;
    NSMutableArray *array = [NSMutableArray array];
    xmlParseBalancedChunkMemoryRecover((xmlDocPtr)self,
                                       NULL, NULL, 0,
                                       [string cString],
                                       &node,
                                       0);
    while(node) {
        [array addObject:(id)node];
        node = node->next;
    }
    return array;
}


- (BOOL)saveToFilename:(NSString*)aString
{
    int result = xmlSaveFile([aString cString], (xmlDocPtr)self);
    if(result > 0)
        return YES;

    return NO;
}



@end
