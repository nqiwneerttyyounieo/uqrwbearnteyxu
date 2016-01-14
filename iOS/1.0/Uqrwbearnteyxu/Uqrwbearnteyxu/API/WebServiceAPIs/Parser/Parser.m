//
//  Parser.m
//  WCI-Web
//
//  Created by Rahul N. Mane on 10/04/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "Parser.h"
#import "WebConstants.h"
#import "NSNull+JSON.h"


#define ErrorDomain @"UrbanEx"

#define jsonError @"Oops... something went wrong !!!"

#import "UserModel.h"
#import "FriendModel.h"

@implementation Parser

-(NSMutableArray *)parseRegisterData:(NSData *)responseData andError:(NSError **)error{
    NSMutableArray *arrayToReturn;

    NSError *errors;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:NSJSONReadingAllowFragments error:&errors];
    

    if(!errors){
        
            NSLog(@"Json : %@",json);
        if([[json valueForKey:@"Status"]integerValue]==1){
            arrayToReturn=[[NSMutableArray alloc]init];
            NSDictionary *dict=[json valueForKey:@"data"];
            
            return arrayToReturn;
        }
        else{
            //NSDictionary *errorDict=[json valueForKey:@"ErrorMessage"];
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[json valueForKey:@"ErrorMessage"] forKey:NSLocalizedDescriptionKey];
            int ErroCode =[[json valueForKey:@"ErrorCode"] intValue];
            *error = [NSError errorWithDomain:ErrorDomain code:ErroCode userInfo:details];
            return nil;
            
        }
    }
    else{
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:jsonError forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ErrorDomain code:122 userInfo:details];
        return nil;
    }
    return arrayToReturn;
}

-(NSMutableArray *)parseLoginData:(NSData *)responseData andError:(NSError **)error{
    NSMutableArray *arrayToReturn;

    NSError *errors;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:NSJSONReadingAllowFragments error:&errors];
    if(!errors){
                    NSLog(@"Json : %@",json);
        NSString *strError = [json valueForKey:@"error"];

        if(strError.length){
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:strError forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:ErrorDomain code:122 userInfo:details];
            return nil;
        }
        else{
            
            arrayToReturn = [[NSMutableArray alloc]init];
            
            UserModel *model = [[UserModel alloc] init];
            model.strUserId = [json valueForKey:@"UserId"];
            model.strAuthToken = [json valueForKey:@"access_token"];
            model.strEmailID = [json valueForKey:@"Email"];
            model.strClientUserName = [json valueForKey:@"ClientUserName"];
            NSString *yourVariable = ([[json valueForKey:@"ProfilePicURL"] isEqual:[NSNull null]]) ? @"" : [json valueForKey:@"ProfilePicURL"];
            
            model.strProfileURL = [NSString stringWithFormat:@"%@/%@",baseURL,yourVariable];

            NSString *yourVariable2 = ([[json valueForKey:@"ProfilePicURL"] isEqual:[NSNull null]]) ? @"" : [json valueForKey:@"ProfilePicURL"];

            model.strProfileURLThumb = [NSString stringWithFormat:@"%@/%@",baseURL,yourVariable2];

            [arrayToReturn addObject:model];
            
            return arrayToReturn;
        }
    }
    else{
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:jsonError forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ErrorDomain code:111 userInfo:details];
        return nil;
    }
    return arrayToReturn;
}

-(NSMutableArray *)parseForgotPasswordData:(NSData *)responseData andError:(NSError **)error{
    NSMutableArray *arrayToReturn;
    
    NSError *errors;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:NSJSONReadingAllowFragments error:&errors];
    if(!errors){
                    NSLog(@"Json : %@",json);
        if([[json valueForKey:@"Status"]integerValue]==1){
            arrayToReturn=[[NSMutableArray alloc]init];
            NSDictionary *dict=[json valueForKey:@"data"];
            
            return arrayToReturn;
        }
        else{
            //NSDictionary *errorDict=[json valueForKey:@"ErrorMessage"];
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[json valueForKey:@"ErrorMessage"] forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:ErrorDomain code:122 userInfo:details];
            return nil;
            
        }

    }
    else{
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:jsonError forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ErrorDomain code:111 userInfo:details];
        return nil;
    }
    return arrayToReturn;
    
}
-(NSMutableArray *)parseMakeProfile:(NSData *)responseData andError:(NSError **)error{
    NSMutableArray *arrayToReturn;
    NSError *errors;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:NSJSONReadingAllowFragments error:&errors];
    if(!errors){
                    NSLog(@"Json : %@",json);
        if([[json valueForKey:@"Status"]integerValue]==1){
            arrayToReturn=[[NSMutableArray alloc]init];
            NSDictionary *dict=[json valueForKey:@"Data"];
            NSDictionary *userDict = [dict valueForKey:@"User"];
            
            UserModel *model = [[UserModel alloc] init];
            model.strUserId = [userDict valueForKey:@"UserId"];
            model.strEmailID = [userDict valueForKey:@"Email"];
            model.strClientUserName = [userDict valueForKey:@"ClientUserName"];

            model.strClientUserName = [userDict valueForKey:@"ClientUserName"];
            model.strProfileURL =  [NSString stringWithFormat:@"%@/%@",baseURL,[userDict valueForKey:@"ProfilePicURL"]];
            if([model.strProfileURL isEqualToString:baseURL]){
                model.strProfileURL = @"";
            }

            
            model.strProfileURLThumb = [NSString stringWithFormat:@"%@/%@",baseURL,[userDict valueForKey:@"ThumbImgPath"]];
            if([model.strProfileURLThumb isEqualToString:baseURL]){
                model.strProfileURLThumb = @"";
            }

            [arrayToReturn addObject:model];
            return arrayToReturn;
        }
        else{
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[json valueForKey:@"ErrorMessage"] forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:ErrorDomain code:122 userInfo:details];
            return nil;
            
        }
    }
    else{
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"dasd" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"asdas" code:122 userInfo:details];
        return nil;
    }
    return arrayToReturn;
}


