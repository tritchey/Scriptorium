//
//  ElementTagView.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Thu Jan 02 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <AppKit/AppKit.h>

@class ElementTagCell;

@interface ElementTagView : NSControl {
    NSMutableAttributedString *textStorage;
    ElementTagCell *elementTagCell;
    NSMatrix *attributeMatrix;
}
- (id)initWithTextView:(NSTextView*)aTextView characterIndex:(int)charIndex cellClass:(Class)aClass;
- (id)initWithAttributedString:(NSAttributedString*)aString cellClass:(Class)aClass;
- (void)setAttributedString:(NSAttributedString*)aString;
- (NSAttributedString*)textStorage;
@end
