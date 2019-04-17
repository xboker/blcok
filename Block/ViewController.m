//
//  ViewController.m
//  Block
//
//  Created by xiekunpeng on 2019/4/17.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "ViewController.h"
#import "Man.h"


typedef NSString* (^StrBlock)(NSString *str);

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger      index;
@property (nonatomic, copy)   StrBlock       strBlock;
@property (nonatomic, strong) Man            *bigMan;
@end

///全局变量
NSInteger globalCount = 11;
///静态全局变量
static NSInteger staticGlobalCount = 22;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 2;
    
    
    /*----------------截获变量---------------*/
    //局部变量:  基本数据类型
    [self block1];
    ///局部变量: 对象
    [self block2];
    ///静态局部变量
    [self block3];
    ///全局变量
    [self block4];
    ///全局静态变量
    [self block5];
    ///block中对对象的使用
    [self testBlcok1];
    
    /*----------------循环引用---------------*/
    ///循环引用---自循环
    [self circleReferenceSelf];
    ///循环引用---自循环--解决方案
    [self circleReferenceSelf];
    ///循环引用---多循环
    [self bigCircleReference];
    ///循环引用---多循环--解决方案
    [self notBigCircleReference];
    
}

///局部变量:  基本数据类型
- (void)block1 {
    NSInteger count = 10;
    NSInteger (^Block)(NSInteger) = ^NSInteger(NSInteger num){
        return count * num;
    };
    count = 50;
    NSLog(@"局部变量:  基本数据类型  结果是: %ld", Block(2));
    
    __block NSInteger count1 = 10;
    NSInteger (^Block1)(NSInteger) = ^NSInteger(NSInteger num){
        return count1 * num;
    };
    count1 = 50;
    NSLog(@"用__block修饰的局部变量: 基本数据类型  结果是: %ld", Block1(2));
}

///局部变量: 对象
- (void)block2 {
    __block  Man *man = [[Man alloc] init];
    NSString* (^Block)(NSString*) = ^NSString* (NSString *name){
        man.name = name;
        return man.name;
    };
    man.name = @"Lisi";
    NSLog(@"局部变量: 对象  结果是: %@", Block(@"Zhangsan"));
}


///静态局部变量
- (void)block3 {
    static NSInteger count = 9;
    NSInteger (^Block)(NSInteger) = ^NSInteger(NSInteger num){
        return count * num;
    };
    count = 10;
    NSLog(@"静态局部变量   结果是: %ld", Block(2));
}


///全局变量
- (void)block4 {
    //NSInteger globalCount = 11;
    NSInteger (^Block)(NSInteger) = ^NSInteger(NSInteger num){
        return globalCount * num;
    };
    globalCount = 10;
    NSLog(@"全局变量   结果是: %ld", Block(2));
}


///全局静态变量
- (void)block5 {
//    static const NSInteger staticGlobalCount = 22;
    NSInteger (^Block)(NSInteger) = ^NSInteger(NSInteger num){
        return staticGlobalCount * num;
    };
    staticGlobalCount = 33;
    NSLog(@"全局静态变量   结果是: %ld", Block(2));
}




///block中对对象的使用
- (void)testBlcok1 {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    void(^Block)(void) = ^void(void){
        ///这里是对arr的使用, 而不是赋值, 所以不用__block修饰;
        [arr addObject:@"1"];
    };
    Block();
    NSLog(@"block中对对象的使用   数组中内容为:  %@", arr);
    
//    NSMutableArray *arr1 = nil;
//    void(^Block1)(void) = ^void(void){
//        ///这里是对arr的赋值, 要用__block修饰, 不然会报错;
//        arr = [NSMutableArray arrayWithCapacity:0];
//
//    };
//    Block1();
    
}



///循环引用---自循环
- (void)circleReferenceSelf {
    _array = [NSMutableArray arrayWithCapacity:0];
    [_array addObject:@"Test"];
    _strBlock = ^NSString*(NSString *str) {
        NSString *resultStr = [NSString stringWithFormat:@"result is : %@", _array.firstObject];
        return resultStr;
    };
    NSLog(@"%@", _strBlock(@"HongKong"));
}


///循环引用---自循环--解除方案
- (void)notCircleReferenceSelf {
    _array = [NSMutableArray arrayWithCapacity:0];
    [_array addObject:@"Test"];
    __weak NSMutableArray *tempArr = _array;
    _strBlock = ^NSString*(NSString *str) {
        NSString *resultStr = [NSString stringWithFormat:@"result is : %@", tempArr.firstObject];
        return resultStr;
    };
    NSLog(@"%@", _strBlock(@"HongKong"));
}



///循环引用----多循环引用(类似)
- (void)bigCircleReference {
    __block ViewController *weakSelf = self;
    _bigMan = [[Man alloc] init];
    _bigMan.intBlock = ^NSInteger(NSInteger num) {
        return weakSelf.index * num;
    };
    NSLog(@"会多循环引用:  %ld", _bigMan.intBlock(100));
}

///循环引用----多循环引用--解决方案
- (void)notBigCircleReference {
    __block ViewController *weakSelf = self;
    _bigMan = [[Man alloc] init];
    _bigMan.intBlock = ^NSInteger(NSInteger num) {
        NSInteger temp = weakSelf.index * num;
        weakSelf = nil;
        return temp;

    };
    NSLog(@"不会多循环引用:  %ld", _bigMan.intBlock(100));
}



@end
