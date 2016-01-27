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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@UserId=%@&skip=%d&take=%d",getFriendList,userID,skip,kServerPagingLimit]];
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


-(void)getAllUserList:(NSString *)userID andPageNo:(int)pageNo forSearchedText:(NSString *)text{
    int skip = pageNo * kServerPagingLimit;
    NSURL *url=nil;
    if(text.length){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@id=%@&skip=%d&take=%d&searchText=%@",searchFriendList,userID,skip,kServerPagingLimit,text]];

    }
    else{
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@id=%@&skip=%d&take=%d",searchFriendList,userID,skip,kServerPagingLimit]];
    }
    self.request = [ASIHTTPRequest requestWithURL:url];
    self.request.tag=2;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    
    
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.request setShouldContinueWhenAppEntersBackground:YES];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:30];
    [self.request startAsynchronous];
    
}
-(void)sendFriendRequestFromUserId:(NSString *)userID andTo:(NSString *)frUserID{
    NSURL *url=[NSURL URLWithString:addFriendRequest];
    self.requestform = [ASIFormDataRequest requestWithURL:url];
    self.requestform.tag=3;
    //  CookieManager *p=[[CookieManager alloc]init];
    //  [self.requestform setRequestCookies:[NSMutableArray arrayWithObject:[p getCookie]]];
    
    [self.requestform setPostValue:userID forKey:@"UserId"];
    [self.requestform setPostValue:frUserID forKey:@"FriendId"];
    [self.requestform setPostValue:@"1" forKey:@"RelationshipStatus"];
    [self.requestform setPostValue:userID forKey:@"ActionUserId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [self.requestform setPostValue:[formatter stringFromDate:[NSDate date]] forKey:@"Created"];

    
    [self.requestform setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.requestform setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.requestform setShouldContinueWhenAppEntersBackground:YES];
    [self.requestform setDelegate:self];
    [self.requestform setTimeOutSeconds:30];
    [self.requestform startAsynchronous];
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
    else if (theRequest.tag==2){
        NSError *error;
        
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseSearchFriendListData:reponseData andError:&error];
        
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
    }
    else if (theRequest.tag==3){
        // Image upload status
        NSError *error;
        
        
        Parser *parser=[[Parser alloc]init];
        NSMutableArray *array=[parser parseSendFriendRequestData:reponseData andError:&error];
        
        if(error){
            [self.delegate request:self didFailWithError:error];
        }
        else{
            [self.delegate request:self didSucceedWithArray:array];
        }
        
    }
}

@end
