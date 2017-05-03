//
//  JYPageView.h
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTitleView.h"
#import "JYContentView.h"

@class JYPageView;

@protocol JYPageViewDelegate <NSObject>

@optional

/**
 是否选中了某个item (滑动也按照选中处理)
 
 @param pageView 当前pageView对象
 @param index 选中下标
 */
- (void)JYPageView:(JYPageView *)pageView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface JYPageView : UIView

@property (nonatomic, weak) id<JYPageViewDelegate> delegate;

#pragma mark - init

/**
 初始化pageView
 
 @param frame frame
 @param titles 标题数组(用来配置JYTitleView)
 @param parent 父ViewController
 @param childs 子ViewControllers
 @return 当前对象的一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs;

/**
 初始化pageView
 
 @param frame frame
 @param style titleView的样式(可不传)
 @param titles 标题数组(用来配置JYTitleView)
 @param parent 父ViewController
 @param childs 子ViewControllers
 @return 当前对象的一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                        style:(JYTitleStyle *)style
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs;

#pragma mark - reload

/**
 重新刷新页面信息
 
 @param titles 新的titles数组
 @param childs 新的childs数组
 */
- (void)reloadWithTitles:(NSArray *)titles childs:(NSArray<UIViewController *> *)childs;


@end
