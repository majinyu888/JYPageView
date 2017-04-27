//
//  JYPageView.m
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "JYPageView.h"

@interface JYPageView()<
JYTitleViewDelegate,
JYContentViewDelegate
>

@end

@implementation JYPageView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
{
    return [self initWithFrame:frame
                        titles:titles
          parentViewController:parent
          childViewControllers:childs
                         style:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
                        style:(JYTitleStyle *)style
{
    if (!titles) return nil;
    if (!parent) return nil;
    if (!childs) return nil;
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles;
        self.childs = childs;
        self.parent = parent;
        self.style = style == nil ? [JYTitleStyle defaultStyle] : style;
        
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        self.titleView.delegate = self;
        self.contentView.delegate = self;
        
        return self;
    } else {
        return nil;
    }
}

- (JYTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[JYTitleView alloc] initWithTitles:self.titles style:self.style];
    }
    return _titleView;
}

- (JYContentView *)contentView
{
    if (!_contentView) {
        CGRect rect = CGRectMake(0,
                                 self.style.titleHeight,
                                 self.style.titleWidth,
                                 self.bounds.size.height - self.style.titleHeight);
        
        _contentView = [[JYContentView alloc] initWithFrame:rect
                                       parentViewController:self.parent
                                       childViewControllers:self.childs];
    }
    return _contentView;
}

#pragma mark - TitleView Delegate

/**
 点击某个item的回调
 
 @param titleView titleView
 @param index 下标
 */
- (void)JYTitleView:(JYTitleView *)titleView didSelectedItemAtIndex:(NSInteger)index
{
    if (index == _currentIndex) {
        return;
    }
    
    _currentIndex = index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentView.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYPageView:didSelectedItemAtIndex:)]) {
        [self.delegate JYPageView:self didSelectedItemAtIndex:index];
    }
}

#pragma mark - ContentView Delegate

/**
 是否选中了某一个item, 当滑动结束的时候,也按照点击处理
 
 @param contentView 当前实例对象
 @param index 选中的下标
 */
#pragma mark - JYContentView Delegate

- (void)JYContentView:(JYContentView *)contentView didSelectedItemAtIndex:(NSInteger)index
{
    if (index == _currentIndex) {
        return;
    }
    
    _currentIndex = index;
    
    [self.titleView updateTitleLableWithTargetIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYPageView:didSelectedItemAtIndex:)]) {
        [self.delegate JYPageView:self didSelectedItemAtIndex:index];
    }
}


@end
