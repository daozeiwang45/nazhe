//
//  FileDetail.m
//  baizijia
//
//  Created by Brother on 15/4/20.
//  Copyright (c) 2015年 com.mocoo. All rights reserved.
//

#import "FileDetail.h"

@implementation FileDetail

+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data {
    FileDetail *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    return file;
}

@end
