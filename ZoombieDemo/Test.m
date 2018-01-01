//
//  Test.m
//  ZoombieDemo
//
//  Created by liusilan on 2017/12/29.
//  Copyright © 2017年 douyu. All rights reserved.
//

#import "Test.h"
#import "ZoombieObject.h"
#import <objc/runtime.h>

@implementation Test

- (void)test {
    NSLog(@"test");
}

- (void)dealloc {
    NSLog(@"dealloc");
}
@end
