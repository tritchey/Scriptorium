//
//  XMLDisplayString.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Sun Jun 08 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDisplayNode.h"

@interface XMLDisplayString : NSMutableString {
    XMLDisplayNode *xmlTree;
    NSRange currentRange;
    XMLDisplayNode *currentNode;
}
- (id)initWithXMLTree:(XMLDisplayNode*)aNode;
@end
