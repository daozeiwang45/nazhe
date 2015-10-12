//
//  APITakePage.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/17.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "APITakePage.h"

@interface APITakePage ()

@property (nonatomic, strong) NZWebHandler *handler;

@property (nonatomic, strong) NZUser *user;

@end

@implementation APITakePage

- (id) init {
    self = [super init];
    if (self) {
        _handler = [[NZWebHandler alloc] init] ;
        
        _user = [NZUserManager sharedObject].user ;
    }
    return self;
}

- (NSDictionary *)getMyDeliveryAddress {
    
    NSString *userId = _user.userId;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 } ;
    NSDictionary *jsonDic = [NSDictionary dictionary];
    [_handler postURLStr:webMyDeliveryAddress postDic:parameters block:^(NSDictionary *retInfo, NSError *error) {
        
    }];
    
    return jsonDic;
    
}

@end
