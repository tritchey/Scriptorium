//
//  PreferencesToolbarController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Nov 25 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import "PreferencesToolbarController.h"

static NSString* PreferencesToolbarIdentifier = @"Preferences Toolbar Identifier";
static NSString* GeneralToolbarItemIdentifier = @"General Item Identifier";
static NSString* ElementToolbarItemIdentifier = @"Elements Item Identifier";

@implementation PreferencesToolbarController

- (void) awakeFromNib
{
    [self setupToolbar];
}

// ============================================================
// NSToolbar Related Methods
// ============================================================

- (void) setupToolbar {
    // Create a new toolbar instance, and attach it to our document window
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier:PreferencesToolbarIdentifier] autorelease];

    // Set up toolbar properties: Allow customization, give a default display mode, and remember state in user defaults
    [toolbar setAllowsUserCustomization: NO];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];

    // We are the delegate
    [toolbar setDelegate: self];

    // Attach the toolbar to the document window
    [window setToolbar: toolbar];
}

- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {

    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];


    if ([itemIdent isEqual: ElementToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Elements"];
        [toolbarItem setPaletteLabel: @"Elements"];
        [toolbarItem setToolTip: @"Elements"];
        [toolbarItem setImage: [NSImage imageNamed: @"elementPreferences"]];

        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget:self];
        [toolbarItem setAction: @selector(displayPreferencePane:)];
    } else if ([itemIdent isEqual: GeneralToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"General"];
        [toolbarItem setPaletteLabel: @"General"];
        [toolbarItem setToolTip: @"General"];
        [toolbarItem setImage: [NSImage imageNamed: @"generalPreferences"]];

        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget:self];
        [toolbarItem setAction: @selector(displayPreferencePane:)];
    } else {
        toolbarItem = nil;
    }
    return toolbarItem;

}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar {
    return [NSArray arrayWithObjects: GeneralToolbarItemIdentifier,
        ElementToolbarItemIdentifier, nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {

    return [NSArray arrayWithObjects: GeneralToolbarItemIdentifier,
        ElementToolbarItemIdentifier, nil];
}

- (void)displayPreferencePane:(id)sender
{
    NSView *view;

    [window setTitle:[sender label]];
    if([[sender label] isEqual:@"Elements"]) {
        view = elementView;
    } else if([[sender label] isEqual:@"General"]) {
        view = generalView;
    } 
    NSRect windowFrame = [window frame];
    NSRect viewFrame = [view frame];
    NSRect contentViewFrame = [[window contentView] frame];

    float diff = windowFrame.size.height -  contentViewFrame.size.height;
    NSRect newFrame = {
    {windowFrame.origin.x,
        (windowFrame.origin.y + contentViewFrame.size.height) - viewFrame.size.height},
    {viewFrame.size.width, viewFrame.size.height + diff}};

    [window setContentView:emptyView];
    [window setFrame:newFrame display:YES animate:YES];
    [window setContentView:view];

}

@end
