//
//  TagsView.m
//  TagDemo
//
//  Created by lxb on 2018/7/20.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "TagsView.h"
#import "UIView+MJExtension.h"

static const float tagMargin = 10.f;
static const float verMargin = 15.f;
NSInteger row = 0;

@interface TagsView ()
@property (nonatomic) NSMutableArray *tagLabels;
@property (nonatomic) NSArray *tags;
@property (nonatomic) NSMutableArray *tagLineViews;
@end

@implementation TagsView

- (NSMutableArray *)tagLabels {
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (NSMutableArray *)tagLineViews {
    if (!_tagLineViews) {
        _tagLineViews = [NSMutableArray array];
    }
    return _tagLineViews;
}

- (instancetype)initWithTags:(NSArray *)tags {
    if (self = [super init]) {
        self.tags = tags;
        [self setupUI];
    }
    return self;
}

/** 排布标签 */
- (void)setupUI {
    
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    [self.tagLineViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLineViews removeAllObjects];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < self.tags.count; i++) {
        UILabel *label = [self tagLabelWithText:self.tags[i]];
        [self.tagLabels addObject:label];

        label.mj_w += 2 * tagMargin;
        label.mj_h = 25;
        
        if (label.mj_w > screenW - 2*tagMargin) {
            label.mj_w = screenW - 2*tagMargin;
        }
        
        //设置位置
        if (i == 0) {  //最前面的标签
            label.mj_x = 0;
            label.mj_y = 0;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(tagMargin, verMargin, label.mj_w, label.mj_h)];
            [view addSubview:label];
            [self addSubview:view];
            [self.tagLineViews addObject:view];
            
        } else {  //其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + tagMargin;
            //计算当前行右边的宽度
            CGFloat rightWidth = screenW - leftWidth;
            if (rightWidth >= label.mj_w) { //标签显示在当前行
                label.mj_y = lastTagLabel.mj_y;
                label.mj_x = leftWidth;
                
                if (rightWidth > label.mj_w) {
                    UIView *view = self.tagLineViews[row];
                    view.mj_w = leftWidth + label.mj_w - view.mj_x + tagMargin;
                    [view addSubview:label];
                    [self addSubview:view];
                }
                
            } else {  //标签显示在下一行
                //先取出上一行的view，将其居中
                UIView *lastView = self.tagLineViews[row];
                lastView.mj_x = (screenW - lastView.mj_w) * 0.5;
                
                row++;
                label.mj_x = 0;
                label.mj_y = 0;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(tagMargin, 0, label.mj_w, label.mj_h)];
                view.mj_y = CGRectGetMaxY(lastView.frame) + verMargin;
                [view addSubview:label];
                [self addSubview:view];
                [self.tagLineViews addObject:view];
            }
        }
        
    }
    
    //最后一行重新排布
    if (self.tags.count) {
        UIView *lastView = self.tagLineViews[row];
        lastView.mj_x = (screenW - lastView.mj_w) * 0.5;
    }
}

/** 计算view的高度 */
- (CGFloat)tagsViewHeight {
    NSInteger tagCount = self.tags.count;
    CGFloat totalHeight = 0;
    if (tagCount) {
        //取最后一个tagView的y值
        UIView *lastTagView = self.tagLineViews[row];
        totalHeight = CGRectGetMaxY(lastTagView.frame) + verMargin;
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
