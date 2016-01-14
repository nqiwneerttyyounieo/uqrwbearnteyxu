//
//  UserModel.h
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 12/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject

@property (readwrite, nonatomic) NSString *strUserId;
@property (strong, nonatomic) NSString *strAuthToken;
@property (readwrite, nonatomic) NSString *strUserName;
@property (readwrite, nonatomic) NSString *strEmailID;
@property (readwrite, nonatomic) NSString *strBirthdate;
@property (readwrite, nonatomic) NSString *strGender;
@property (readwrite, nonatomic) NSString *strRecidence;

@property (readwrite, nonatomic) UIImage *imgProfile;
@property (readwrite, nonatomic) NSString *strClientUserName;
@property (readwrite, nonatomic) NSString *strProfileURL;
@property (readwrite, nonatomic) NSString *strProfileURLThumb;

@end
