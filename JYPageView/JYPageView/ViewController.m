//
//  ViewController.m
//  JYPageController
//
//  Created by hb on 2017/4/13.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "ViewController.h"
#import "JYPageView.h"
#import "UIColor+RandomColor.h"

@interface ViewController ()<
JYPageViewDelegate
>

@property (nonatomic, strong) JYPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(reloadJYPageView)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray*  titles = @[@"测试测试测试测试测试",
                         @"音乐音乐音乐音乐",
                         @"段子段子段子",
                         @"新闻",
                         @"体"];
    
    NSMutableArray<UIViewController *> *childVCs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i ++) {
        UIViewController *childVC = [[UIViewController alloc] init];
        childVC.view.backgroundColor = [UIColor randomColor];
        [childVCs addObject:childVC];
    }
    
    CGRect rect = CGRectMake(0,
                             64,
                             self.view.frame.size.width,
                             self.view.frame.size.height - 64);
    
    JYTitleStyle *style = [JYTitleStyle defaultStyle];
    style.fontSize = 17;
    style.titleViewHeight = 44;
    style.isIntegrated = NO;
    style.flagViewBottomMargin = 12;
    style.flagViewHeight = 5;
    style.isFlagViewTranslucent = YES;
    
    self.pageView = [[JYPageView alloc] initWithFrame:rect
                                                style:style
                                               titles:titles
                                 parentViewController:self
                                 childViewControllers:childVCs];
    self.pageView.delegate = self;
    self.pageView.currentIndex = 2;
    [self.view addSubview:self.pageView];
}


/// 重新加载页面
- (void)reloadJYPageView
{
    NSArray *title1s = @[@"测试信息测试信息",@"Movies"];
    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 0; i < title1s.count; i ++) {
        UIViewController *childVC = [[UIViewController alloc] init];
        childVC.view.backgroundColor = [UIColor randomColor];
        [ma addObject:childVC];
    }
    [self.pageView reloadWithTitles:title1s childs:ma];
}

#pragma mark - Delegate

- (void)JYPageView:(JYPageView *)pageView didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}


@end
