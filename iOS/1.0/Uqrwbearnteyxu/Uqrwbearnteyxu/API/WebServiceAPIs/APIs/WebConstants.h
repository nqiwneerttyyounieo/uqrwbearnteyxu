//
//  WebConstants.h
//  UploadImageDemo
//
//  Created by Developer on 10/01/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#ifndef WebConstants_h
#define WebConstants_h


#define baseURL @"http://5.189.161.31"

#define loginURL [NSString stringWithFormat:@"%@/%@",baseURL,@"token?"]
#define registerURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/Register"]
#define forgotPasswordURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/ForgotPassword"]
#define makeProfileURL [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Account/UpdateUser"]

#define getFriendList [NSString stringWithFormat:@"%@/%@",baseURL,@"api/Relationships/GetRelationships?"]


#endif /* WebConstants_h */
