//
//  TagView.m
//  TagDemo
//
//  Created by lxb on 2018/7/20.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "TagView.h"
#import "UIView+MJExtension.h"

static const float tagMargin = 10.f;
static const float verMargin = 15.f;

@interface TagView ()
@property (nonatomic) NSMutableArray *tagLabels;
@property (nonatomic) NSArray *tags;
@end

@implementation TagView


- (NSMutableArray *)tagLabels {
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (instancetype)initWithTags:(NSArray *)tags {
    if (self = [super init]) {
        self.tags = tags;
        [self setupUI];
    }
    return self;
}

/** 排布评语标签 */
- (void)setupUI {
    
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    for (int i = 0; i < self.tags.count; i++) {
        UILabel *label = [self tagLabelWithText:self.tags[i]];
        [self.tagLabels addObject:label];
        
        label.mj_w += 2 * tagMargin;
        label.mj_h = 25;
        [self addSubview:label];
        
        if (label.mj_w > screenW - 2*tagMargin) {
            label.mj_w = screenW - 2*tagMargin;
        }
        
        //设置位置
        if (i == 0) {  //最前面的标签
            label.mj_x = tagMargin;
            label.mj_y = verMargin;
        } else {  //其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + tagMargin;
            ////计算当前行右边的宽度
            CGFloat rightWidth = screenW - leftWidth;
            if (rightWidth >= label.mj_w) { //标签显示在当前行
                label.mj_y = lastTagLabel.mj_y;
                label.mj_x = leftWidth;
            } else {  //标签显示在下一行
                label.mj_x = tagMargin;
                label.mj_y = CGRectGetMaxY(lastTagLabel.frame) + verMargin;
            }
        }
        
    }
}

/** 计算view的高度 */
- (CGFloat)tagViewHeight {
    NSInteger tagCount = self.tags.count;
    CGFloat totalHeight = 0;
    if (tagCount) {
        //取最后一个tagLabel的y值
        UILabel *lastTagLabel = self.tagLabels[tagCount - 1];
        totalHeight = CGRectGetMaxY(lastTagLabel.frame) + verMargin;
    }
    return totalHeight;
}

- (UILabel *)tagLabelWithText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 12;
    label.layer.masksToBounds = YES;
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

@end
