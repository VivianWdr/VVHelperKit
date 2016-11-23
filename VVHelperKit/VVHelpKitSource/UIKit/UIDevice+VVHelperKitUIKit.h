//
//  UIDevice+VVHelperKitUIKit.h
//  VVHelperKit
//
//  Created by Vivi on 16/11/22.
//  Copyright © 2016年 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (VVHelperKitUIKit)

/**
 Return the device platform string
 Example: "iPhone3,2"
 
 @return Return the device platfrom string.
 */
+ (NSString *)devicePlatform;

/**
 Return the user-friendly device platform string
 Example: "iPad Air (Cellular)"

 @return Return the user-friendly device platfrom string.
 */
+ (NSString *)devicePlatfromString;

/**
 Check if the current device is an iPad.

 @return Return YES if it's an iPad,NO if not
 */
+ (BOOL)isiPad;

/**
 check if the current device is an iPhone.

 @return Return YES if it's an iPhone,NO if not
 */
+ (BOOL)isiPhone;

/**
 Check if the current device is an iPod
 
 @return Return YES if it's an iPod, NO if not
 */
+ (BOOL)isiPod;

/**
 Check if the current device is the simulator.

 @return Return YES if it's the simulator, NO if not
 */
+ (BOOL)isSimulator;

/**
 check if the current device has a Retina display

 @return Return YES if it has a Retina display, NO if not
 */
+ (BOOL)isRetina;

/**
 Check if the current device has a Retina HD display

 @return Return YES if it has a Retina HD display,NO if not
 */
+ (BOOL)isRetinaHD;


@end
