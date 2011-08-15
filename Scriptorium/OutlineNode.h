//
//  OutlineNode.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Nov 17 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AttributeController, XMLNode, XMLDoc;

@interface OutlineNode : NSObject {
    NSAttributedString *name;
    XMLNode *node;
    NSMutableArray *children;
}
- (id)initWithXMLDoc:(XMLDoc*)doc attributeController:(AttributeController*)attributeController;
- (id)initWithXMLNode:(XMLNode*)aNode attributeController:(AttributeController*)attributeController;
- (NSAttributedString*)name;
- (void)setName:(NSAttributedString*)aString;
- (XMLNode*)node;
- (void)setNode:(XMLNode*)aNode;
- (BOOL)hasChildren;
- (NSMutableArray*)children;
@end
