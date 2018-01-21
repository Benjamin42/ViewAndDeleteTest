//
//  DatabaseManager.h
//  Test
//
//  Created by Clement on 20/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject {
    sqlite3 *database;
    NSString *path;
}

- (id) initWithPath:(NSString *) aPath;

- (void) updateLine: (NSString *) fileName, BOOL toDelete;

- (void) selectAll;

- (BOOL) exists: (NSString *) fileName;

@end
