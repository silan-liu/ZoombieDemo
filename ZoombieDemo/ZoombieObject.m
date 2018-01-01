//
//  ZoombieObject.m
//  ZoombieDemo
//
//  Created by liusilan on 2017/12/29.
//  Copyright © 2017年 douyu. All rights reserved.
//

#import "ZoombieObject.h"
#import "StubProxy.h"
#import <objc/runtime.h>

@implementation ZoombieObject

// 任选一种
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"[%@ %@] message sent to deallocated instance %@", objc_getAssociatedObject(self, "OrigClassNameKey"), NSStringFromSelector(aSelector), self);

    StubProxy *stub = [[StubProxy alloc] init];
    if (![stub respondsToSelector:aSelector]) {
        Method method = class_getInstanceMethod([stub class], sel_registerName("stub"));
        class_addMethod([stub class], aSelector, method_getImplementation(method), method_getTypeEncoding(method));
    }
    return stub;
}

// 或者在forwardInvocation中获取相关信息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        sig = [StubProxy instanceMethodSignatureForSelector:@selector(stub)];
    }
    
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"[%@ %@] message sent to deallocated instance %@", objc_getAssociatedObject(self, "OrigClassNameKey"), NSStringFromSelector(anInvocation.selector), self);
}

@end
