#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (id)safeObjectForKey:(NSString *)key;

- (void)safeSetValue:(id)object forKey:(id)key;

- (id)objectForKeyCustom:(id)aKey;

- (id)safeKeyForValue:(id)value;

@end
