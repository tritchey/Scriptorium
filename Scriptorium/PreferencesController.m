//
//  PreferencesController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Nov 25 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import "PreferencesController.h"


NSString *RRGeneralPreferences = @"General Preferences";
NSString *RRNewEmptyDocPreference = @"Open New Empty Document On Launch";

NSString *RRElementPreferences = @"Syntax Highlighting Preferences";
NSString *RRElementFontSize = @"Syntax Highlighting Font Size";

NSString *RRElementPreferencesChanged = @"Element Preferences Notification";

NSString *tagPreferencesIdentifiers[4] = {@"RRElementTagPreferences", @"RREntityTagPreferences",
    @"RRCommentTagPreferences", @"RRCDATATagPreferences"};
NSString *contentPreferencesIdentifiers[4] = {@"RRElementContentPreferences",
    @"RREntityContentPreferences", @"RRCommentContentPreferences", @"RRCDATAContentPreferences"};

NSString *RRElementTagPreferences = @"RRElementTagPreferences";
NSString *RRElementContentPreferences = @"RRElementContentPreferences";
NSString *RREntityTagPreferences = @"RREntityTagPreferences";
NSString *RREntityContentPreferences = @"RREntityContentPreferences";
NSString *RRCommentTagPreferences = @"RRCommentTagPreferences";
NSString *RRCommentContentPreferences = @"RRCommentContentPreferences";
NSString *RRCDATATagPreferences = @"RRCDATATagPreferences";
NSString *RRCDATAContentPreferences = @"RRCDATAContentPreferences";

static BOOL elementPreferencesCacheDirty = YES;
static NSMutableDictionary *elementPreferences;

@implementation PreferencesController

+ (void)initialize
{
    // collect the defaults
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];

    // syntax highlighting defaults
    [defaults setObject:[self elementPreferencesArchivedDefaults]
                 forKey:RRElementPreferences];
    // general preferences defaults
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    elementPreferences = [[NSMutableDictionary dictionary] retain];

}

+ (NSDictionary*)archivedDictionaryForAttributes:(NSDictionary*)attributes
{
    NSMutableDictionary *archivedAttributes = [NSMutableDictionary dictionary];

    NSEnumerator *e = [attributes keyEnumerator];
    id key, object;
    NSData *archivedObject;
    while(key = [e nextObject]) {
        object = [attributes objectForKey:key];
        archivedObject = [NSArchiver archivedDataWithRootObject:object];
        [archivedAttributes setObject:archivedObject
                               forKey:key];
    }
    return archivedAttributes;
    
}

+ (NSDictionary*)attributesForArchivedDictionary:(NSDictionary*)dictionary
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    NSEnumerator *e = [dictionary keyEnumerator];
    id key, object;
    NSData *archivedObject;
    while(key = [e nextObject]) {
        archivedObject = [dictionary objectForKey:key];
        object = [NSUnarchiver unarchiveObjectWithData:archivedObject];
        [attributes setObject:object
                       forKey:key];
    }
    return attributes;
    
}

