//
//  ScriptoriumDocument.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Nov 13 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class XMLNode, XMLDocument, AttributeController, PreferencesController,
ScriptoriumViewController, ToolbarController, XMLTextViewController, CommandLineController;

@interface ScriptoriumDocument : NSDocument
{
    IBOutlet ScriptoriumViewController *documentViewController;
    IBOutlet XMLTextViewController *textViewController;
    IBOutlet ToolbarController *toolbarController;
    IBOutlet CommandLineController *commandLineController;

    NSString *documentFileName;
    BOOL writeProtected;
    XMLDocument *xmlDocument;
    NSArray *completionArray;
}
- (BOOL)writeProtected;
- (void)setWriteProtected:(BOOL)protect;

- (IBAction)wordCount:(id)sender;
@end
