//
//  OutlineController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Nov 21 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptoriumDocument, ScriptoriumViewController, OutlineNode, XMLNode, XMLDocument;

@interface OutlineController : NSObject {
    IBOutlet ScriptoriumDocument *document;
    IBOutlet NSOutlineView *outlineView;
    IBOutlet ScriptoriumViewController *viewController;

    OutlineNode *outline;
    NSMutableDictionary *attributes;
    XMLDocument *xmldoc;
}
- (void)setXMLDoc:(XMLDocument*)doc;
@end
