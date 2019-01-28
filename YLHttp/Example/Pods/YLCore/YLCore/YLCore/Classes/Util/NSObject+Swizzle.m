#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)
+ (void)overrideInstanceMethod:(SEL)origSelector withInstanceMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    if (!originalMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSelector), [self class]);
        return;
    }

    Method overrideMethod = class_getInstanceMethod(class, newSelector);
    if (!overrideMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(newSelector), [self class]);
        return;
    }
    
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(overrideMethod),
                                        method_getTypeEncoding(overrideMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_setImplementation(originalMethod, class_getMethodImplementation(self, newSelector));
    }
}

+ (void)overrideClassMethod:(SEL)origSelector withClassMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, origSelector);
    Method overrideMethod = class_getClassMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(overrideMethod),
                                        method_getTypeEncoding(overrideMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_setImplementation(originalMethod, class_getMethodImplementation(self, newSelector));
    }
}


+ (void)exchangeInstanceMethod:(SEL)origSelector withInstanceMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)exchangeClassMethod:(SEL)origSelector withClassMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, origSelector);
    Method swizzledMethod = class_getClassMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
