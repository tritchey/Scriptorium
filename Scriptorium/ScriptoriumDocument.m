//
//  ScriptoriumDocument.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Wed Nov 13 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <RRXML/RRXML.h>
#import "ScriptoriumDocument.h"
#import "ScriptoriumViewController.h"
#import "ToolbarController.h"
#import "PreferencesController.h"
#import "XMLTextViewController.h"
#import "CommandLineController.h"
#import "coreDump.h"
#import "XMLTextStorage.h"

@implementation ScriptoriumDocument

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ScriptoriumDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    
    [super windowControllerDidLoadNib:aController];
    [textViewController setXMLDocument:xmlDocument];

}

- (BOOL)writeToFile:(NSString *)fileName ofType:(NSString *)type
{
    return [xmlDocument saveToFilename:fileName];
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType
{

    if([[NSFileManager defaultManager] isReadableFileAtPath:fileName]) {
        documentFileName = [fileName copy];
        xmlDocument = [XMLDocument xmlDocumentWithFile:fileName];
        
        if([[NSFileManager defaultManager] isWritableFileAtPath:fileName])
            [self setWriteProtected:NO];
        else
            [self setWriteProtected:YES];
        
        return YES;
    } else {
        return NO;
    }

}

- (BOOL)writeProtected
{
    return writeProtected;
}

- (void)setWriteProtected:(BOOL)protect
{
    writeProtected = protect;
}

- (IBAction)wordCount:(id)sender
{
    // count the words, and log to the command line
    int wordCount = 0, count = 0;
    NSRange range = {0,0};
    while(range.location != NSNotFound) {
        range = [[NSSpellChecker sharedSpellChecker] checkSpellingOfString:
            [[textViewController xmlTextStorage] string]
                                                                startingAt:NSMaxRange(range)
                                                                  language:@""
                                                                      wrap:NO
                                                    inSpellDocumentWithTag:0
                                                                 wordCount:&count];
        wordCount += count;
    }
    [commandLineController log:[NSString stringWithFormat:@"words: %d", wordCount]];
}

- (void)dealloc {
    [documentFileName release];
    [xmlDocument release];
    [super dealloc];
}

@end
