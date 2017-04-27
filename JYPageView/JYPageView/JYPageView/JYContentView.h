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

@property (nonatomic, strong) UICollectionView *collectionView;//
@property (nonatomic, strong) UIViewController *parentViewController;// 父VC
@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;//子VC

@property (nonatomic, assign) NSInteger currentIndex; // 当前vc的下标 默认是0
@property (nonatomic, assign) BOOL isForbidScroll; // default is NO

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

@end
