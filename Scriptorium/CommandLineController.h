//
//  CommandLineController.h
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Jan 28 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CommandLineController : NSObject {
    IBOutlet NSTextField *commandLine;
}
- (void)log:(NSString*)aString;
@end
