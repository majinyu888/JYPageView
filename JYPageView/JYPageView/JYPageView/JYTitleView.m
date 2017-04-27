//
//  JYTitleView.m
//  JYPageController
//
//  Created by hb on 2017/4/13.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "JYTitleView.h"

@interface JYTitleView()

@end


@implementation JYTitleView

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
        self.backgroundColor = style.backgroundColor;
        self.currentIndex = 0;
        self.frame = CGRectMake(0, 0, style.titleWidth, style.titleHeight);
        self.titleViews = [NSMutableArray array];
        
        /// scrollView
        self.contentView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.contentView];
        
        /**根据titles计算scrollView的contentSize*/
        for (int i = 0; i < titles.count; i ++) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.userInteractionEnabled = YES;
            titleLabel.tag = i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:style.fontSize];
            titleLabel.text = titles[i];
            if (i == 0) {
                titleLabel.textColor = style.selectedColor;
            } else {
                titleLabel.textColor = style.defaultColor;
            }
            /// 计算位置信息 X and Width
            CGFloat offsetX = 0.0;
            CGFloat titleWidth = 0.0;
            
            if (i == 0) {
                offsetX = style.itemMargin/2;
            } else {
                offsetX = CGRectGetMaxX([self.titleViews lastObject].frame) + style.itemMargin;
            }
            if (style.isScrollEnable) {
                /// 可以滑动 (动态计算)
                CGRect titleRect = [titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                                 options:NSStringDrawingUsesFontLeading
                                                              attributes:@{NSFontAttributeName:titleLabel.font}
                                                                 context:nil];
                titleWidth = titleRect.size.width;
            } else {
                /// 不可以滑动 (等分)
                titleWidth = (style.titleWidth - titles.count * style.itemMargin) / titles.count;
            }
            /// 最终的frame
            titleLabel.frame = CGRectMake(offsetX, 0, titleWidth, style.titleHeight);
            
            /// 添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTaped:)];
            [titleLabel addGestureRecognizer:tap];
            
            [self.titleViews addObject:titleLabel];
            [self.contentView addSubview:titleLabel];
        }
        
        if (style.isScrollEnable) {
            /// 最后一个titleLabel的最大 X + 0.5倍边距
            self.contentView.contentSize = CGSizeMake(CGRectGetMaxX([self.titleViews lastObject].frame) + style.itemMargin/2, 0);
        } else {
            self.contentView.contentSize = CGSizeZero;
        }
        
        return self;
    } else {
        return nil;
    }
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
    targetLabel.textColor = _style.selectedColor;
    
    /// 记录点击之后的 index
    _currentIndex = targetIndex;
    
    /// 点击之后是否滑动来显示更多的内容
    if (_style.isScrollEnable) {
        
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
        [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}



@end


@implementation JYTitleStyle

+ (instancetype)defaultStyle
{
    JYTitleStyle *style = [[JYTitleStyle alloc] init];
    
    style.titleHeight = 44;
    style.titleWidth = [UIScreen mainScreen].bounds.size.width;
    style.itemMargin = 30;
    style.fontSize = 15;
    style.isScrollEnable = YES;
    style.defaultColor = [UIColor darkGrayColor];
    style.selectedColor = [UIColor redColor];
    style.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return style;
}

@end
