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

/*
 * why weak -> 只负责传值, 不负责销毁
 */
@property (nonatomic, weak) NSArray<NSString *> *titles;//标题数组
@property (nonatomic, weak) NSArray<UIViewController *> *childs;//子UIViewController数组
@property (nonatomic, weak) UIViewController *parent;//父UIViewController

@end

@implementation JYPageView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
{
    return [self initWithFrame:frame
                         style:nil
                        titles:titles
          parentViewController:parent
          childViewControllers:childs];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(JYTitleStyle *)style
                       titles:(NSArray<NSString *> *)titles
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.childs = childs;
        self.parent = parent;
        self.style = style == nil ? [JYTitleStyle defaultStyle] : style;
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        self.titleView.delegate = self;
        self.contentView.delegate = self;
    }
    return self;
}



#pragma mark - Getter

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
        CGRect rect = CGRectZero;
        if (self.style.isShowInNavigationBar) {
            /// 在导航栏中显示..
            /// 默认内容视图宽度为屏幕的宽度
            rect = CGRectMake(0,
                              self.style.titleViewHeight + self.style.bottomLineHeight,
                              [UIScreen mainScreen].bounds.size.width,
                              self.bounds.size.height - self.style.titleViewHeight - self.style.bottomLineHeight);
        } else {
            /// 不在导航栏中显示..
            /// 默认内容视图宽度为样式的宽度
            /// 这里高度好像也不准了...
            rect = CGRectMake(0,
                              self.style.titleViewHeight + self.style.bottomLineHeight,
                              self.style.titleViewWidth,
                              self.bounds.size.height - self.style.titleViewHeight - self.style.bottomLineHeight);
        }
        
        _contentView = [[JYContentView alloc] initWithFrame:rect
                                       parentViewController:self.parent
                                       childViewControllers:self.childs];
    }
    return _contentView;
}

#pragma mark - Setter

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.titleView updateTitleLableWithTargetIndex:_currentIndex];
    [self.contentView updateScrollIndex:_currentIndex animate:NO];
}


#pragma mark - reload

/**
 重新刷新页面信息
 
 @param titles 新的titles数组
 @param childs 新的childs数组
 */
- (void)reloadWithTitles:(NSArray *)titles childs:(NSArray<UIViewController *> *)childs
{
    /// 1.清空
    /// 2.恢复默认值
    /// 3.重新添加
    
    if (_titleView) {
        _titleView.delegate = nil;
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    
    if (_contentView) {
        _contentView.delegate = nil;
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    
    _currentIndex = 0;
    
    self.titles = titles;
    self.childs = childs;
    
    [self addSubview:self.titleView];
    [self addSubview:self.contentView];
    
    self.titleView.delegate = self;
    self.contentView.delegate = self;
}

- (void)updateContentViewWithFrame: (CGRect)rect {
    if (!_contentView) {
        return;
    }
    /// 清理contentView
    _contentView.delegate = nil;
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    /// 重新添加
    _contentView = [[JYContentView alloc] initWithFrame:rect
                                   parentViewController:self.parent
                                   childViewControllers:self.childs];
    _contentView.delegate = self;
    [self addSubview:_contentView];
}

#pragma mark - JYTitleView Delegate

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
    
    /// 记录当前下标
    _currentIndex = index;
    
    /// 将对应的内容视图跳转到对应的下标
    [self.contentView updateScrollIndex:index animate:YES];
    
    /// 如果实现了代理,代理还可以做额外的操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYPageView:didSelectedItemAtIndex:)]) {
        [self.delegate JYPageView:self didSelectedItemAtIndex:index];
    }
}

#pragma mark - JYContentView Delegate

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
    
    /// 记录当前下标
    _currentIndex = index;
    
    /// 更新标题选中状态
    [self.titleView updateTitleLableWithTargetIndex:index];
    
    /// 如果实现了代理,代理还可以做额外的操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYPageView:didSelectedItemAtIndex:)]) {
        [self.delegate JYPageView:self didSelectedItemAtIndex:index];
    }
}


@end
