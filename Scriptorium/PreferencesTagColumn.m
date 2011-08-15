//
//  PreferencesTagColumn.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Jan 19 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "PreferencesTagColumn.h"
#import "ElementTagCell.h"


@implementation PreferencesTagColumn

- (void)awakeFromNib
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSAttributedString *string;

    [attributes setObject:[NSNumber numberWithInt:XML_TAG_START]
                   forKey:RRXMLTagTypeAttributeName];
    string = [[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"%c", NSAttachmentCharacter]
                                                    attributes:attributes];
    elementTagCell = [[ElementTagCell alloc] initWithAttributedString:string];
    [string release];

    attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSNumber numberWithInt:XML_TAG_START]
                   forKey:RRXMLTagTypeAttributeName];
    string = [[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"%c", NSAttachmentCharacter]
                                                    attributes:attributes];
    commentTagCell = [[CommentTagCell alloc] initWithAttributedString:string];
    [string release];

    attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSNumber numberWithInt:XML_TAG_START]
                   forKey:RRXMLTagTypeAttributeName];
    string = [[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"%c", NSAttachmentCharacter]
                                                  attributes:attributes];
    cdataTagCell = [[CDATATagCell alloc] initWithAttributedString:string];
    [string release];
    
    attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSNumber numberWithInt:XML_TAG_EMPTY]
                   forKey:RRXMLTagTypeAttributeName];
    string = [[NSAttributedString alloc] initWithString:
        [NSString stringWithFormat:@"%c", NSAttachmentCharacter]
                                             attributes:attributes];
    entityTagCell = [[EntityTagCell alloc] initWithAttributedString:string];
    [string release];
}

- (void)dealloc
{
    [elementTagCell release];
    [commentTagCell release];
    [entityTagCell release];
    [cdataTagCell release];
}

- (id)dataCellForRow:(int)row
{
    NSCell *cell;
    switch(row) {
        case -1:
        case 0:
            cell = elementTagCell;
            break;
        case 1:
            cell = entityTagCell;
            break;
        case 2:
            cell =  commentTagCell;
            break;
        case 3:
            cell =  cdataTagCell;
            break;
        default:
            cell = elementTagCell;
            break;
    }
    return cell;
    
}

@end
