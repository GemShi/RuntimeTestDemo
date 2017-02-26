//
//  Person.m
//  RuntimeTestDemo
//
//  Created by GemShi on 2017/2/25.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person()<NSCoding>

@end

@implementation Person

//解归档：遵循NSCoding协议，实现两个方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *proName = [NSString stringWithUTF8String:name];
        //解码
        NSString *proValue = [aDecoder decodeObjectForKey:proName];
        [self setValue:proValue forKey:proName];
    }
    free(properties);
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *proName = [NSString stringWithUTF8String:name];
        NSString *proValue = [self valueForKey:proName];
        //归档
        [aCoder encodeObject:proValue forKey:proName];
    }
    free(properties);
}

-(void)work
{
    NSLog(@"%s",__func__);
}
-(void)run
{
    NSLog(@"%s",__func__);
}
-(void)think
{
    NSLog(@"%s",__func__);
}

@end
