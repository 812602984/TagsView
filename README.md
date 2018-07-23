# TagsView
标签排布

#How To Use：

#import <TagView.h>
...
CGFloat tagsViewWidth = [UIScreen mainScreen].bounds.size.width;
NSArray *tags = @[@"优秀", @"十分优秀", @"很优秀", @"最优秀", @"真TM优秀", @"过分优秀了喔", @"优秀的已经飘起来了", @"优秀的想要上天", @"优秀的已经上天", @"优秀", @"优秀", @"优秀"];
TagView *tagView = [[TagView alloc] initWithTags:tags];
CGFloat tagViewHeight  = [tagView tagViewHeight];
tagView.frame = CGRectMake(0, 100, tagsViewWidth, tagViewHeight);
[self.view addSubview:tagView];


