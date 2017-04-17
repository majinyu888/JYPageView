# JYPageView
功能说明
-----
iOS 多个UIViewController之间滑动切换

显示效果
-----
![](https://github.com/majinyu888/JYPageView/blob/master/JYPageView.gif)

使用方法
-----
#### 1.将JYPageView文件夹拷贝到您的项目
#### 2.在需要使用的ViewController
     #import "JYPageView.h"
     #import "JYTitleView.h"
#### 3.声明一个属性
    @property (nonatomic, strong) JYPageView *pageView;
#### 4.禁止掉ViewController自身的一个属性
   self.automaticallyAdjustsScrollViewInsets = NO;
#### 5.添加到self.view上面即可

``` Objective-C

    NSArray *titles = @[@"视频", @"音乐", @"段子", @"新闻", @"体育", @"笑话", @"鬼故事"];
    NSMutableArray<UIViewController *> *childVCs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i ++) {
        UIViewController *childVC = [[UIViewController alloc] init];
        [childVCs addObject:childVC];
    }
    
    CGRect rect = CGRectMake(0,
                             64,
                             self.view.frame.size.width,
                             self.view.frame.size.height - 64);
    
    JYTitleStyle *style = [JYTitleStyle defaultStyle];
    self.pageView = [[JYPageView alloc] initWithFrame:rect
                                               titles:titles
                                 parentViewController:self
                                 childViewControllers:childVCs style:style];
    [self.view addSubview:self.pageView];
```

