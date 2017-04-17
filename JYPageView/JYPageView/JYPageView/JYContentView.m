//
//  JYContentView.m
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "JYContentView.h"
#import "JYTitleView.h"

@interface JYContentView()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
JYTitleViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign) NSInteger currentIndex; // 当前vc的下标 默认是0
@property (nonatomic, assign) BOOL isForbidScroll; // default is NO


@end


@implementation JYContentView

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parent
         childViewControllers:(NSArray<UIViewController *> *)childs
{
    if (!parent) return nil;
    if (!childs) return nil;
    
    if (self = [super initWithFrame:frame]) {
        self.parentViewController = parent;
        self.childViewControllers = childs;
        ///
        for (UIViewController *vc in self.childViewControllers) {
            [self.parentViewController addChildViewController:vc];
        }
        [self addSubview:self.collectionView];
        
        return self;
    } else {
        return nil;
    }
}

#pragma mark - CollectonView

static NSString *kContentCellID = @"kContentCellID";

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        /// 布局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma mark - CollectionView Datasource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    UIViewController *childViewController = self.childViewControllers[indexPath.item];
    childViewController.view.frame = cell.contentView.bounds;
    [cell addSubview:childViewController.view];// 为什么cell.contentView addSubview不好使呢, 谁能告诉我呢
    return cell;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self contentViewEndScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self contentViewEndScroll];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isForbidScroll = YES;
}

/// 自定义处理方法
- (void)contentViewEndScroll
{
    if (!self.isForbidScroll) {
        return;
    }
    
    _currentIndex = (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYContentView:didSelectedItemAtIndex:)]) {
        [self.delegate JYContentView:self didSelectedItemAtIndex:_currentIndex];
    }
}

#pragma mark - JYTitleview Delegate

- (void)JYTitleView:(JYTitleView *)titleView didSelectedItemAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}



@end
