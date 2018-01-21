//
//  ImageObject.m
//  Test
//
//  Created by Clement on 14/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

- (id) initWithPath:(NSString *) aPath {
    if (self = [super init]) {
        url = [[NSURL alloc] initWithString:aPath];
        toDelete = FALSE;
    }
    return self;
}

- (id) initWithURL:(NSURL *) aUrl {
    if (self = [super init]) {
        url = aUrl;
        toDelete = FALSE;
    }
    return self;
}

- (void) switchToDelete {
    toDelete = !toDelete;
}

- (NSURL *)getUrl {
    return url;
}

- (BOOL)getToDelete {
    return toDelete;
}

- (NSString *) getFileName {
    return [url lastPathComponent];
}
@end
