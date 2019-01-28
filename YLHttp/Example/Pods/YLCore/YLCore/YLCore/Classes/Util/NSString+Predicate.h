#import <Foundation/Foundation.h>

@interface NSString (Predicate)

//有效的电话号码
- (BOOL) isValidMobileNumber;

//有效的真实姓名
- (BOOL) isValidRealName;

//是否只有中文
- (BOOL) isOnlyChinese;

//有效的验证码(根据自家的验证码位数进行修改)
- (BOOL) isValidVerifyCode;

//有效的银行卡号
- (BOOL) isValidBankCardNumber;

//有效的邮箱
- (BOOL) isValidEmail;

//有效的字母数字密码
- (BOOL) isValidAlphaNumberPassword;

//检测有效身份证
//15位
- (BOOL) isValidIdentifyFifteen;

//18位
- (BOOL) isValidIdentifyEighteen;

//限制只能输入数字
- (BOOL) isOnlyNumber;

@end
