//
//  FriendsService.m
//  UploadImageDemo
//
//  Created by Developer on 10/01/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "FriendsService.h"
#import "WebConstants.h"
#import "Parser.h"

#define kServerPagingLimit 10


@implementation FriendsService

-(void)getFriendListOnUserId:(NSString *)userID andPageNo:(int)pageNo{
    int skip = pageNo * kServerPagingLimit;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@id=%@&skip=%d&take=%d",getFriendList,userID,skip,kServerPagingLimit]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    self.request.tag=1;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    
    
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.request setShouldContinueWhenAppEntersBackground:YES];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:30];
    [self.request startAsynchronous];
}

#pragma mark - Reponse delegate

-(void)requestFinishedWithError:(ASIHTTPRequest *)theRequest
{
    NSError *error = [theRequest error];
    if(error.code == 1){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"There is no active internet connection. Please check your connection and try again." forKey:NSLocalizedDescriptionKey];
        NSError *errorNoNetwork = [NSError errorWithDomain:@"Error" code:122 userInfo:details];
        error = errorNoNetwork;
        
    }

    
    [self.delegate request:self didFailWithError:error];
}

-(void)requestFinishedSuccessfully:(ASIHTTPRequest *)theRequest
{
    NSData *reponseData = [theRequest responseData];
    if (theRequest.tag==1){
        // Image upload status
        NSError *error;
        
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseFriendListData:reponseData andError:&error];
        
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
        
    }
}

@end
