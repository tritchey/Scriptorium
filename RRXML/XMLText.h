//
//  XMLText.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Fri Feb 21 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLElement.h"

@interface XMLText : XMLElement {

}

@end

@interface XMLNode (XMLTextOptions)
+ (XMLNode*)xmlTextNodeWithContent:(NSString*)aString;
@end