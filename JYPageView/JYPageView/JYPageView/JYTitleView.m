//
//  JYTitleView.m
//  JYPageController
//
//  Created by hb on 2017/4/13.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "JYTitleView.h"

@interface JYTitleView()

/// models
@property (nonatomic, strong) JYTitleStyle *style;//样式
@property (nonatomic, strong) NSArray<NSString *> *titles;//标题数组
@property (nonatomic, assign) NSInteger currentIndex;//当前下标

/// UIs
@property (nonatomic, strong) UIScrollView *contentView;//内容视图
@property (nonatomic, strong) NSMutableArray<UIView *> *titleViews;//标题View数组
@property (nonatomic, strong) UIView *flagView;//当前正在选中的标题View的标记
@property (nonatomic, strong) UIView *bottomLine;//底部line

@end


@implementation JYTitleView

#pragma mark - Init Methods

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
{
    return [self initWithTitles:titles style:nil];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles style:(JYTitleStyle *)style
{
    if (!titles || ![titles isKindOfClass:[NSArray class]]) return nil;
    
    if (self = [super init]) {
        
        /// assignment propertys
        self.titles = titles;
        if (!style) style = [JYTitleStyle defaultStyle];
        self.style = style;
        
        if (titles.count == 1) {
            style.titleViewHeight = 0.0;/// 当只有一个title时,不显示顶部的titleView
        } else {
            if (style.titleViewHeight == 0.0) {
                style.titleViewHeight = [JYTitleStyle defaultStyle].titleViewHeight;
            }
        }
        self.backgroundColor = style.backgroundColor;
        self.currentIndex = 0;
        self.frame = CGRectMake(0, 0, style.titleViewWidth,style.titleViewHeight + style.bottomLineHeight);
        self.titleViews = [NSMutableArray array];
        
        /// scrollView
        self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, style.titleViewWidth, style.titleViewHeight)];
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.contentView];
        
        /**根据titles计算scrollView的contentSize*/
        
        /// 计算位置信息 X and Width - 默认配置
        CGFloat offsetX01 = 0.0;
        CGFloat titleViewWidth01 = 0.0;
        
        for (int i = 0; i < titles.count; i ++) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.userInteractionEnabled = YES;
            titleLabel.tag = i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:style.fontSize];
            titleLabel.text = titles[i];
            if (i == _currentIndex && style.isIntegrated) {
                titleLabel.textColor = style.selectedColor;
            } else {
                titleLabel.textColor = style.defaultColor;
            }
            
            if (i == 0) {
                offsetX01 = style.itemMargin/2;/// 第一个 -> 左边距/2
            } else {
                offsetX01 = CGRectGetMaxX([self.titleViews lastObject].frame) + style.itemMargin;
            }
            
            /// 默认假设可以滑动 (动态计算)
            CGRect titleRect = [titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                             options:NSStringDrawingUsesFontLeading
                                                          attributes:@{NSFontAttributeName:titleLabel.font}
                                                             context:nil];
            titleViewWidth01 = titleRect.size.width;
            /// 最终的frame
            titleLabel.frame = CGRectMake(offsetX01, 0, titleViewWidth01, style.titleViewHeight);
            
            /// 添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTaped:)];
            [titleLabel addGestureRecognizer:tap];
            
            [self.titleViews addObject:titleLabel];
            [self.contentView addSubview:titleLabel];
        }
        
        /// 最后一个 -> + 右边距/2
        CGFloat maxX = CGRectGetMaxX([self.titleViews lastObject].frame) + style.itemMargin/2;
        
        if (maxX < style.titleViewWidth) {
            /// 说明没有到一屏幕宽
            if (!style.isShowInNavigationBar) {
                /// 需要平分
                // X
                CGFloat offsetX02 = 0.0;
                //宽度
                CGFloat titleViewWidth02 = (style.titleViewWidth - titles.count * style.itemMargin) / titles.count;
                
                /// 重新计算,X 和 宽度
                for (int j = 0; j < self.titleViews.count; j ++) {
                    
                    if (j == 0) {
                        offsetX02 = style.itemMargin/2;
                    } else {
                        offsetX02 = style.itemMargin/2 + (titleViewWidth02 + style.itemMargin) * j;
                    }
                    
                    CGRect finishFrame = CGRectMake(offsetX02, 0, titleViewWidth02, style.titleViewHeight);
                    
                    UIView *v1 = self.titleViews[j];
                    v1.frame = finishFrame;
                    
                    UIView *v2 = self.contentView.subviews[j];
                    v2.frame = finishFrame;
                }
            } else {
                /// 不需要平分
                /// 但是需要在navigationBar中居中.
                self.frame = CGRectMake(0, 0, [self trueWidth],style.titleViewHeight + style.bottomLineHeight);
//                [self.contentView setMj_insetL:20];
            }
        }
        
        /// flayView defalut
        self.flagView = [[UIView alloc] init];
        self.flagView.backgroundColor = style.selectedColor;
        
        if (style.isFlagViewTranslucent) {
            self.flagView.alpha = 0.5;
            self.flagView.layer.cornerRadius = style.flagViewHeight / 2.0;
        } else {
            self.flagView.alpha = 1;
            self.flagView.layer.cornerRadius = 0;
        }
        if (style.isIntegrated) {
            self.flagView.frame = CGRectMake([self currentTilteView].frame.origin.x, style.titleViewHeight - style.flagViewHeight, [self currentTilteView].frame.size.width, style.flagViewHeight);
        } else {
            ///
            self.flagView.frame = CGRectMake([self currentTilteView].frame.origin.x, style.titleViewHeight - style.flagViewHeight - style.flagViewBottomMargin, [self currentTilteView].frame.size.width, style.flagViewHeight);
        }
        [self.contentView addSubview:self.flagView];
        
        /// 最后一个titleLabel的最大 X + 0.5倍边距
        self.contentView.contentSize = CGSizeMake(CGRectGetMaxX([self.titleViews lastObject].frame) + style.itemMargin/2, 0);
        
        /// 底部line
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = style.bottomLineColor;
        self.bottomLine.frame = CGRectMake(self.frame.origin.x, self.contentView.frame.size.height, style.titleViewWidth, style.bottomLineHeight);
        [self addSubview:self.bottomLine];
        
        return self;
    } else {
        return nil;
    }
}


