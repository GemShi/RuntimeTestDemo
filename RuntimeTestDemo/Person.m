//
//  Person.m
//  RuntimeTestDemo
//
//  Created by GemShi on 2017/2/25.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "Person.h"

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

//动态添加方法的时候需要添加的方法
//如果当一个类被调用了一个没有实现的方法，就会来到这里处理
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    /**
     1.cls:类类型
     2.name:方法标号
     3.imp:方法的实现，函数指针，是指向一个函数的
     4.types:方法类型
     */
    if (sel == @selector(talk)) {
        class_addMethod([Person class], sel, (IMP)talk, "v");
    }else if (sel == @selector(talk:)){
        class_addMethod([Person class], sel, (IMP)talk1, "v@:@");
    }
    
    return [super resolveInstanceMethod:sel];
}

+(BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"%@",NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

void talk(){
    NSLog(@"talking");
}

void talk1(id sel, SEL _cmd, id obj){
    NSLog(@"talking%@",obj);
}

@end
