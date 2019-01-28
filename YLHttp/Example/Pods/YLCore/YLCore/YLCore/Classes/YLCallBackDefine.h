#ifndef YLCallBackDefine_h
#define YLCallBackDefine_h

#import <Foundation/Foundation.h>

typedef void (^CallBack)(void);
typedef void (^CallBackBool)(BOOL b);
typedef void (^CallBackInt)(NSInteger arg);
typedef void (^CallBackProgress)(CGFloat progress);

typedef void (^CallBackStr)(NSString *str);
typedef void (^CallBackStr2)(NSString *str1,NSString *str2);
typedef void (^CallBackStr3)(NSString *str1,NSString *str2,NSString *str3);
typedef void (^CallBackTuple)(NSInteger code,NSString *str);
typedef BOOL (^CallBackIsOk)(void);

typedef void (^CallBackSucc)(NSDictionary *JSON);
typedef void (^CallBackFail)(NSError *error);
typedef void (^CallBackURL)(NSURL *url);
#endif
