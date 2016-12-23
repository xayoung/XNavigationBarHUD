//
//  XNavigationBarHUD.h
//  CNotificationExample
//
//  Created by xayoung on 16/12/23.
//  Copyright © 2016年 shscce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define XN_TEXT_FONT_KEY @"XN_TEXT_FONT_KEY"
#define XN_TEXT_COLOR_KEY @"XN_TEXT_COLOR_KEY"
#define XN_DELAY_SECOND_KEY @"XN_DELAY_SECOND_KEY"
#define XN_BACKGROUND_COLOR_KEY @"XN_BACKGROUND_COLOR_KEY"


typedef void(^XNCompleteBlock)();

@interface XNavigationBarHUD : NSObject

@property (nonatomic) CGFloat delaySeconds; //延迟几秒消失
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,copy) XNCompleteBlock completeBlock;

+ (instancetype)shareManager;
+ (void)setOptions:(NSDictionary *)options;


+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options;
+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)())completeBlock;

@end
