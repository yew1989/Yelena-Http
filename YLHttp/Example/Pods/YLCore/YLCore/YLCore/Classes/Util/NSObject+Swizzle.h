#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

//覆盖实例方法
+ (void)overrideInstanceMethod:(SEL)origSelector withInstanceMethod:(SEL)newSelector;

//覆盖类方法
+ (void)overrideClassMethod:(SEL)origSelector withClassMethod:(SEL)newSelector;


//拦截实例方法
+ (void)exchangeInstanceMethod:(SEL)origSelector withInstanceMethod:(SEL)newSelector;

//拦截类方法
+ (void)exchangeClassMethod:(SEL)origSelector withClassMethod:(SEL)newSelector;

@end