#pragma mark - Friends service 

-(NSMutableArray *)parseFriendListData:(NSData *)responseData andError:(NSError **)error{
    NSMutableArray *arrayToReturn;
    
    NSError *errors;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:NSJSONReadingAllowFragments error:&errors];
    if(!errors){
                    NSLog(@"Json : %@",json);
        if([[json valueForKey:@"Status"]integerValue]==1){
            arrayToReturn=[[NSMutableArray alloc]init];
            NSDictionary *dict=[json valueForKey:@"Data"];
            
            NSMutableArray *friendArray = [dict valueForKey:@"FriendRequests"];
            
            for (int k=0; k<friendArray.count; k++) {
                NSDictionary *dict = [friendArray objectAtIndex:k];
                
                FriendModel *model = [[FriendModel alloc]init];
                model.strBithdate = [dict valueForKey:@"BirthDate"];
                                model.strEmail = [dict valueForKey:@"Email"];
                                model.strFirstName = [dict valueForKey:@"FirstName"];
                                model.strFriendsCount = [dict valueForKey:@"FriendsCount"];
                                model.strGender = [dict valueForKey:@"Gender"];
                                model.strUserID = [dict valueForKey:@"Id"];
                                model.strLastName = [dict valueForKey:@"LastName"];
                                model.strMutualFriends = [dict valueForKey:@"MeetUpCount"];
                                model.strMutualFriends = [dict valueForKey:@"MutualFriends"];
                                model.strMutualSports = [dict valueForKey:@"MutualSports"];
                                model.strPhoneNumber = [dict valueForKey:@"PhoneNumber"];
                                model.strProfilePicURL = [NSString stringWithFormat:@"%@/%@",baseURL,[dict valueForKey:@"ProfilePicURL"]];
                if([model.strProfilePicURL isEqualToString:baseURL]){
                    model.strProfilePicURL = @"";
                }

                                model.strResidence = [dict valueForKey:@"Residence"];
                
                                model.strThumbImgPath = [NSString stringWithFormat:@"%@/%@",baseURL,[dict valueForKey:@"ThumbImgPath"]];

                if([model.strThumbImgPath isEqualToString:baseURL]){
                    model.strThumbImgPath = @"";
                }

                
                model.strUserName = [dict valueForKey:@"UserName"];
model.strClientUserName = [dict valueForKey:@"ClientUserName"];
                
                model.isRequestFriend = YES;
                [arrayToReturn addObject:model];
                
                
                
            }
            NSMutableArray *peopleYouMayKnowArray = [dict valueForKey:@"PeopleYouMayKnow"];
            for (int k=0; k<peopleYouMayKnowArray.count; k++) {
                NSDictionary *dict = [peopleYouMayKnowArray objectAtIndex:k];
                
                FriendModel *model = [[FriendModel alloc]init];
                model.strBithdate = [dict valueForKey:@"BirthDate"];
                model.strEmail = [dict valueForKey:@"Email"];
                model.strFirstName = [dict valueForKey:@"FirstName"];
                model.strFriendsCount = [dict valueForKey:@"FriendsCount"];
                model.strGender = [dict valueForKey:@"Gender"];
                model.strUserID = [dict valueForKey:@"Id"];
                model.strLastName = [dict valueForKey:@"LastName"];
                model.strMutualFriends = [dict valueForKey:@"MeetUpCount"];
                model.strMutualFriends = [dict valueForKey:@"MutualFriends"];
                model.strMutualSports = [dict valueForKey:@"MutualSports"];
                model.strPhoneNumber = [dict valueForKey:@"PhoneNumber"];
                model.strProfilePicURL = [NSString stringWithFormat:@"%@/%@",baseURL,[dict valueForKey:@"ProfilePicURL"]];
                if([model.strProfilePicURL isEqualToString:baseURL]){
                    model.strProfilePicURL = @"";
                }
                
                

                model.strResidence = [dict valueForKey:@"Residence"];
                
                model.strThumbImgPath = [NSString stringWithFormat:@"%@/%@",baseURL,[dict valueForKey:@"ThumbImgPath"]];
                if([model.strThumbImgPath isEqualToString:baseURL]){
                    model.strThumbImgPath = @"";
                }

                model.strUserName = [dict valueForKey:@"UserName"];
                model.isRequestFriend = NO;
model.strClientUserName = [dict valueForKey:@"ClientUserName"];
                
                [arrayToReturn addObject:model];
            }
            
            return arrayToReturn;
        }
        else{
            //NSDictionary *errorDict=[json valueForKey:@"ErrorMessage"];
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[json valueForKey:@"ErrorMessage"] forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:ErrorDomain code:122 userInfo:details];
            return nil;
            
        }
        
    }
    else{
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:jsonError forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ErrorDomain code:111 userInfo:details];
        return nil;
    }
    return arrayToReturn;
}

@end
