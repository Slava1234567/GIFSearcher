//
//  DownLoadManager.h
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManager : NSObject

- (void) resumeDownloadPreviewGit:( NSString*) urlName complition: (void(^)(NSData* data)) complition;

@end
