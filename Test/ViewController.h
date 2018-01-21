//
//  ViewController.h
//  Test
//
//  Created by Clement on 13/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

#import "ImageObject.h"
#import "DatabaseManager.h"

@interface ViewController : NSViewController {
    
    NSString *currentPath;
    NSMutableArray *imgArray;
    NSInteger currentId;
    
    DatabaseManager *dbManager;
}

@property (weak) IBOutlet NSTextField *textField;

@property (weak) IBOutlet NSImageView *imageView;

@property (weak) IBOutlet NSTextField *imageCounter;
@property (weak) IBOutlet NSTextField *imagePath;
@property (weak) IBOutlet NSTextField *deletedLabel;

@property (weak) IBOutlet NSPopUpButton *imageJumpSelect;

@property (weak) IBOutlet NSButton *prevButton;
@property (weak) IBOutlet NSButton *nextButton;

@end

