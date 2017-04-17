//
//  JYPageView.m
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "JYPageView.h"
#import "JYTitleView.h"
#import "JYContentView.h"

@interface JYPageView()

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<UIViewController *> *childs;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) JYTitleStyle *style;
@property (nonatomic, strong) JYTitleView *titleView;
@property (nonatomic, strong) JYContentView *contentView;

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
        self.titleView.delegate = (id<JYTitleViewDelegate>)self.contentView;
        self.contentView.delegate = (id<JYContentViewDelegate>)self.titleView;
        
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
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

@end
