#import <Foundation/Foundation.h>

@interface NSArray (Category)
// 数组转成json 字符串
- (NSString *)transToJSONString;
// 拼接
-(NSArray*)jion:(NSArray*)newArray;
@end
