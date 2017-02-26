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
    //指向本类遵循的所有协议（不遵循协议则获取不到）
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
    //获取指向方法的指针Method:成员方法
    Method *methods = class_copyMethodList([Person class], &count);
    for (int i = 0; i < count; i++) {
        //取出其中一个
        Method method = methods[i];
        //获取方法名
        SEL methodSel = method_getName(method);
        //将方法名转为C语言字符串
        const char *name = sel_getName(methodSel);
        //转化为OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        //获取参数个数
        int arguements = method_getNumberOfArguments(method);
        NSLog(@"%d == %@  %d",i,methodName,arguements);
    }
    //释放
    free(methods);
}

#pragma mark - 获取一个类的成员属性名
-(void)getAttribute
{
    unsigned int count;
    //获取指向该类所有属性指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    for (int i = 0; i < count; i++) {
        //获取该类一个属性指针
        objc_property_t property = properties[i];
        //获取属性名称
        const char *name = property_getName(property);
        //转化为OC字符串
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    //释放
    free(properties);
    /*
     *class_copyPropertyList和class_copyIvarList区别：
     *class_copyPropertyList获取由@property声明的属性
     *class_copyIvarList获取所有的成员变量
     */
}

#pragma mark - 获取一个类的成员变量名
-(void)getMemberVariable
{
    unsigned int count;
    //获取成员变量结构体
    /*
     *关于&count的理解：
     *获取的成员变量以数组的形式返回，对count取地址传入表示将数组的个数放到这个地址的变量array.count = count;
     */
    Ivar *ivars = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //根据Ivar获取成员变量名称
        const char *name = ivar_getName(ivar);
        //将C字符串转化为OC字符串
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    //释放
    free(ivars);
}

@end
