//
//  XMLTextStorage.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Feb 16 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XMLDocument, XMLDocumentDisplayNode, XMLDisplayNode, XMLDisplayString;

@interface XMLTextStorage : NSTextStorage {
    XMLDocumentDisplayNode *xmlTree;
    XMLDisplayString *string;
}
+ (id)xmlTextStorage;
- (void)setXMLDocument:(XMLDocument*)aDoc;
- (XMLDisplayNode*)xmlTree;
@end
