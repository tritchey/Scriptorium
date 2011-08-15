//
//  ElementTagCell.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Mon Dec 30 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XMLNode, ElementTagView;

extern NSString *RRXMLTagTypeAttributeName;

typedef enum _ElementTagType {
    XML_TAG_UNKNOWN = 0x0,
    XML_TAG_START = 0x1,
    XML_TAG_END = 0x2,
    XML_TAG_EMPTY = 0x4
} ElementTagType;

typedef enum _ElementTagState {
    RRElementTagOff,
    RRElementTagHovering,
    RRElementTagEditing,
    RRElementTagNew,
    RRElementTagError
} ElementTagState;

@interface ElementTagCell : NSTextAttachmentCell {
    NSTextAttachment *attachment;
}
+ (NSBezierPath*)backgroundPathForRect:(NSRect)aRect;
+ (NSBezierPath*)backgroundPathForRect:(NSRect)aRect withType:(ElementTagType)type;
+ (NSBezierPath*)openBracketPathForRect:(NSRect)aRect;
+ (NSBezierPath*)closeBracketPathForRect:(NSRect)aRect;
+ (NSBezierPath*)endSlashPathForRect:(NSRect)aRect;
+ (NSBezierPath*)emptySlashPathForRect:(NSRect)aRect;
+ (ElementTagCell*)elementTagCell;
+ (NSTextView*)elementTagEditor;
- (NSSize)cellSizeForString:(NSString*)name type:(ElementTagType)tagType;
@end