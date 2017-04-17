//
//  ViewController.m
//  JYPageController
//
//  Created by hb on 2017/4/13.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "ViewController.h"
#import "JYPageView.h"
#import "JYTitleView.h"
#import "UIColor+RandomColor.h"

@interface ViewController ()
{
    NSArray *titles;
    NSMutableArray<UIViewController *> *childVCs;
}

@property (nonatomic, strong) JYPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    titles = @[@"视频",
               @"音乐",
               @"段子",
               @"新闻",
               @"体育",
               @"笑话",
               @"鬼故事",
               @"测试信息测试信息测试信息测试信息测试信息"];
    
    childVCs = [NSMutableArray array];
    
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
    style.titleHeight = 44;
    self.pageView = [[JYPageView alloc] initWithFrame:rect
                                               titles:titles
                                 parentViewController:self
                                 childViewControllers:childVCs style:style];
    [self.view addSubview:self.pageView];
}




@end
