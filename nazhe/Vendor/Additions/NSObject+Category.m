//
//  NSObject+Category.m
//  自己的扩张类
//
//  Created by mac iko on 13-9-19.
//  Copyright (c) 2013年 mac iko. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>

@implementation NSObject (Category)

+ (NSString *)classString
{
    return NSStringFromClass([self class]);
}

- (NSString *)classString
{
    return NSStringFromClass([self class]);
}


- (void)associateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weakAssoicateVaule:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)accociatedVauleForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}


- (BOOL)isVauleForKeyPath:(NSString *)keyPath equalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        id objectValue = [self valueForKeyPath:keyPath];
        return ([objectValue isEqual:value] || ((objectValue == nil) && (value == nil)));
    }
    return NO;
}

- (BOOL)isVauleForKeyPath:(NSString *)keyPath identicalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        return ([self valueForKeyPath:keyPath] == value);
    }
    return NO;
}

+ (NSDictionary *)propertyAttributes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int count = 0;
    objc_property_t *properies = class_copyPropertyList(self, &count);
    
    for (int i = 0  ; i < count; i ++)
    {
        objc_property_t property = properies[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [dictionary setObject:attribute forKey:name];
    }
    free(properies);
    
    if ([dictionary count] > 0) {
        return dictionary;
    }
    return nil;
}

- (void)removeNulls
{
    //do nothing
}
@end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSMutableArray (ZGRemoveNulls)

- (void)removeNulls
{
    [self removeObject:[NSNull null]];
    for (NSObject *child in self) {
        [child removeNulls];
    }
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSMutableDictionary (ZGRemoveNulls)

- (void)removeNulls
{
    NSNull *null = [NSNull null];
    for (NSObject *key in self.allKeys) {
        NSObject *value = self[key];
        if (value == null) {
            [self removeObjectForKey:key];
        }
        else{
            [value removeNulls];
        }
    }
}
@end