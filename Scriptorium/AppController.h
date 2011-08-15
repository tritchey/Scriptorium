//
//  AppController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Jan 22 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;

@interface AppController : NSObject {
    PreferencesController *preferencesController;
}
- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)enableCoreDumps:(id)sender;
@end
