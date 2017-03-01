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
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(swizzlingObjectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
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
