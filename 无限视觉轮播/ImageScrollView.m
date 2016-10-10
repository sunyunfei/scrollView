//
//  ImageScrollView.m
//  无限视觉轮播
//
//  Created by 孙云飞 on 2016/10/9.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ImageScrollView.h"
@interface ImageScrollView()<UIScrollViewDelegate>
@end
@implementation ImageScrollView

//构造,用于做图片的视觉效果
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.decelerationRate = 0.1f;

    }
    return self;
}
@end
