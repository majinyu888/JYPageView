//
//  JYTitleView.h
//  JYPageController
//
//  Created by hb on 2017/4/13.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYTitleStyle;
@class JYTitleView;

@protocol JYTitleViewDelegate <NSObject>

@optional

/**
 点击某个item的回调
 
 @param titleView titleView
 @param index 下标
 */
- (void)JYTitleView:(JYTitleView *)titleView didSelectedItemAtIndex:(NSInteger)index;

@end


@interface JYTitleView : UIView

@property (nonatomic, weak) id<JYTitleViewDelegate> delegate;


/// override
@property(nonatomic, assign) CGSize intrinsicContentSize;

#pragma mark - Init Methods

/**
 初始化方法
 
 @param titles 标题数组
 @return 当前对象实例
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

/**
 初始化方法
 
 @param titles 标题数组
 @param style 样式
 @return 当前对象实例
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles style:(JYTitleStyle *)style;


/**
 返回内容的真实宽度

 @return 真实宽度
 */
- (CGFloat)trueWidth;

#pragma mark - Public Methods

/**
 更新title的状态
 
 @param targetIndex 点击的title的下标
 */
- (void)updateTitleLableWithTargetIndex:(NSInteger)targetIndex;

@end


/**
 * 样式
 */
@interface JYTitleStyle : NSObject

/**
 height of titleView, defalut is 44
 */
@property (nonatomic, assign) CGFloat titleViewHeight;

/**
 width of titleView, defalut is ScreenWidth
 */
@property (nonatomic, assign) CGFloat titleViewWidth;

/**
 margin for item, defalut is 10
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 font size, defalut is 14
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 color of title's nomal state, defalut is [UIColor darkGrayColor]
 */
@property (nonatomic, strong) UIColor *defaultColor;

/**
 color of title's selected state, defalut is [UIColor redColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 color of titleView background, defalut is [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 identity whether the title and flagView is integrated, defalut is YES
 */
@property (nonatomic, assign) BOOL isIntegrated;

/**
 bottom margin for flagView, defalut is 2 , if is isIntegrated , please fix this value
 */
@property (nonatomic, assign) CGFloat flagViewBottomMargin;

/**
 height for flagView, defalut is 2
 */
@property (nonatomic, assign) CGFloat flagViewHeight;

/**
 identity whether the flagView is translucent, defalut is NO
 */
@property (nonatomic, assign) BOOL isFlagViewTranslucent;

/**
 height for bottomLine, defalut is 1
 */
@property (nonatomic, assign) CGFloat bottomLineHeight;

/**
 color for bottomLine, defalut is [UIColor groupTableViewBackgroundColor]
 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/**
 identity whether the titiView is show in naviationbar, defalut is NO
 */
@property (nonatomic, assign) BOOL isShowInNavigationBar;

/**
 defaultStyle
 
 @return defaultStyle
 */
+ (instancetype)defaultStyle;

@end
