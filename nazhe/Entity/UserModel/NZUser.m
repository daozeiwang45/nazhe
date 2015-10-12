//
//  NZUser.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZUser.h"

@implementation NZUser

- (void)setUserId:(NSString *)userId {
    
    _userId = userId ? userId : emptyString ;
    
    _userId = [NSString stringWithFormat:@"%@",_userId] ;
}

- (void) clear
{
    self.userId = nil ;
    self.token = nil;
    self.pushToken = nil;
    self.phone = nil;
}

@end

@implementation NZRegistInformation

- (void) clear
{
    self.phone = nil ;
    self.password = nil;
    self.code = nil;
    self.recommendPhone = nil;
    self.nickName = nil;
    self.sex = nil;
    self.birthday = nil;
    self.province = nil;
    self.city = nil;
    self.hometown = nil;
    self.job = nil;
    self.name = nil;
    self.address = nil;
    self.headImg = nil;
    self.pushToken = nil;
}

@end
