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

- (void)JYPageView:(JYPageView *)pageView DidSelectedItemAtIndex:(NSInteger)index;

@end

@interface JYPageView : UIView

@property (nonatomic, weak) id<JYPageViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<UIViewController *> *childs;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) JYTitleStyle *style;
@property (nonatomic, strong) JYTitleView *titleView;
@property (nonatomic, strong) JYContentView *contentView;

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
 @param titles 标题数组(用来配置JYTitleView)
 @param parent 父ViewController
 @param childs 子ViewControllers
 @param style titleView的样式(可不传)
 @return 当前对象的一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
                        style:(JYTitleStyle *)style;

@end
