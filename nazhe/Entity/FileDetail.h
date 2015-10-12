//
//  FileDetail.h
//  baizijia
//
//  Created by Brother on 15/4/20.
//  Copyright (c) 2015年 com.mocoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDetail : NSObject

@property(strong,nonatomic) NSString *name;

@property(strong,nonatomic) NSData *data;

+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;

@end
