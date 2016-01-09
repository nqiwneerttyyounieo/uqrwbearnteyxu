//
//  UserModel.h
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 12/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (readwrite, nonatomic) NSString *strUserId;
@property (strong, nonatomic) NSString *strAuthToken;
@property (readwrite, nonatomic) NSString *strUserName;


@end
