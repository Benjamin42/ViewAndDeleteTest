//
//  DatabaseManager.m
//  Test
//
//  Created by Clement on 20/01/2018.
//  Copyright © 2018 AssuCorp. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

- (id) initWithPath:(NSString *) aPath {
    if (self = [super init]) {
        path = aPath;
        
        // On récupère ou on charge la BDD du répertoire
        NSString *databasePath = [path stringByAppendingString:@"/database.db"];
        
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            NSString *sql = @"CREATE TABLE IF NOT EXISTS files_to_delete (filename TEXT)";
            const char *sqlStatement = [sql cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_stmt *compileStatement;
            if (sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
                
            }
            if (sqlite3_step(compileStatement) != SQLITE_DONE) {
                NSLog(@"Save Error : %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(compileStatement);
        }
        //sqlite3_close(database);
        
        
    }
    return self;
}

- (void) updateLine: (NSString *) fileName, BOOL toDelete {
    const char *sqlStatement;
    fileName = [fileName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if (toDelete) {
        // On fait un INSERT
        sqlStatement = "INSERT INTO files_to_delete VALUES(?)";
    } else {
        // On fait un DELETE
        sqlStatement = "DELETE FROM files_to_delete WHERE filename =?";
    }
    
    sqlite3_stmt *compileStatement;
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(compileStatement, 1, [fileName UTF8String], -1, SQLITE_TRANSIENT);
    }
    if (sqlite3_step(compileStatement) != SQLITE_DONE) {
        NSLog(@"Save Error : %s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(compileStatement);
}

- (void) selectAll {
   
    const char *sqlStatement = "SELECT filename FROM files_to_delete";
    sqlite3_stmt *compileStatement;
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compileStatement) == SQLITE_ROW) {
            NSString *fileName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compileStatement, 0)];
            NSLog(@"Trouvé dans la base de donnée : %@", fileName);
        }
    }
    sqlite3_finalize(compileStatement);
}

- (BOOL) exists: (NSString *) fileName {
    
    const char *sqlStatement = "SELECT filename FROM files_to_delete WHERE filename = ?";
    sqlite3_stmt *compileStatement;
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(compileStatement, 1, [fileName UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(compileStatement) == SQLITE_ROW) {
            NSString *fileName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compileStatement, 0)];
            NSLog(@"Trouvé dans la base de donnée : %@", fileName);
            return TRUE;
        }
    }
    sqlite3_finalize(compileStatement);
    return FALSE;
}


@end
