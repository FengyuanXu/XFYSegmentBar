//
//  XFYSegmentModelProtocol.h
//  Pods
//
//  Created by xufengyuan on 2018/9/18.
//

#pragma mark - 模型必须遵循的协议

@protocol XFYSegmentModelProtocol <NSObject>

/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
@property (nonatomic, assign, readonly) NSInteger segID;

/** 选项卡内容 */
@property (nonatomic, copy) NSString *segContent;

@end
