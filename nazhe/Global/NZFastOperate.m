//
//  NZFastOperate.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZFastOperate.h"

static NZFastOperate * NZFastOperateSharedObject = nil ;

@interface NZFastOperate()

@property (assign , nonatomic) BOOL isPushQuitPeoperty ;

@end

@implementation NZFastOperate

+ (instancetype) sharedObject
{
    if( NZFastOperateSharedObject == nil )
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NZFastOperateSharedObject = [[[self class] alloc] init] ;
        });
    };
    return NZFastOperateSharedObject ;
}

- (id) init
{
    self = [super init] ;
    
    if( self )
    {

    }
    
    return self ;
}



- (id) createInstanceStoryboardName:(NSString *)storyboardName bundle:(NSBundle*)bundle
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle] ;
    id theInstance = [storyboard instantiateInitialViewController] ;
    return theInstance ;
}

- (BOOL) isLogin
{
    return [self judgeIsLogin] ;
}



#pragma mark -
#pragma mark -
#pragma mark - private
#pragma mark -

- (BOOL) judgeIsLogin
{
    NZUser *user = [NZUserManager sharedObject].user ;
    
    if(user.userId && [[user.userId trim] isNotEqualsToString:emptyString] )
    {
        return YES ; // 用户登录
    }
    
    return  NO ;
}

@end
