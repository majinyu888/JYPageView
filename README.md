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
#### 3.声明一个属性
    @property (nonatomic, strong) JYPageView *pageView;
#### 4.禁止掉ViewController自身的一个属性
   self.automaticallyAdjustsScrollViewInsets = NO;
#### 5.添加到self.view上面即可

``` Objective-C

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
    style.titleHeight = 44;
    self.pageView = [[JYPageView alloc] initWithFrame:rect
                                                style:style
                                               titles:titles
                                 parentViewController:self
                                 childViewControllers:childVCs];
    self.pageView.delegate = self;
    [self.view addSubview:self.pageView];

```

#### 如果您想要监听滑动事件,可以声明并且实现代理:JYPageViewDelegate

``` Objective-C
#pragma mark - Delegate

- (void)JYPageView:(JYPageView *)pageView didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}
```
