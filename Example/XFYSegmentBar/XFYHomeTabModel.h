//
//  XFYHomeTabModel.h
//  XFYSegmentBar_Example
//
//  Created by xufengyuan on 2018/9/18.
//  Copyright © 2018年 xufengyuan@vip.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFYSegmentModelProtocol.h"
@interface XFYHomeTabModel : NSObject <XFYSegmentModelProtocol>
/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
@property (nonatomic, assign) NSInteger segID;

/** 选项卡内容 */
@property (nonatomic, copy) NSString *segContent;
@end
