//
//  Person.h
//  RuntimeTestDemo
//
//  Created by GemShi on 2017/2/25.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonDelegate <NSObject>

-(void)personDelegateMethod;

@end

@interface Person : NSObject

@property(nonatomic,weak)id<PersonDelegate>delegate;

#pragma mark - 属性
@property(nonatomic,assign)int age;
@property(nonatomic,assign)int height;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *job;
@property(nonatomic,copy)NSString *education;

#pragma mark - 方法
-(void)work;
-(void)run;
-(void)think;

@end
