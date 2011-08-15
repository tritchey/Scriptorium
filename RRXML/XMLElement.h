//
//  XMLElement.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"

@class XMLAttribute, XMLDisplay;

@interface XMLElement : XMLNode {
    xmlNs           *ns;        /* pointer to the associated namespace */
    xmlChar         *content;   /* the content */
    XMLAttribute *properties;/* properties list */
    xmlNs           *nsDef;     /* namespace definitions on this node */ 
}

@end

@interface XMLNode (XMLElementOptions)
+xmlElementNodeWithName:(NSString*)aString;
@end