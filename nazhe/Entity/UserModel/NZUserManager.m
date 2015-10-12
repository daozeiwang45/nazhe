//
//  NZUserManager.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZUserManager.h"

static NZUserManager * NZUserManagerSharedObject = nil ;

@implementation NZUserManager

+(NZUserManager *) sharedObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NZUserManagerSharedObject = [[[NZUserManager class] alloc] init] ;
    });
    return NZUserManagerSharedObject ;
}

- (id)init
{
    self = [super init] ;
    if( self )
    {
        self.user = [[NZUser alloc] init] ;
        self.registInfo = [[NZRegistInformation alloc] init];
    }
    return self ;
}

@end
