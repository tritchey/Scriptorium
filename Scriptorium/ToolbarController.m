//
//  ToolbarController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Nov 13 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//


#import "ToolbarController.h"
#import "ScriptoriumDocument.h"

static NSString* ScriptoriumToolbarIdentifier = @"Scriptorium Toolbar Identifier";
static NSString* ToggleOutlineDrawerToolbarItemIdentifier = @"Toggle Outline Drawer Item Identifier";
static NSString* StatusFieldViewToolbarItemIdentifier = @"Status Field View Item Identifier";

@implementation ToolbarController

- (void) awakeFromNib
{
    [self setupToolbar];
}



- (void) setupToolbar {
    // Create a new toolbar instance, and attach it to our document window
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier:ScriptoriumToolbarIdentifier] autorelease];

    // Set up toolbar properties: Allow customization, give a default display mode, and remember state in user defaults
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconOnly];

    // We are the delegate
    [toolbar setDelegate: self];

    // Attach the toolbar to the document window
    [window setToolbar: toolbar];
}


- (void)startProgressAnimation:(id)sender
{
    [progressIndicator startAnimation:sender];
}

- (void)stopProgressAnimation:(id)sender
{
    [progressIndicator stopAnimation:sender];
}

    // ============================================================
    // NSToolbar Related Methods
    // ============================================================
- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
    // Required delegate method   Given an item identifier, self method returns an item
    // The toolbar will use self method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];


    // itemIdent refered to a toolbar item that is not provide or supported by us or cocoa
    // Returning nil will inform the toolbar self kind of item is not supported
    if ([itemIdent isEqual: ToggleOutlineDrawerToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Outline"];
        [toolbarItem setPaletteLabel: @"Toggle Outline"];
        [toolbarItem setToolTip: @"Toggle the Outline Drawer"];
        [toolbarItem setImage: [NSImage imageNamed: @"outlineDrawer"]];

        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget:outlineDrawer];
        [toolbarItem setAction: @selector(toggle:)];
    } else if ([itemIdent isEqual: StatusFieldViewToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Status"];
        [toolbarItem setPaletteLabel: @"Status"];
        [toolbarItem setToolTip: @"Status"];
        [toolbarItem setMinSize:NSMakeSize(86,32)];
        [toolbarItem setMaxSize:NSMakeSize(86,32)];
        [toolbarItem setView: statusView];

        // Tell the item what message to send when it is clicked
    } else if ([itemIdent isEqual:NSToolbarFlexibleSpaceItemIdentifier]) {
    } else {
        toolbarItem = nil;
    }
    return toolbarItem;

}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar {
    // Required delegate method   Returns the ordered list of items to be shown in the toolbar by default
    // If during the toolbar's initialization, no overriding values are found in the user defaults, or if the
    // user chooses to revert to the default items self set will be used
    return [NSArray arrayWithObjects: ToggleOutlineDrawerToolbarItemIdentifier,
        NSToolbarFlexibleSpaceItemIdentifier, StatusFieldViewToolbarItemIdentifier, nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    // Required delegate method   Returns the list of all allowed items by identifier   By default, the toolbar
    // does not assume any items are allowed, even the separator   So, every allowed item must be explicitly listed
    // The set of allowed items is used to construct the customization palette
    return [NSArray arrayWithObjects: ToggleOutlineDrawerToolbarItemIdentifier,
        StatusFieldViewToolbarItemIdentifier,
        NSToolbarPrintItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier,
        NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier,
        NSToolbarSeparatorItemIdentifier, nil];
}
@end