+ (NSDictionary*)elementPreferencesArchivedDefaults
{

    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    // create an attribute database with some default font stuff

    // content
    [attributes setObject:[NSFont userFontOfSize:12.0]
                   forKey:NSFontAttributeName];
    [attributes setObject:[NSColor blackColor]
                   forKey:NSForegroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRElementContentPreferences];

    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RREntityContentPreferences];

    [attributes setObject:[NSColor colorWithCalibratedRed:0.25 green:0.5 blue:0.0 alpha:1.0]
                   forKey:NSForegroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRCommentContentPreferences];

    [attributes setObject:[NSFont userFixedPitchFontOfSize:11.0]
                   forKey:NSFontAttributeName];
    [attributes setObject:[NSColor darkGrayColor]
                   forKey:NSForegroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRCDATAContentPreferences];

    // tags
    [attributes setObject:[NSFont userFontOfSize:11.0]
                   forKey:NSFontAttributeName];
    [attributes setObject:[NSNumber numberWithInt:1.0]
                   forKey:NSBaselineOffsetAttributeName];
    [attributes setObject:[NSColor whiteColor]
                   forKey:NSForegroundColorAttributeName];
    [attributes setObject:[NSColor alternateSelectedControlColor]
                   forKey:NSBackgroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRElementTagPreferences];

    [attributes setObject:[NSColor colorWithCalibratedRed:0.25 green:0.5 blue:0.0 alpha:1.0]
                   forKey:NSBackgroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRCommentTagPreferences];

    [attributes setObject:[NSColor purpleColor]
                   forKey:NSBackgroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RREntityTagPreferences];

    [attributes setObject:[NSColor greenColor]
                   forKey:NSForegroundColorAttributeName];
    [attributes setObject:[NSColor blackColor]
                   forKey:NSBackgroundColorAttributeName];
    [defaultValues setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:RRCDATATagPreferences];

    
    // add our dictionary of attributes to the whole default preferences dict
    return defaultValues;
}

+ (void)cacheElementPreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *allArchivedAttributes = [defaults dictionaryForKey:RRElementPreferences];
    NSEnumerator *e = [allArchivedAttributes keyEnumerator];
    id key, object;
    while (key = [e nextObject]) {
        object = [allArchivedAttributes objectForKey:key];
        [elementPreferences setObject:[self attributesForArchivedDictionary:object]
                               forKey:key];
    }
    elementPreferencesCacheDirty = NO;
}

+ (NSDictionary*)elementPreferences
{
    if(elementPreferencesCacheDirty) {
        [self cacheElementPreferences];
    }
    return elementPreferences;
}


+ (NSDictionary*)preferencesForElement:(NSString*)aString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *allArchivedAttributes = [defaults dictionaryForKey:RRElementPreferences];
    NSDictionary *archivedDictionary = [allArchivedAttributes objectForKey:aString];

    return [self attributesForArchivedDictionary:archivedDictionary];
}

+ (void)setPreferences:(NSDictionary*)attributes forElement:(NSString*)aString
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *allAttributes
        = [[defaults dictionaryForKey:RRElementPreferences] mutableCopy];

    [allAttributes setObject:[self archivedDictionaryForAttributes:attributes]
                      forKey:aString];
    
    [defaults setObject:allAttributes
                 forKey:RRElementPreferences];
    [defaults synchronize];
    elementPreferencesCacheDirty = YES;
}

- (id)init
{
    if(self = [super initWithWindowNibName:@"Preferences"]) {
        prefs = [[NSUserDefaults standardUserDefaults] retain];
        selectedRow = -1;
        fontManager = [NSFontManager sharedFontManager];
        [fontManager setDelegate:self];
        [self setWindowFrameAutosaveName:@"PrefWindow"];
    }
    return self;
}

- (void)windowDidLoad
{
    elementPreferencesCache = [[PreferencesController elementPreferences] retain];
    [self tableViewSelectionDidChange:nil];
    [newEmptyDocEnabled setState:[PreferencesController newEmptyDocPreference]];
}

- (void)dealloc
{
    [prefs synchronize];
    [prefs release];
    [elementPreferencesCache release];
}

// here are the syntax highlighting support methods


- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return 4;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex
{
    if([[aTableColumn identifier] isEqual:@"content"]) {
        NSDictionary *att = [elementPreferencesCache objectForKey:
            contentPreferencesIdentifiers[rowIndex]];
        NSFont *font = [att objectForKey:NSFontAttributeName];
        NSString *fontDisplay
            = [NSString stringWithFormat:@"%@ - %2.1f", [font displayName], [font pointSize]];
        return [[[NSAttributedString alloc] initWithString:fontDisplay attributes:att] autorelease];
    }
    return nil;
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if([aCell respondsToSelector:@selector(updatePreferences)]) {
        [aCell  updatePreferences];
    }
        
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSFont *font;
    NSString *fontDisplayString;
    NSAttributedString *aString;
    NSDictionary *att;
    NSColor *color;
    
    // get the new selected row
    selectedRow = [elementTableView selectedRow];

    // update the tag preferences display
    att = [elementPreferencesCache objectForKey:tagPreferencesIdentifiers[selectedRow]];
    font = [att objectForKey:NSFontAttributeName];
    fontDisplayString = [NSString stringWithFormat:@"%@ - %2.1f", [font displayName], [font pointSize]];
    aString = [[NSAttributedString alloc] initWithString:fontDisplayString attributes:att];

    [elementTagFontTextField setAttributedStringValue:aString];

    [fontManager setSelectedFont:font isMultiple:NO];

    // set the foreground and background color wells
    if(color = [att objectForKey:NSForegroundColorAttributeName])
        [elementTagForegroundColorWell setColor:color];

    if(color = [att objectForKey:NSBackgroundColorAttributeName]) 
        [elementTagBackgroundColorWell setColor:color];
    

    // update the content preferences display
    att = [elementPreferencesCache objectForKey:contentPreferencesIdentifiers[selectedRow]];

    font = [att objectForKey:NSFontAttributeName];
    fontDisplayString = [NSString stringWithFormat:@"%@ - %2.1f", [font displayName], [font pointSize]];
    aString = [[NSAttributedString alloc] initWithString:fontDisplayString attributes:att];
    
    [elementContentFontTextField setAttributedStringValue:aString];

    [fontManager setSelectedFont:font isMultiple:NO];
    
    // set the foreground and background color wells
    if(color = [att objectForKey:NSForegroundColorAttributeName])
        [elementContentForegroundColorWell setColor:color];

    // we might not have a background color set
    if(color = [att objectForKey:NSBackgroundColorAttributeName]) {
        [elementContentBackgroundColorWell setColor:color];
        [elementContentBackgroundColorEnabled setState:NSOnState];
    } else {
        [elementContentBackgroundColorEnabled setState:NSOffState];
    }

}


- (IBAction)changeElementContentFont:(id)sender
{
    // open font window and select font
    [fontManager orderFrontFontPanel:self];
    fontPanelIsForTags = NO;
    // set the current font in the panel
    NSDictionary *att = [elementPreferencesCache objectForKey:
        contentPreferencesIdentifiers[selectedRow]];
    [fontManager setSelectedFont:[att objectForKey:NSFontAttributeName] isMultiple:NO];
}

- (IBAction)changeElementTagFont:(id)sender
{
    // open font window and select font
    [fontManager orderFrontFontPanel:self];
    fontPanelIsForTags = YES;
    // set the current font in the panel
    NSDictionary *att = [elementPreferencesCache objectForKey:
        tagPreferencesIdentifiers[selectedRow]];
    [fontManager setSelectedFont:[att objectForKey:NSFontAttributeName] isMultiple:NO];
}

- (IBAction)changeFont:(id)sender
{
    NSMutableDictionary *att;
    NSString **ident;
    NSFont *oldFont;
    NSFont *font;
    NSString *fontDisplayString;
    NSAttributedString *aString;
    NSTextField *textField;

    if(fontPanelIsForTags) {
        ident = tagPreferencesIdentifiers;
        textField = elementTagFontTextField;
    } else {
        ident = contentPreferencesIdentifiers;
        textField = elementContentFontTextField;
    }

    att = [elementPreferencesCache objectForKey:ident[selectedRow]];

    oldFont = [att objectForKey:NSFontAttributeName];

    font = [[fontManager fontPanel:NO] panelConvertFont:oldFont];
    
    if(selectedRow >= 0) {
        [att setObject:font forKey:NSFontAttributeName];
        [elementPreferencesCache setObject:att forKey:ident[selectedRow]];
        [PreferencesController setPreferences:att
                                   forElement:ident[selectedRow]];

        
        [elementTableView reloadData];
        fontDisplayString = [NSString stringWithFormat:@"%@ - %2.1f",
            [font displayName], [font pointSize]];
        aString = [[NSAttributedString alloc] initWithString:fontDisplayString attributes:att];
        [textField setAttributedStringValue:aString];

    }
}

