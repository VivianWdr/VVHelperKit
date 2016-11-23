//
//  VVCommonKit.h
//  VVHelperKit
//
//  Created by Vivi on 16/11/17.
//  Copyright © 2016年 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

// Get Weak reference object.
#define kWeakObject(object) __weak __typeof(object) weak##object = object;

// Get weak reference object.
#define kWeak(caller, object) __weak __typeof(object) caller = object;

// Get strong reference object.
#define kStrongObject(object) __strong __typeof(object) strong##object = object;

// Get dispatch_get_main_queue()
#define kMainQueue (dispatch_get_main_queue())

// Get default dispatch_get_global_queue()
#define kGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

// Radians convert to degress.
#define kRadiansToDegress(radians) ((radians) * (180.0 / M_PI))

// Degress convert to radians.
#define kDegresToRadians(angle) ((angle) / 180.0 * M_PI)

// Fast to get iOS system version
#define kiOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

// More fast way to get app delegate
#define kAppDelegate ((AppDelegate *)[[UIApplication  sharedApplication] delegate])

#pragma mark - Device Frame

// The current Xcode support iOS8 and above
#if IOS_VERSION_8_OR_LATER
// Get the screen's with.
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

// Get the screen's height.
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

// Get the screen's bounds.
#define kScreenBounds ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
// Get the screen's with.
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

// Get the screen's height.
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// Get the screen's bounds.
#define kScreenBounds [UIScreen mainScreen].bounds.size
#endif

// When Debug use NSLog
#ifdef DEBUG
#define DLog(...) NSLog(@"%s line:%d\n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#pragma mark - Generate Color

/**
 format: 0xFFFFFF
 */
#define k16RGBColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

/**
 format:22,22,22
 */
#define kRGBColor(r,g,b) ([UIColor colorWithRed:(r) / 255.0 \
green:(g)/255.0\
blue:(b)/255.0\
alpha:1])

/**
 format:22,22,22,0.5
 */
#define kRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:(a)])

//More easy way to use hex color to generate color.
#define KHexRGB(rgb) k16RGBColor(rgb)

//More easy way to generate a color object.
#define kRGB(r,g,b) kRGBColor(r,g,b)
//Moer easy way to generate a color object with rgb and alpha.
#define kRGBA(r,g,b,a) kRGBAColor(r, g, b, a)

#pragma mark - Load Font
// Generate font of size
#define kFontOfSize(size) [UIFont systemFontOfSize:size]

// Generate bold font of size
#define kBoldFontOfSize(size) [UIFont boldSystemFontOfSize:size]

#pragma mark - Load Image
// More easy way to load an image.
#define kImage(name) [UIImage imageNamed:name]

// More easy to load an image from file.
#define kImageOfFile(Name) ([UIImage imageWithContentsOfFile:[NSBoudle mainBoundle] pathForResource:Name ofType:nil])

#pragma mark - System Singletons

// More easy way to Get NSUserDefault objecet
#define kUserDefaults [NSUserDefaults standardUserDefaults]

// More easy way to Get NSNOtificationCenter object
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// More easy way to Post a notification from notification center.
#define kPostNotificationWithName(notificationName)\
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:nil]

// More easy way to Post a notification with user info from notification cencer.
#define kPostNotificationWithNameAndUserInfo(notificationName, userInfo)\
[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];

// Get NSFileManager object
#define kFileManager [NSFileManager defaultManager]

#pragma mark - Judge

// Judge whether it is an empty string.
#define kIsEmptyString(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class] && s.length == 0]))

// Judge whether it is a nil or null object.
#define kIsEmptyObject(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

// Judge whether it is a void dictionary.
#define kIsDictionary(objDict) (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])

// Judge whether it is a void array.
#define kIsArray(objArray) (objArray != nil && [objArray isKindOfClass:[NSArray class]])

// Judge whether the device it is iPad.
#define kIsIPad \
([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]\
&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// Judge whether current orientation is landscape.
#define kIsLandscape (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#pragma mark - Blocks

typedef void (^VVErrorBlock) (NSError *error);

typedef void (^VVVoidBlock) (void);

typedef void (^VVBoolBlock) (BOOL result);

typedef void (^VVStringBlock) (NSString *result);

typedef void (^VVArrayBlock) (NSArray *list);

typedef void (^VVArrayMessageBlock) (NSArray *list, NSString *msg);

typedef void (^VVDictionaryBlock) (NSDictionary *response);

typedef void (^VVDictionaryMessageBlock) (NSDictionary *response, NSString *msg);

typedef void (^VVNumberBlock) (NSNumber *resultNumber);

typedef void (^VVNumberMessageBlock) (NSNumber *resultNumber, NSString *msg);

typedef void (^VVIdBlock) (id result);

typedef void (^VVNotificationBlock) (NSNotification *sender);

typedef void (^VVButtonBlock) (UIButton *sender);

typedef void (^VVButtonIndexBlock) (NSUInteger index, UIButton *sender);

typedef void (^VVValueChangedBlock) (id sender);

typedef void (^VVEditChangedBlock) (id sender);

typedef void (^VVGestureBlock) (UIGestureRecognizer *sender);

typedef void (^VVLongGestureBlock) (UILongPressGestureRecognizer *sender);

typedef void (^VVTapGestureBlock) (UITapGestureRecognizer *sender);

typedef void (^VVConstraintMaker) (MASConstraintMaker *make);

#pragma mark - Cell

static NSString *kVVCellIdentifier = @"VVCommonCellIdentifier";

@interface VVCommonKit : NSObject

@end
