//
//  PreferencesController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Nov 25 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// general preferences
extern NSString *RRGeneralPreferences;
extern NSString *RRNewEmptyDocPreference;

// element preferences
extern NSString *RRElementPreferences;
extern NSString *RRElementPreferencesChanged;
extern NSString *RRElementTagPreferences;
extern NSString *RRElementContentPreferences;
extern NSString *RREntityTagPreferences;
extern NSString *RREntityContentPreferences;
extern NSString *RRCommentTagPreferences; 
extern NSString *RRCommentContentPreferences;
extern NSString *RRCDATATagPreferences;
extern NSString *RRCDATAContentPreferences;



@interface PreferencesController : NSWindowController {

    NSUserDefaults *prefs;
    
    // general preferences outlets
    IBOutlet NSView* generalView;
    IBOutlet NSButton *newEmptyDocEnabled;

    // syntax highlighting outlets
    IBOutlet NSView *elementView;
    IBOutlet NSTableView *elementTableView;
    IBOutlet NSTextField *elementContentFontTextField;
    IBOutlet NSColorWell *elementContentForegroundColorWell;
    IBOutlet NSColorWell *elementContentBackgroundColorWell;
    IBOutlet NSButton *elementContentBackgroundColorEnabled;
    IBOutlet NSTextField *elementTagFontTextField;
    IBOutlet NSColorWell *elementTagForegroundColorWell;
    IBOutlet NSColorWell *elementTagBackgroundColorWell;

    int selectedRow;
    BOOL fontPanelIsForTags;
    NSFontManager *fontManager;
    NSMutableDictionary *elementPreferencesCache;
}
+ (NSDictionary*)archivedDictionaryForAttributes:(NSDictionary*)attributes;
+ (NSDictionary*)attributesForArchivedDictionary:(NSDictionary*)dictionary;

    // general preferences
+ (NSDictionary*)generalPreferencesArchivedDefaults;
+ (NSDictionary*)generalPreferences;
+ (BOOL)newEmptyDocPreference;
- (IBAction)changeNewEmptyDoc:(id)sender;

// element preferences
+ (NSDictionary*)elementPreferencesArchivedDefaults;
+ (void)cacheElementPreferences;
+ (NSDictionary*)elementPreferences;
+ (NSDictionary*)preferencesForElement:(NSString*)aString;
+ (void)setPreferences:(NSDictionary*)attributes forElement:(NSString*)aString;
- (IBAction)changeElementTagFont:(id)sender;
- (IBAction)changeElementTagColor:(id)sender;
- (IBAction)restoreElementDefaults:(id)sender;
- (IBAction)changeElementContentFont:(id)sender;
- (IBAction)changeElementContentColor:(id)sender;
@end
