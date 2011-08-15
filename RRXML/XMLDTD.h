//
//  XMLDTD.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Feb 18 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"

@interface XMLDTD : XMLNode {

    void          *notations;   /* Hash table for notations if any */
    void          *elements;    /* Hash table for elements if any */
    void          *attributes;  /* Hash table for attributes if any */
    void          *entities;    /* Hash table for entities if any */
    const xmlChar *ExternalID;	/* External identifier for PUBLIC DTD */
    const xmlChar *SystemID;	/* URI for a SYSTEM or PUBLIC DTD */
    void          *pentities;   /* Hash table for param entities if any */
}
- (NSString*)externalID;
- (NSString*)systemID;

@end
