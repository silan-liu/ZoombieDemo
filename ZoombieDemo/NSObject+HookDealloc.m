//
//  NSObject+HookDealloc.m
//  ZoombieDemo
//
//  Created by liusilan on 2017/12/29.
//  Copyright © 2017年 douyu. All rights reserved.
//

#import "NSObject+HookDealloc.h"
#import <objc/runtime.h>
#import "ZoombieObject.h"

NSString *Zoombie_Class_Prefix = @"Zoombie_";

@implementation NSObject (HookDealloc)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(my_dealloc);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzledDealloc {
    // 指向固定的类，原有类名存储在关联对象中
    NSString *originClassName = NSStringFromClass([self class]);
    objc_setAssociatedObject(self, "OrigClassNameKey", originClassName, OBJC_ASSOCIATION_COPY_NONATOMIC);

    object_setClass(self, [ZoombieObject class]);
}

- (void)my_dealloc {
    // 指向动态生成的类，用Zoombie拼接原有类名
    NSString *className = NSStringFromClass([self class]);

    NSString *zombieClassName = [Zoombie_Class_Prefix stringByAppendingString: className];
    
    Class zombieClass = NSClassFromString(zombieClassName);
    if(zombieClass) return;
    
    zombieClass = objc_allocateClassPair([NSObject class], [zombieClassName UTF8String], 0);
    
    objc_registerClassPair(zombieClass);
    class_addMethod([zombieClass class], @selector(forwardingTargetForSelector:), (IMP)forwardingTargetForSelector, "@@:@");

    object_setClass(self, zombieClass);
}

id forwardingTargetForSelector(id self, SEL _cmd, SEL aSelector) {
    NSString *className = NSStringFromClass([self class]);
    NSString *realClass = [className stringByReplacingOccurrencesOfString:Zoombie_Class_Prefix withString:@""];
    NSLog(@"[%@ %@] message sent to deallocated instance %@", realClass, NSStringFromSelector(aSelector), self);
    abort();
}

@end
