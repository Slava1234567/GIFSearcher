//
//  DownLoadManager.m
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoadManager()

@property(strong,nonatomic) NSURLSession* session;

@end

@implementation DownLoadManager

- (NSURLSession*)session {
    
    if (!_session) {
        NSURLSessionConfiguration* conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:conf];
    }
    return _session;
}

- (void) resumeDownloadPreviewGit:( NSString*) urlName complition: (void(^)(NSData* data)) complition {
    
    NSURL* url = [NSURL URLWithString:urlName];
    
    NSURLSessionDownloadTask* task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData* data= [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                complition(data);
            }
        });
    }];
    [task resume];
}

@end
