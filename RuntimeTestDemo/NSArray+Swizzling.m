//
//  NSArray+Swizzling.m
//  RuntimeTestDemo
//
//  Created by GemShi on 2017/3/2.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "NSArray+Swizzling.h"

@implementation NSArray (Swizzling)

+(void)load
{
    //不能调用[super load]
    //因为实现原理就是对类的Dispatch Table进行操作，每进行一次Swizzling就交换一次SEL和IMP(可以理解为函数指针)，如果Swizzling被执行了多次，就相当于SEL和IMP被交换了多次。
    //Swizzling优点：能够统一的修改一些需求中突然并且要实现的东西
    //Swizzling缺点：多次交换可能会出现问题
    //为避免多次交换，使用dispatch_once函数内代码只被执行一次
    dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(swizzlingObjectAtIndex:));
        method_exchangeImplementations(fromMethod, toMethod);
    });
}

-(void)swizzlingObjectAtIndex:(NSInteger)index
{
    if (self.count-1 < index) {
        @try {
            return [self swizzlingObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"----------Crash----------%s",__func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    } else {
        return [self swizzlingObjectAtIndex:index];
    }
}

@end
