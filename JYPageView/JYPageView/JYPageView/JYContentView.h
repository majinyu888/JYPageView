//
//  JYContentView.h
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYContentView;

@protocol JYContentViewDelegate <NSObject>

@optional
/**
 是否选中了某一个item, 当滑动结束的时候,也按照点击处理
 
 @param contentView 当前实例对象
 @param index 选中的下标
 */
- (void)JYContentView:(JYContentView *)contentView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface JYContentView : UIView

@property (nonatomic, weak) id<JYContentViewDelegate> delegate;

#pragma mark - init

/**
 初始化方法
 
 @param frame frame
 @param parent 父VC
 @param childs 子VC
 @return 当前对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray <UIViewController *>*)childs;

#pragma mark - update

/**
 滑动到指定的indexPath
 
 @param index 目标indexPath
 @param animate 是否动画
 */
- (void)updateScrollIndex:(NSInteger)index animate:(BOOL)animate;

@end
