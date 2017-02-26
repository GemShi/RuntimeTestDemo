//
//  ViewController.m
//  RuntimeTestDemo
//
//  Created by GemShi on 2017/2/25.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()<PersonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取一个类的成员变量名
//    [self getMemberVariable];
    
    //获取一个类的成员属性名
//    [self getAttribute];
    
    //获取一个类的全部方法
//    [self getAllMethod];
    
    //获取一个类的代理方法
//    [self getProtocol];
    
    //runtime实现解归档
    Person *p = [[Person alloc]init];
    p.name = @"GemShi";
    p.age = 24;
    p.job = @"iOS-Developer";
    p.height = 169;
    p.sex = @"female";
    p.education = @"bachelor";
    NSString *path = [NSString stringWithFormat:@"%@/archiver",NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@  %@",path,person);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取一个类的代理方法
-(void)getProtocol
{
    unsigned int count;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i++) {
        Protocol *pro = protocols[i];
        const char *name = protocol_getName(pro);
        NSString *proName = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,proName);
    }
    free(protocols);
}

-(void)personDelegateMethod
{
    
}

#pragma mark - 获取一个类的全部方法
-(void)getAllMethod
{
    unsigned int count;
    Method *methods = class_copyMethodList([Person class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodSel = method_getName(method);
        const char *name = sel_getName(methodSel);
        NSString *methodName = [NSString stringWithUTF8String:name];
        int arguements = method_getNumberOfArguments(method);
        NSLog(@"%d == %@  %d",i,methodName,arguements);
    }
    free(methods);
}

#pragma mark - 获取一个类的成员属性名
-(void)getAttribute
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    free(properties);
}

#pragma mark - 获取一个类的成员变量名
-(void)getMemberVariable
{
    unsigned int count;
    Ivar *ivars = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    free(ivars);
}

@end
