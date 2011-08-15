//
//  PreferencesTagColumn.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Jan 19 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ElementTagCell, CommentTagCell, EntityTagCell, CDATATagCell;

@interface PreferencesTagColumn : NSTableColumn {
    ElementTagCell *elementTagCell;
    CommentTagCell *commentTagCell;
    EntityTagCell *entityTagCell;
    CDATATagCell *cdataTagCell;
}

@end
