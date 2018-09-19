//
//  XFYSegmentBar.m
//  Pods-XFYSegmentBar_Example
//
//  Created by xufengyuan on 2018/9/18.
//

#import "XFYSegmentBar.h"
#define kShowMoreBtnW (self.bounds.size.height + 30)

@interface XFYSegmentBar()<UICollectionViewDelegate>

/** 用于显示内容选项卡的视图 */
@property (nonatomic, strong) UIScrollView *contentScrollView;

/** 用于标识选项卡的指示器 */
@property (nonatomic, strong) UIView *indicatorView;

/** 用于存储选项按钮数组 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*segBtns;

/** 用于记录上次选项 */
@property (nonatomic, weak) UIButton *lastBtn;

/** 选项卡显示配置, 修改此模型属性之后, 需要调用updateViewWithConfig 生效 */
@property (nonatomic, strong) XFYSegmentConfig *segmentConfig;


@end
@implementation XFYSegmentBar

#pragma mark - 懒加载属性
/** 用于显示内容选项卡的视图 */
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}


/** 用于标识选项卡的指示器 */
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.segmentConfig.indicatorHeight, 0, self.segmentConfig.indicatorHeight)];
        _indicatorView.backgroundColor = self.segmentConfig.indicatorColor;
        [self.contentScrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

/** 用于存储选项卡的数组 */
- (NSMutableArray<UIButton *> *)segBtns
{
    if (!_segBtns) {
        _segBtns = [NSMutableArray array];
    }
    return _segBtns;
}


/**
 *  根据配置选项, 创建一个选项卡条
 *
 *  @param config 选项卡配置
 *
 *  @return 选项卡
 */
+ (instancetype)segmentBarWithConfig: (XFYSegmentConfig *)config {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect defaultFrame = CGRectMake(0, 0, width, 40);
    XFYSegmentBar *segBar = [[XFYSegmentBar alloc] initWithFrame:defaultFrame];
    segBar.segmentConfig = config;
    return segBar;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.segmentConfig = [XFYSegmentConfig defaultConfig];
    }
    return self;
}

/**
 *  监听选项卡配置的改变
 *
 *  @param segmentConfig 选项卡配置模型
 */
- (void)updateViewWithConfig: (void(^)(XFYSegmentConfig *config))configBlock
{
    if (configBlock != nil) {
        configBlock(self.segmentConfig);
    }
    self.segmentConfig = self.segmentConfig;
    
}
-(void)setSegmentConfig:(XFYSegmentConfig *)segmentConfig
{
    _segmentConfig = segmentConfig;
    
    // 指示器颜色
    self.indicatorView.backgroundColor = segmentConfig.indicatorColor;
    CGRect temp = self.indicatorView.frame;
    temp.size.height = segmentConfig.indicatorHeight;
    self.indicatorView.frame = temp;
    
    // 选项颜色/字体
    for (UIButton *btn in self.segBtns) {
        [btn setTitleColor:segmentConfig.segNormalColor forState:UIControlStateNormal];
        if (btn != self.lastBtn) {
            btn.titleLabel.font = segmentConfig.segNormalFont;
        }else {
            btn.titleLabel.font = segmentConfig.segSelectedFont;
        }
        [btn setTitleColor:segmentConfig.segSelectedColor forState:UIControlStateSelected];
    }
    
    // 最小间距
    [self layoutIfNeeded];
    [self layoutSubviews];
    
}
/**
 *  根据配置, 更新视图
 */
- (void)updateViewWithConfig {
    self.segmentConfig = self.segmentConfig;
}

/**
 *  监听选项卡数据源的改变
 *
 *  @param segmentMs 选项卡数据源
 */
