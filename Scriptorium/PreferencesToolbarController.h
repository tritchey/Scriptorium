//
//  PreferencesToolbarController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Nov 25 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScriptoriumDocument;

@interface PreferencesToolbarController : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSView *emptyView;
    IBOutlet NSView *generalView;
    IBOutlet NSView *elementView;
}
- (void)setupToolbar;
- (void)displayPreferencePane:(id)sender;
@end
