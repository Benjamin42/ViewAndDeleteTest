//
//  ViewController.m
//  Test
//
//  Created by Clement on 13/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController {
    id keyMonitor;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    keyMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        
        unichar character = [[event characters] characterAtIndex:0];
        switch (character) {
            case NSLeftArrowFunctionKey:
                [self previous:NULL];
                break;
            case NSRightArrowFunctionKey:
                [self next:NULL];
                break;
            case 'd':
                NSLog(@"d key pressed");
                [self switchCurrentToDelete];
                [self loadCurrentImage];
                break;
            default:
                break;
        }
        return event;
    }];
    
    [self.imageJumpSelect selectItemAtIndex:0];
    
    imgArray = [[NSMutableArray alloc] init];
    currentId = 0;

    // Do any additional setup after loading the view.
    [self.textField setStringValue:@"Texte par défaut"];
    
    //NSURL *url = [[NSURL alloc] initWithString:@"file:///Users/Clement/Desktop/Thailande/100NCD40/DSC_0048.JPG"];
    //[self loadImage:url];
}

- (void) switchCurrentToDelete {
    ImageObject *obj = [imgArray objectAtIndex:currentId];
    [obj switchToDelete];
    [dbManager updateLine:[obj getFileName], [obj getToDelete]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void) loadCurrentImage {
    ImageObject *obj = [imgArray objectAtIndex:currentId];
    NSURL *url = [obj getUrl];

    NSImage *img = [[NSImage alloc] initByReferencingURL:url];
    [self.imageView setImage:img];
    
    #if !__has_feature(objc_arc)
        [img autorelease];
    #endif
    
    [self.imageView setImage:img];
    NSString *str = [NSString stringWithFormat:@"%ld / %ld", currentId + 1, [imgArray count]];

    [self.imageCounter setStringValue:str];
    [self.imagePath setStringValue:[url lastPathComponent]];
    
    if ([obj getToDelete]) {
        [self.deletedLabel setStringValue:@"A effacer"];
    } else {
        [self.deletedLabel setStringValue:@""];
    }
}

- (void) resetLoader {
    [imgArray removeAllObjects];
    currentId = 0;
}

- (IBAction)open:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:FALSE];
    [panel setAllowsMultipleSelection:FALSE];
    [panel setMessage:@"Open a file or a directory."];
    
    // This method displays the panel and returns immediately.
    // see : https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/UsingtheOpenandSavePanels/UsingtheOpenandSavePanels.html
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            NSURL*  docUrl = [[panel URLs] objectAtIndex:0];
            NSNumber *isDirectory = nil;
            [docUrl getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];

            if ([isDirectory boolValue]) {
                // Scan du répertoire
                NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
                NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                                     enumeratorAtURL:docUrl
                                                     includingPropertiesForKeys:keys
                                                     options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                     errorHandler:^(NSURL *url, NSError *error) {
                                                         // Handle the error.
                                                         // Return YES if the enumeration should continue after the error.
                                                         return YES;
                                                     }];
                currentPath = docUrl.absoluteString;

                // TODO : si dbManager exist, le libérer (pour fermer la base)
                dbManager = [[DatabaseManager alloc] initWithPath:currentPath];
                
                [self resetLoader];
                for (NSURL *url in enumerator) {
                    ImageObject *myImage = [[ImageObject alloc] initWithURL:url];
                    if ([dbManager exists:[myImage getFileName]]) {
                        [myImage switchToDelete];
                    }
                    [imgArray addObject:myImage];
                }

                
                // On affiche la premiere image du tableau
                [self loadCurrentImage];
            }
            [self.textField setStringValue:currentPath];
        }
        
    }];
}

- (IBAction)previous:(id)sender {
    currentId = currentId - [[self.imageJumpSelect titleOfSelectedItem] integerValue];
    
    if (currentId < 0) {
        currentId = [imgArray count] - 1;
    }
    [self loadCurrentImage];
}

- (IBAction)next:(id)sender {
    currentId = currentId + [[self.imageJumpSelect titleOfSelectedItem] integerValue];
    if (currentId >= [imgArray count]) {
        currentId = 0;
    }
    [self loadCurrentImage];
}

- (IBAction)purge:(id)sender {
    [dbManager selectAll];
}

// --------------- Usefull actions ------------------------------------

- (IBAction)imageJump:(id)sender {
}

- (IBAction)imageView:(id)sender {
}


@end
