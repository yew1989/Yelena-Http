#ifndef YLMacro_h
#define YLMacro_h

#pragma mark -
#pragma mark 快速工具

// 获取图片
#define IMAGE(A)         [UIImage imageNamed:A]
// 数字转字符串
#define FORMAT(f, ...)   [NSString stringWithFormat:f, ## __VA_ARGS__]
// 空格清除
#define TRIM(S)          [S stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
// 国际化
#define LS(key)          NSLocalizedString(key, nil)
// 结束编辑
#define END_EDITING      [self.view endEditing:YES];

#pragma mark -
#pragma mark SIZE 尺寸

// 屏幕宽
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
// 屏幕高
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
// X系列机型 X、XR、XS、XS MAX
#define IPHONEX          (SCREEN_HEIGHT == 812.0f || SCREEN_HEIGHT == 896.0f)
// 导航栏高度
#define NAV_BAR_HEIGHT     (IPHONEX ? 88.f : 64.f)
// 标签栏高度
#define TAB_BAR_HEIGHT     (IPHONEX ? 83.f : 49.f)

#pragma mark -
#pragma mark BLOCK相关

#define WEAK(type)    __weak typeof(type) weak##type = type;
#define STRONG(type)  __strong typeof(type) type = weak##type;
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__);};

#pragma mark -
#pragma mark GCD

//GCD - 延迟
#define GCD_AFTER(sec,afterQueueBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(),afterQueueBlock);
//GCD - 一次性
#define GCD_ONCE(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 主线程
#define GCD_MAIN(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 后台
#define GCD_BACK(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


#pragma mark -
#pragma mark 日志工具

#ifdef DEBUG

#define DLog(fmt, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat: fmt, ## __VA_ARGS__] UTF8String]);

#else

#define DLog(...)

#endif

#pragma mark -
#pragma mark 系统对象

#define APP_APPLICATION  [UIApplication sharedApplication]

#define APP_WINDOW       [UIApplication sharedApplication].delegate.window

#define APP_DELEGATE     [UIApplication shareAppDelegate].delegate

#define APP_ROOT_VC      [UIApplication sharedApplication].delegate.window.rootViewController

#define USR_DEFAULTS     [NSUserDefaults standardUserDefaults]

#define NOTICE_CENTER    [NSNotificationCenter defaultCenter]

#pragma mark -
#pragma mark 字体

// 字号
#define FONT(FONTSIZE)[UIFont systemFontOfSize:FONTSIZE]
// 加粗
#define BOLD(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
// 自定义名称+字号
#define CUSTOM_FONT(NAME,FONTSIZE)[UIFont fontWithName:(NAME)size:(FONTSIZE)]

#pragma mark -
#pragma mark 颜色

// RGB颜色
#define COLOR(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
// 带透明度颜色
#define COLORA(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 十六进制颜色
#define HEX_COLOR(hex)    [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
// 随机颜色
#define RANDOM_COLOR      RGBColor(arc4random()%255, arc4random()%255, arc4random()%255)

#pragma mark -
#pragma mark 数学运算

// 求两个数中的最大值
#define MAX_VALUE(X,Y) ((X) > (Y) ? (X) : (Y))

#pragma mark -
#pragma mark 数据验证

#define YL_STR_VALID(f)             (f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""])

#define YL_SAFE_STR(f)              (YL_STR_VALID(f)?f:@"")

#define YL_HAS_STR(str,eky)         ([str rangeOfString:key].location!=NSNotFound)

#define YL_VALID_STR(f)             YL_STR_VALID(f)

#define YL_VALID_DICT(f)            (f!=nil &&[f isKindOfClass:[NSDictionary class]])

#define YL_VALID_ARRAY(f)           (f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)

#define YL_VALID_NUM(f)             (f!=nil &&[f isKindOfClass:[NSNumber class]])

#define YL_VALID_CLASS(f,cls)       (f!=nil &&[f isKindOfClass:[cls class]])

#define YL_VALI_DATA(f)             (f!=nil &&[f isKindOfClass:[NSData class]])

#pragma mark -
#pragma mark 界面跳转

#define GETSTORY(NAME)              [UIStoryboard storyboardWithName:NAME bundle:nil]

#define GETVC_STORY(NAME)           [[UIStoryboard storyboardWithName:NAME bundle:nil] instantiateInitialViewController]

#define GETVC_STORY_BYID(NAME,ID)   [[UIStoryboard storyboardWithName:NAME bundle:nil] instantiateViewControllerWithIdentifier:ID]

#define PUSH_BYSTORY(NAME,VC)\
\
VC *vc = GETVC_STORY(NAME);\
vc.hidesBottomBarWhenPushed = YES;\
[self.navigationController pushViewController:vc animated:YES];


#define PUSH_BYID(NAME,ID,VC)\
\
VC *vc = GETVC_STORY_BYID(NAME,ID);\
vc.hidesBottomBarWhenPushed = YES;\
[self.navigationController pushViewController:vc animated:YES];

#define PUSH(VC)\
\
VC *vc = [[VC alloc]init];\
vc.hidesBottomBarWhenPushed = YES;\
[self.navigationController pushViewController:vc animated:YES];

// 立即POP
#define POP_VC                 [self.navigationController popViewControllerAnimated:YES];

// 延迟0.5秒POP
#define POP_DELAY               GCD_AFTER(0.5, ^{[self.navigationController popViewControllerAnimated:YES];});

#pragma mark -
#pragma mark 通知发送

#define POST(WHAT)              [YLMessage post:@"YLNOTICE" what:WHAT];

#define POST_OBJ(WHAT,OBJ)      [YLMessage post:@"YLNOTICE" what:WHAT obj:OBJ];

#define POST_STR(WHAT,DESC)     [YLMessage post:@"YLNOTICE" what:WHAT desc:DESC];

#pragma mark -
#pragma mark 文件路径宏

#define PATH_TEMP                   NSTemporaryDirectory()
#define PATH_DOCUMENT               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_CACHE                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif /* YLMacro_h */
