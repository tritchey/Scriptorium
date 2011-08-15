//
//  ScriptoriumViewController.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Tue Dec 10 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "ScriptoriumDocument.h"
#import "ScriptoriumViewController.h"
#import "ToolbarController.h"

@implementation ScriptoriumViewController


- (void)setStatusBarString:(NSString*)aString
{
    [statusBarField setStringValue:aString];
}


@end
