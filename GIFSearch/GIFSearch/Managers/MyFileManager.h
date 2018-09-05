//
//  MyFileManager.h
//  GIFSearch
//
//  Created by Slava on 9/3/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFileManager : NSObject

- (NSString*) saveData:(NSData*)data title:(NSString*)title;
- (void) deletePath:(NSString*)path;

@end