-(void)setSegmentMs:(NSArray<id<XFYSegmentModelProtocol>> *)segmentMs
{
    _segmentMs = segmentMs;
    
    // 移除之前所有的子控件
    [self.segBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.segBtns = nil;
    self.lastBtn = nil;
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    
    // 添加最新的子控件
    for (NSObject<XFYSegmentModelProtocol> *segM in segmentMs) {
        UIButton *btn = [[UIButton alloc] init];
        if (segM.segID == -1) {
            btn.tag = self.segBtns.count;
            
        }else {
            btn.tag = segM.segID;
        }
        
        [btn addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = self.segmentConfig.segNormalFont;
        [btn setTitleColor:self.segmentConfig.segNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.segSelectedColor forState:UIControlStateSelected];
        [btn setTitle:segM.segContent forState:UIControlStateNormal];
        [self.contentScrollView addSubview:btn];
        [btn sizeToFit];
        
        // 保存到一个数组中
        [self.segBtns addObject:btn];
        
    }
    // 重新布局
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    
    // 默认选中第一个选项卡
    [self segClick:[self.segBtns firstObject]];
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    for (UIButton *btn in self.segBtns) {
        if (btn.tag == selectedIndex) {
            [self segClick:btn];
            break;
        }
    }
    
}


/**
 *  点击某个选项卡调用的事件
 */
- (void)segClick: (UIButton *)btn {
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(segmentBarDidSelectIndex:fromIndex:)])
    {
        _selectedIndex = btn.tag;
        [self.delegate segmentBarDidSelectIndex:_selectedIndex fromIndex:self.lastBtn.tag];
    }
    
    // 修改状态
    self.lastBtn.selected = NO;
    self.lastBtn.titleLabel.font = self.segmentConfig.segNormalFont;
    [self.lastBtn sizeToFit];
    CGRect lastButtonTemp = self.lastBtn.frame;
    lastButtonTemp.size.height = self.contentScrollView.frame.size.height - self.segmentConfig.indicatorHeight;
    self.lastBtn.frame = lastButtonTemp;
    
    
    btn.selected = YES;
    btn.titleLabel.font = self.segmentConfig.segSelectedFont;
    [btn sizeToFit];
    CGRect btnTemp = btn.frame;
    btnTemp.size.height = self.contentScrollView.frame.size.height - self.segmentConfig.indicatorHeight;
    btn.frame = btnTemp;
    self.lastBtn = btn;
    
    // 移动指示器位置
    [UIView animateWithDuration:0.2 animations:^{
        
        // 控制宽度, 和中心
        NSString *text = btn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : btn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        
        CGRect indicatorViewTemp = self.indicatorView.frame;
        indicatorViewTemp.origin.y = self.contentScrollView.frame.size.height - self.segmentConfig.indicatorHeight;
        indicatorViewTemp.size.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.frame = indicatorViewTemp;
        
        CGPoint indicatorViewCenter = self.indicatorView.center;
        indicatorViewCenter.x = btn.center.x;
        self.indicatorView.center = indicatorViewCenter;
        
    }];
    
    
    // 自动滚动到中间位置
    CGFloat shouldScrollX = btn.center.x - self.contentScrollView.frame.size.width * 0.5;
    
    if (shouldScrollX < 0) {
        shouldScrollX = 0;
    }
    
    if (shouldScrollX > self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width) {
        shouldScrollX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
    }
    
    [self.contentScrollView setContentOffset:CGPointMake(shouldScrollX, 0) animated:YES];
    
    
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentScrollView.frame = self.bounds;
    
    self.contentScrollView.frame = self.bounds;
  
    
    
    // 1. 计算间距
    CGFloat titleTotalW = 0;
    for (int i = 0; i < self.segBtns.count; i++)  {
        [self.segBtns[i] sizeToFit];
        CGFloat width = self.segBtns[i].frame.size.width;
        titleTotalW += width;
    }
    
    CGFloat margin = (self.contentScrollView.frame.size.width - titleTotalW) / (self.segmentMs.count + 1);
    margin = margin < self.segmentConfig.limitMargin ? self.segmentConfig.limitMargin : margin;
    
    
    // 布局topmMenue 内部控件
    CGFloat btnY = 0;
    
    CGFloat btnHeight = self.contentScrollView.frame.size.height - self.segmentConfig.indicatorHeight;
    UIButton *lastBtn;
    for (int i = 0; i < self.segBtns.count; i++) {
        
        // 计算每个控件的宽度
        CGFloat btnX = CGRectGetMaxX(lastBtn.frame) + margin;
        CGRect tempRect = self.segBtns[i].frame;
        tempRect.origin.x = btnX;
        tempRect.origin.y = btnY;
        tempRect.size.height = btnHeight;
        self.segBtns[i].frame = tempRect;
        lastBtn = self.segBtns[i];
        
    }
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + margin, 0);
    
    
    // 修正指示器的位置, 控制宽度, 和中心
    if (self.lastBtn) {
        NSString *text = self.lastBtn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : self.lastBtn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        
        CGRect indicatorViewTemp = self.indicatorView.frame;
        
        indicatorViewTemp.origin.y = self.contentScrollView.frame.size.height - self.segmentConfig.indicatorHeight;
        indicatorViewTemp.size.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.frame = indicatorViewTemp;
        
        CGPoint center = self.indicatorView.center;
        center.x = self.lastBtn.center.x;
        self.indicatorView.center = center;
    }
    
    
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
}

@end

