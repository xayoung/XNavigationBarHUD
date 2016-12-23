//
//  XNavigationBarHUD.m
//  CNotificationExample
//
//  Created by xayoung on 16/12/23.
//  Copyright © 2016年 shscce. All rights reserved.
//

#import "XNavigationBarHUD.h"

#define kNOTIFICATION_VIEW_HEIGHT 64

@interface XNavigationBarHUD ()

@property (nonatomic,readonly,getter=isShowing) BOOL showing;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIImageView *errorImg;

@end

@implementation XNavigationBarHUD
- (instancetype)init{
    if (self  = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:14];
        self.delaySeconds = 1.5f;
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.errorImg];

        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
        [self.backgroundView addGestureRecognizer:dismissTap];
    }
    return self;
}

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (void)setOptions:(NSDictionary *)options{
    if (!options) {
        return;
    }
    if (options[XN_BACKGROUND_COLOR_KEY]) {
        [XNavigationBarHUD shareManager].backgroundColor = options[XN_BACKGROUND_COLOR_KEY];
    }
    if (options[XN_TEXT_COLOR_KEY]) {
        [XNavigationBarHUD shareManager].textColor = options[XN_TEXT_COLOR_KEY];
    }
    if (options[XN_TEXT_FONT_KEY]) {
        [XNavigationBarHUD shareManager].textFont = options[XN_TEXT_FONT_KEY];
    }
    if (options[XN_DELAY_SECOND_KEY]){
        [XNavigationBarHUD shareManager].delaySeconds = [options[XN_DELAY_SECOND_KEY] floatValue];
    }
}

+ (void)showMessage:(NSString *)message{

    [XNavigationBarHUD showMessage:message withOptions:nil completeBlock:nil];
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options{

    [XNavigationBarHUD showMessage:message withOptions:options completeBlock:nil];

}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)())completeBlock{
    [XNavigationBarHUD shareManager].completeBlock = completeBlock;
    [XNavigationBarHUD setOptions:options];
    if ([[XNavigationBarHUD shareManager] isShowing]) {
        [[XNavigationBarHUD shareManager] reDisplayTitleLabel:message];
    }else{
        [[XNavigationBarHUD shareManager] showNotification:message];
    }
}


#pragma mark - Public Methods
/**
 *  重新设置titleLabel backgroundView 背景等
 *
 *  @param message 需要显示的message
 */
- (void)setupViewOptionsWithMessage:(NSString *)message{
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.titleLabel.textColor = self.textColor;
    self.titleLabel.font = self.textFont;
    self.titleLabel.text = message;
}


/**
 *  显示一条消息通知
 *
 *  @param message 需要显示的信息
 */
- (void)showNotification:(NSString *)message{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    self.backgroundView.frame = CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
    [self setupViewOptionsWithMessage:message];
    [self resizeTitleLabelFrame];
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    } completion:^(BOOL finished) {

        if (self.delaySeconds != 0.0) {
            [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        }
    }];
}


#pragma mark - Private Methods

/**
 *  当消息通知已经显示时  重新显示titleLabel
 *
 *  @param message 需要显示的消息
 */
- (void)reDisplayTitleLabel:(NSString *)message{
    //取消之前通知隐藏notification
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    [UIView animateWithDuration:.2 animations:^{
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, kNOTIFICATION_VIEW_HEIGHT + 10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [self setupViewOptionsWithMessage:message];
        [self resizeTitleLabelFrame];
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, -10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        [UIView animateWithDuration:.1 animations:^{
            [self resizeTitleLabelFrame];
        } completion:^(BOOL finished) {
            //重新定义调用延迟隐藏notification
            [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        }];
    }];
}

- (void)resizeTitleLabelFrame{
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = [self.titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 40, 36)];
    titleFrame.origin = CGPointMake(self.backgroundView.frame.size.width/2 - titleFrame.size.width/2, self.backgroundView.frame.size.height/2 - titleFrame.size.height/2 + 5);
    self.titleLabel.frame = titleFrame;
}

/**
 *  隐藏通知
 */
- (void)dismissNotification{

    if (!self.showing) {
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        if (self.completeBlock) {
            self.completeBlock();
            self.completeBlock = nil;
        }
    }];
}

#pragma mark - getters & setters
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, [UIScreen mainScreen].applicationFrame.size.width, kNOTIFICATION_VIEW_HEIGHT)];
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)errorImg{
    if (!_errorImg) {
        _errorImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _errorImg.contentMode = UIViewContentModeScaleAspectFit;
        NSBundle *bundle = [NSBundle bundleForClass:[XNavigationBarHUD class]];
        NSURL *url = [bundle URLForResource:@"XNavigationBarHUD" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        UIImage* errorImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error" ofType:@"png"]];
        _errorImg.image = errorImage;
        _errorImg.image = [_errorImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _errorImg.tintColor = [UIColor whiteColor];
        _errorImg.center = CGPointMake([UIScreen mainScreen].applicationFrame.size.width - 30, (kNOTIFICATION_VIEW_HEIGHT) * 0.5 + 5);
    }
    return _errorImg;
}

- (BOOL)isShowing{
    return self.backgroundView && self.backgroundView.superview;
}

@end
