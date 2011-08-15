//
//  XMLNode.h
//  xmltest
//
//  Created by Timothy Ritchey on Mon Feb 17 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <libxml/tree.h>

int xmlValidGetValidElementsChildren (xmlNode *a_node,
                                      const xmlChar **a_list,
                                      int a_max);

@class XMLDocument, XMLAttribute;

@interface XMLNode : NSObject {
    xmlElementType   type;	/* type number, must be second ! */
    const xmlChar   *name;      /* the name of the node, or the entity */
    XMLNode *children;	/* parent->childs link */
    XMLNode *last;	/* last child link */
    XMLNode *parent;	/* child->parent link */
    XMLNode *next;	/* next sibling link  */
    XMLNode *prev;	/* previous sibling link  */
    XMLDocument  *doc;	/* the containing document */
}
+ (XMLNode*)xmlNodeWithNode:(xmlNodePtr)aNode;
- (xmlElementType)type;
- (void)setType:(xmlElementType)aType;
- (NSString*)name;
- (void)setName:(NSString*)aString;
- (XMLNode*)children;
- (XMLNode*)last;
- (XMLNode*)parent;
- (XMLNode*)next;
- (XMLNode*)prev;
- (XMLDocument*)doc;
- (void)addChild:(XMLNode*)child;
- (void)addSibling:(XMLNode*)sibling;
- (void)addNextSibling:(XMLNode*)sibling;
- (void)addPrevSibling:(XMLNode*)sibling;
- (NSArray*)potentialChildren;

- (void)prune;

// these are only defined for some nodes
- (NSString*)content;
- (void)setContent:(NSString*)aString;
- (void)replaceContentInRange:(NSRange)aRange withString:(NSString*)aString;
- (XMLAttribute*)properties;
@end
