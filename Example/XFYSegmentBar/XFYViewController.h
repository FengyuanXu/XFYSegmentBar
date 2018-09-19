//
//  XFYViewController.h
//  XFYSegmentBar
//
//  Created by xufengyuan@vip.qq.com on 09/18/2018.
//  Copyright (c) 2018 xufengyuan@vip.qq.com. All rights reserved.
//

@import UIKit;

@interface XFYViewController : UIViewController
/// 选项卡选中的索引
@property (nonatomic, assign) NSInteger segSelectIndex;

/// segBar的位置
@property (nonatomic, assign) CGRect segBarFrame;

/// 内容视图的位置大小
@property (nonatomic, assign) CGRect contentScrollViewFrame;

/// 设置选项卡模型和子控制器
- (void)setUpWithSegModels:(NSArray *)segMs andChildVCs:(NSArray *)subVCs;
@end