- (IBAction)changeElementContentColor:(id)sender
{
    NSString *key = nil;
    NSString **ident = contentPreferencesIdentifiers;
    
    if(sender == elementContentForegroundColorWell) {
        key = NSForegroundColorAttributeName;
    } else if(sender == elementContentBackgroundColorWell
              && [elementContentBackgroundColorEnabled state]) {
        key = NSBackgroundColorAttributeName;
    } else if(sender == elementContentBackgroundColorEnabled) {
        if(![sender state]) {
            key = nil;
            NSMutableDictionary *att = [elementPreferencesCache objectForKey:ident[selectedRow]];
            [att removeObjectForKey:NSBackgroundColorAttributeName];
            [elementPreferencesCache setObject:att forKey:ident[selectedRow]];
            [PreferencesController setPreferences:att
                                       forElement:ident[selectedRow]];
            [elementTableView reloadData];
            [self tableViewSelectionDidChange:nil];
            
        } else {
            sender = elementContentBackgroundColorWell;
            key = NSBackgroundColorAttributeName;
        }
    }
    
    if(key && selectedRow >= 0) {
        NSMutableDictionary *att = [elementPreferencesCache objectForKey:ident[selectedRow]];
        [att setObject:[sender color] forKey:key];
        [elementPreferencesCache setObject:att forKey:ident[selectedRow]];
        [PreferencesController setPreferences:att
                                   forElement:ident[selectedRow]];
        

        [elementTableView reloadData];
        [self tableViewSelectionDidChange:nil];
    }
}

- (IBAction)changeElementTagColor:(id)sender
{
    NSString *key;
    NSString **ident = tagPreferencesIdentifiers;

    if(sender == elementTagForegroundColorWell) {
        key = NSForegroundColorAttributeName;
    } else if(sender == elementTagBackgroundColorWell) {
        key = NSBackgroundColorAttributeName;
    }
    
    if(key && selectedRow >= 0) {
        NSMutableDictionary *att = [elementPreferencesCache objectForKey:ident[selectedRow]];
        [att setObject:[sender color] forKey:key];
        [elementPreferencesCache setObject:att forKey:ident[selectedRow]];
        [PreferencesController setPreferences:att
                                   forElement:ident[selectedRow]];


        [elementTableView reloadData];
        [self tableViewSelectionDidChange:nil];
    }
}

- (IBAction)restoreElementDefaults:(id)sender
{
    [prefs setObject:[PreferencesController elementPreferencesArchivedDefaults]
              forKey:RRElementPreferences];

    [elementPreferencesCache addEntriesFromDictionary:[PreferencesController elementPreferences]];
    
    [elementTableView reloadData];
    [self tableViewSelectionDidChange:nil];
}

+ (NSDictionary*)generalPreferencesArchivedDefaults
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:RRNewEmptyDocPreference];

    return defaultValues;
    
}

+ (NSDictionary*)generalPreferences
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:RRGeneralPreferences];
}

+ (BOOL)newEmptyDocPreference
{
    return [[[self generalPreferences] objectForKey:RRNewEmptyDocPreference] boolValue];
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
    NSMutableDictionary *genP = [[PreferencesController generalPreferences] mutableCopy];
    [genP setObject:[NSNumber numberWithBool:[sender state]] forKey:RRNewEmptyDocPreference];
    [[NSUserDefaults standardUserDefaults] setObject:genP forKey:RRGeneralPreferences];
}

@end
