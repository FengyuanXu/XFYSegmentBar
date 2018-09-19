//
//  XFYViewController.m
//  XFYSegmentBar
//
//  Created by xufengyuan@vip.qq.com on 09/18/2018.
//  Copyright (c) 2018 xufengyuan@vip.qq.com. All rights reserved.
//

#import "XFYViewController.h"
#import "XFYSegmentBar.h"
#import "XFYHomeTabModel.h"
#import "XFYOneViewController.h"
#import "XFYTwoViewController.h"
#import "XFYThreeViewController.h"
#import "XFYFourViewController.h"
#import "XFYFiveViewController.h"
// 屏幕尺寸相关
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 发现 顶部 菜单栏的高度
CGFloat const kMenueBarHeight = 35;

// 导航栏的高度
CGFloat const kNavigationBarMaxY = 64;

// tabbar的高度
CGFloat const kTabbarHeight = 0;

@interface XFYViewController ()<XFYSegmentBarDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) XFYSegmentBar *segmentBar;

@property (nonatomic, weak) UIScrollView *contentScrollView;
@end

@implementation XFYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.segBarFrame = CGRectMake(0, kNavigationBarMaxY, kScreenWidth, kMenueBarHeight);
    self.contentScrollViewFrame = CGRectMake(0, kNavigationBarMaxY + kMenueBarHeight, kScreenWidth, kScreenHeight - kNavigationBarMaxY - kTabbarHeight - kMenueBarHeight);
    
    XFYHomeTabModel *model1 = [[XFYHomeTabModel alloc] init];
    model1.segID = 1;
    model1.segContent = @"推荐";
    
    XFYHomeTabModel *model2 = [[XFYHomeTabModel alloc] init];
    model2.segID = 2;
    model2.segContent = @"本地";
    
    XFYHomeTabModel *model3 = [[XFYHomeTabModel alloc] init];
    model3.segID = 3;
    model3.segContent = @"娱乐";
    
    XFYHomeTabModel *model4 = [[XFYHomeTabModel alloc] init];
    model4.segID = 4;
    model4.segContent = @"手机";
    
    XFYHomeTabModel *model5 = [[XFYHomeTabModel alloc] init];
    model5.segID = 5;
    model5.segContent = @"汽车";
    
    
    NSMutableArray *tabMs = [NSMutableArray array];
    [tabMs addObject:model1];
    [tabMs addObject:model2];
    [tabMs addObject:model3];
    [tabMs addObject:model4];
    [tabMs addObject:model5];


    
    [self setUpWithSegModels:tabMs andChildVCs:@[[XFYOneViewController new], [XFYTwoViewController new], [XFYThreeViewController new], [XFYFourViewController new], [XFYFiveViewController new]]];
    self.segSelectIndex = 0;

}


- (void)setUpWithSegModels:(NSArray <id<XFYSegmentModelProtocol>>*)segMs andChildVCs:(NSArray <UIViewController *>*)subVCs {
    
    // 0. 添加子控制器
    for (UIViewController *vc in subVCs) {
        [self addChildViewController:vc];
    }
    
    self.segmentBar.segmentMs = segMs;
    // 1. 设置菜单栏
    [self.view addSubview:self.segmentBar];
    
    // 2. 设置代理
    self.segmentBar.delegate = self;
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, 0);
    
}

-(void)setSegSelectIndex:(NSInteger)segSelectIndex {
    self.segmentBar.selectedIndex = segSelectIndex;
}


- (void)showControllerView:(NSInteger)index {
    
    UIView *view = self.childViewControllers[index].view;
    CGFloat contentViewW = self.contentScrollView.frame.size.width;
    view.frame = CGRectMake(contentViewW * index, 0, contentViewW, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:view];
    [self.contentScrollView setContentOffset:CGPointMake(contentViewW * index, 0) animated:YES];
    
}

- (void)segmentBarDidSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex
{
    [self showControllerView:toIndex];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.segmentBar.selectedIndex = page;
    
}

-(void)setContentScrollViewFrame:(CGRect)contentScrollViewFrame
{
    _contentScrollViewFrame = contentScrollViewFrame;
    self.contentScrollView.frame = _contentScrollViewFrame;
}


-(XFYSegmentBar *)segmentBar {
    if (!_segmentBar) {
        
        XFYSegmentBar *segmentBar = [XFYSegmentBar segmentBarWithConfig:[XFYSegmentConfig defaultConfig]];
        _segmentBar = segmentBar;
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.frame = self.segBarFrame;
        [self.view addSubview:_segmentBar];
    }
    return _segmentBar;
}

-(UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        // 2. 添加内容视图
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentScrollViewFrame];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        _contentScrollView = scrollView;
        [self.view addSubview:scrollView];
    }
    return _contentScrollView;
}
@end
