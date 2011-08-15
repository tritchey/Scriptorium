//
//  XMLAttribute.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"

@class XMLNameSpace;

@interface XMLAttribute : XMLNode {
    xmlNs    *ns;        /* pointer to the associated namespace */
    xmlAttributeType atype;     /* the attribute type if validating */
}
- (XMLNode*)value;
- (xmlAttributeType)attributeType;
@end
