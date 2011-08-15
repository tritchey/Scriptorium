//
//  AppController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Jan 22 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "AppController.h"
#import "PreferencesController.h"
#import "coreDump.h"

@implementation AppController

+ (void)initialize
{
    // collect the defaults
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

    // syntax highlighting defaults
    [defaults setObject:[PreferencesController elementPreferencesArchivedDefaults]
                 forKey:RRElementPreferences];
    // general preferences defaults
    [defaults setObject:[PreferencesController generalPreferencesArchivedDefaults]
                 forKey:RRGeneralPreferences];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (IBAction)showPreferencePanel:(id)sender
{
    if(!preferencesController) {
        preferencesController = [[PreferencesController alloc] init];
    }
    [preferencesController showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication*)sender
{
    return [PreferencesController newEmptyDocPreference];
}

- (IBAction)enableCoreDumps:(id)sender
{
    enableCoreDumps();
}


- (void)dealloc
{
    [preferencesController release];
    [super dealloc];
}

@end
