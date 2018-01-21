//
//  ImageObject.h
//  Test
//
//  Created by Clement on 14/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject
{
    NSURL *url;
    BOOL toDelete;
}

- (id) initWithPath:(NSString *) aPath;
- (id) initWithURL:(NSURL *) aUrl;

- (void) switchToDelete;

- (NSURL *) getUrl;
- (BOOL) getToDelete;
- (NSString *) getFileName;

@end
