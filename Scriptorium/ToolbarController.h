//
//  ToolbarController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Nov 13, 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptoriumDocument;

@interface ToolbarController : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSDrawer *outlineDrawer;
    IBOutlet ScriptoriumDocument *document;

    IBOutlet NSView *statusView;

    IBOutlet NSTextField *statusTextField;
    IBOutlet NSProgressIndicator *progressIndicator;
}
- (void)setupToolbar;
- (void)startProgressAnimation:(id)sender;
- (void)stopProgressAnimation:(id)sender;
@end
