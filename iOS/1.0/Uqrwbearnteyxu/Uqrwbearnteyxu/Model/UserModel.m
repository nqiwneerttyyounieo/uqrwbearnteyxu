//
//  UserModel.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 12/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.strUserId forKey:@"userid"];
    [encoder encodeObject:self.strUserName forKey:@"username"];
    [encoder encodeObject:self.strAuthToken forKey:@"authtoken"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.strUserId = [decoder decodeObjectForKey:@"userid"];
        self.strUserName = [decoder decodeObjectForKey:@"username"];
        self.strAuthToken = [decoder decodeObjectForKey:@"authtoken"];
    }
    return self;
}

@end
