//
//  XMLDocument.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"

@class XMLDTD;

@interface XMLDocument : XMLNode {
int             compression;/* level of zlib compression */
int             standalone; /* standalone document (no external refs) */
XMLDTD  *intSubset;	/* the document internal subset */
XMLDTD  *extSubset;	/* the document external subset */
struct _xmlNs   *oldNs;	/* Global namespace, the old way */
const xmlChar  *version;	/* the XML version string */
const xmlChar  *encoding;   /* external initial encoding, if any */
void           *ids;        /* Hash table for ID attributes if any */
void           *refs;       /* Hash table for IDREFs attributes if any */
const xmlChar  *URL;	/* The URI for that document */
int             charset;    /* encoding of the in-memory content */
}
+ (XMLDocument*)xmlDocumentWithFile:(NSString*)fileName;
- (int)compression;
- (int)standalone;
- (XMLDTD*)intSubset;
- (XMLDTD*)extSubset;
- (NSString*)version;
- (NSString*)encoding;
- (NSString*)url;
- (int)charset;

// file management methods
- (BOOL)saveToFilename:(NSString*)aString;

// tree management methods
- (void)replaceNode:(XMLNode*)old withNode:(XMLNode*)aNode;
- (void)addChild:(XMLNode*)child toNode:(XMLNode*)parent;
- (void)addPrevSibling:(XMLNode*)sibling forNode:(XMLNode*)aNode;
- (void)addNextSibling:(XMLNode*)sibling forNode:(XMLNode*)aNode;
- (void)pruneNode:(XMLNode*)aNode;

- (NSArray*)validReplacementNamesForNode:(XMLNode*)aNode;
- (NSArray*)allowedElementsForPrevNode:(XMLNode*)prevNode nextNode:(XMLNode*)nextNode;

- (NSArray*)nodesForString:(NSString*)string;
@end
