//
//  FriendsService.h
//  UploadImageDemo
//
//  Created by Developer on 10/01/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "ASIFormDataRequest.h"

@interface FriendsService : NSObject
@property(nonatomic,readwrite)int tag;
@property(nonatomic,strong)id<WebServiceDelegate> delegate;
@property (strong, nonatomic) ASIFormDataRequest *requestform;
@property (strong, nonatomic) ASIHTTPRequest *request;


//shared instance
+ (FriendsService *)sharedInstance;

-(void)getFriendListOnUserId:(NSString *)userID andPageNo:(int)pageNo;


@end