#pragma mark - Private Methods

/**
 获取当前正在选中的View
 
 @return label
 */
- (UIView *)currentTilteView
{
    return _titleViews[_currentIndex];
}

/**
 更新标识view的位置信息,要和选中的titleView保持同步
 */
- (void)updateFlagViewFrame
{
    
    UIView *currentLabel = [self currentTilteView];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.style.isIntegrated) {
            self.flagView.frame = CGRectMake(currentLabel.frame.origin.x, self.style.titleViewHeight - self.style.flagViewHeight, currentLabel.frame.size.width, self.style.flagViewHeight);
        } else {
            self.flagView.frame = CGRectMake(currentLabel.frame.origin.x, self.style.titleViewHeight - self.style.flagViewHeight - self.style.flagViewBottomMargin, currentLabel.frame.size.width, self.style.flagViewHeight);
        }
    }];
}


/**
 title taped gesture
 
 @param gesture 单击手势
 */
- (void)titleTaped:(UITapGestureRecognizer *)gesture
{
    /// 点击的index
    NSInteger destinationIndex = gesture.view.tag;
    
    /// 更新title状态
    [self updateTitleLableWithTargetIndex:destinationIndex];
    
    /// 回调delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYTitleView:didSelectedItemAtIndex:)]) {
        [self.delegate JYTitleView:self didSelectedItemAtIndex:_currentIndex];
    }
}

#pragma mark - Public Methods

/**
 更新title的状态
 
 @param targetIndex 点击的title的下标
 */
- (void)updateTitleLableWithTargetIndex:(NSInteger)targetIndex
{
    if (_currentIndex == targetIndex) {
        /// 点击了同一个
        return;
    }
    
    /// 取出label, 修改点击前后的颜色
    UILabel *sourceLabel = (UILabel *)_titleViews[_currentIndex];
    UILabel *targetLabel = (UILabel *)_titleViews[targetIndex];
    
    sourceLabel.textColor = _style.defaultColor;
    if (_style.isIntegrated) {
        targetLabel.textColor = _style.selectedColor;
    } else {
        targetLabel.textColor = _style.defaultColor;
    }
    
    /// 记录点击之后的 index
    _currentIndex = targetIndex;
    
    /// 被点击label的中心点位置 和 内容的总宽的中心点x坐标比较
    CGFloat offsetX = targetLabel.center.x - self.contentView.bounds.size.width * 0.5;
    if (offsetX < 0) {
        /// 点击了左侧,并且中心点偏左部分,不需要滑动内容
        offsetX = 0;
    }
    
    if (offsetX > self.contentView.contentSize.width - self.contentView.bounds.size.width) {
        /// 点击了右侧,并且中心点偏右部分,需要滑动内容
        offsetX = self.contentView.contentSize.width - self.contentView.bounds.size.width;
    }
    
    if (!self.style.isShowInNavigationBar) {
        [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    /// 更新标志View的位置
    [self updateFlagViewFrame];
}

/**
 返回内容的真实宽度
 
 @return 真实宽度
 */
- (CGFloat)trueWidth {
    return self.titleViews.lastObject.frame.origin.x + self.titleViews.lastObject.frame.size.height + _style.itemMargin;
}



@end


@implementation JYTitleStyle

+ (instancetype)defaultStyle
{
    JYTitleStyle *style = [[JYTitleStyle alloc] init];
    
    style.titleViewHeight = 44;
    style.titleViewWidth = [UIScreen mainScreen].bounds.size.width;
    style.itemMargin = 10;
    style.fontSize = 14;
    style.defaultColor = [UIColor darkGrayColor];
    style.selectedColor = [UIColor redColor];
    style.backgroundColor = [UIColor whiteColor];
    style.isIntegrated = YES;
    style.flagViewBottomMargin = 0;
    style.flagViewHeight = 2;
    style.isFlagViewTranslucent = NO;
    style.bottomLineHeight = 0.5;
    style.bottomLineColor = [UIColor lightGrayColor];
    style.isShowInNavigationBar = NO;
    
    return style;
}

@end
