//
//  NZUserManager.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/8/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZUserManager : NSObject

@property (nonatomic , strong) NZUser *user ;

@property (nonatomic , strong) NZRegistInformation *registInfo ;

+ (NZUserManager *)sharedObject ;

@end
