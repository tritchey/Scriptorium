//
//  ScriptoriumViewController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Dec 10 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptoriumDocument, AttributeController, ToolbarController;

@interface ScriptoriumViewController : NSObject {

    IBOutlet ScriptoriumDocument *document;
    
    IBOutlet NSTextField *statusBarField;
    IBOutlet NSTextField *commandLineField;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet ToolbarController *toolbarController;

}
- (void)setStatusBarString:(NSString*)aString;
@end
