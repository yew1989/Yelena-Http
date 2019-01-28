#import "NSArray+Category.h"
#import "NSMutableArray+Safe.h"

@implementation NSArray (Category)

- (NSString *)transToJSONString
{
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}

-(NSArray*)jion:(NSArray*)newArray {
    NSMutableArray *tmp = [[NSMutableArray alloc]initWithArray:self];
    for (id obj in newArray) {
        [tmp safeAddObject:obj];
    }
    return (NSArray*)tmp;
}

@end
