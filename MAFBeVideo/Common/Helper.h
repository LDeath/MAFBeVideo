//
//  Helper.h
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#ifndef Helper_h
#define Helper_h

#pragma mark - 界面 部分

#define NavigationBar_HEIGHT 44     //导航控制器

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度


#define RESIZE_HEIGHT(height) (height / 1334.0 * SCREEN_HEIGHT)
#define RESIZE_WIDTH(width) (width / 750.0 * SCREEN_WIDTH)

#define SAFE_RELEASE(x) [x release];x=nil       //安全释放

#define RBGCOLOR(r,g,b) [UIColor colorWithRed:0.400 green:0.523 blue:0.949 alpha:1.000]  //设置颜色

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define FONT(size) [UIFont systemFontOfSize:size]

#pragma mark - 系统 部分

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]   //当前设备的系统版本
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])     //当前的系统版本
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])   //当前的设备的默认语言

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)    //是否是高清屏

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)    //是否是IPhone5

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //是否是IPAD



#pragma mark - 功能部分
//use dlog to print while in debug model
#ifdef DEBUG
#   define Lg(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define Lg(...)
#endif


//针对真机iPhone
#if TARGET_OS_IPHONE
//iPhone Device
#endif

//针对模拟器
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]      //UserDefault


#define degreesToRadian(x) (M_PI * (x) / 180.0) //弧度转角度

#define radianToDegrees(radian) (radian*180.0)/(M_PI)  //角度转弧度



//读取本地图片的 和imageNamed一样，但是性能比后者要强很多，两个参数，前面一个是 文件名，后面一个是类型

#define LoadImage(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]  //可以用来直接传图片名字

#define LoadImageWithType(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//例如 imageView.image =  LOADIMAGE(@"文件名",@"png");


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark - Path
#define kHomePath        NSHomeDirectory()
#define kCachePath      [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
#define kDocumentFolder [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kDocumentFolder2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kLibraryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define kTempPath    NSTemporaryDirectory()
#define kMainBoundPath [[NSBundle mainBundle] bundlePath]
#define kResourcePath  [[NSBundle mainBundle] resourcePath]
#define kExecutablePath [[NSBundle mainBundle] executablePath]



#pragma mark - 创建单例
/**
 
 github:https://gist.github.com/lukeredpath/1057420
 
 @implementation MySharedThing
 
 + (id)sharedInstance
 {
 DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
 return [[self alloc] init];
 });
 }
 
 @end
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

///异步线程
#define AsyncTaks_Excute(doingbackground) \
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), doingbackground); \


#define onUIThread(doingsomethind) dispatch_async(dispatch_get_main_queue(),doingsomethind);

#endif /* Helper_h */
