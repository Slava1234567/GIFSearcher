//
//  MyFileManager.m
//  GIFSearch
//
//  Created by Slava on 9/3/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

#import "MyFileManager.h"

@implementation MyFileManager


- (NSString*) saveData:(NSData*)data title:(NSString*)title {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* last = [NSString stringWithFormat:@"Gif %@",title];
    NSString* path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [path1 stringByAppendingFormat:@"%@",last];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:data attributes:nil];
    }
    return path;
}

- (void) deletePath:(NSString*)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
