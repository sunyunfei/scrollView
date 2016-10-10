//
//  CoreScrollView.m
//  无限视觉轮播
//
//  Created by 孙云飞 on 2016/10/9.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "CoreScrollView.h"
#import "ImageScrollView.h"
static NSInteger k_tagMargin = 1000;
@interface CoreScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *coreView;
@property(nonatomic,strong)NSArray *dataArray;//数据
@property(nonatomic,strong)NSTimer *scrTimer;//轮播时间
@property(nonatomic,strong)UIPageControl *pageControl;//小点
@end
@implementation CoreScrollView

//构造
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        //设置
        self.coreView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.coreView.delegate = self;
        self.coreView.pagingEnabled = YES;
        self.coreView.decelerationRate = 0.1f;
        [self addSubview:self.coreView];
        //开始加载内部ui
        [self p_loadUI];
        //轮播时间设置
        [self p_setScrTimer];
    }
    return self;
}

#pragma mark ----自动轮播设置
- (void)p_setScrTimer{

    self.scrTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(p_scrAgainTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scrTimer forMode:NSRunLoopCommonModes];
}
//轮播时间事件
- (void)p_scrAgainTimer{

    [self.coreView setContentOffset:CGPointMake(self.coreView.contentOffset.x + CGRectGetWidth(self.frame), 0) animated:YES];
    [self p_dealPageCurrent];
    [self p_alwaysScrollView];
}
#pragma mark-----数据ui加载
//懒加载
- (NSArray *)dataArray{

    if (!_dataArray) {
       _dataArray = @[@"11.jpg",@"22.jpg",@"33.jpg"];
    }
    return _dataArray;
}
//ui加载
- (void)p_loadUI{

    
    for(int i = 0;i < self.dataArray.count + 2;i ++){
    
        ImageScrollView *imageScr = [[ImageScrollView alloc]initWithFrame:CGRectMake(i * CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        imageScr.tag = i + k_tagMargin;
        
        if (i <= 0) {
           imageScr.imageView.image = [UIImage imageNamed:self.dataArray[self.dataArray.count - 1]];
        }else if (i >= self.dataArray.count + 1){
        
            imageScr.imageView.image = [UIImage imageNamed:self.dataArray[0]];
        }else{
        
            imageScr.imageView.image = [UIImage imageNamed:self.dataArray[i - 1]];
        }
        
        [self.coreView addSubview:imageScr];
        
    }
    self.coreView.contentSize = CGSizeMake((self.dataArray.count + 2) * CGRectGetWidth(self.frame), 0);
    
    //默认显示的是处于下标为1的位置
    [self.coreView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
    
    //设置page
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 50, CGRectGetWidth(self.frame), 50)];
    self.pageControl.numberOfPages = self.dataArray.count;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:self.pageControl];
}

#pragma mark ----代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.scrTimer invalidate];
    self.scrTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self p_setScrTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self p_dealPageCurrent];
    //无限轮播的转换
    [self p_alwaysScrollView];
    //图片视觉效果处理
    [self p_visionDeal];
    
}

//防止有白边的出现，最后确认当前显示的图片内部偏移量为0
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int intX = self.coreView.contentOffset.x / CGRectGetWidth(self.frame);
    //获取到tag对应的图片(要注意是否是两端的图片)
    ImageScrollView *nowImageScr = [self viewWithTag:intX + k_tagMargin];
    if (nowImageScr) {
        [nowImageScr setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark -----两个核心方法
- (void)p_dealPageCurrent{

    //page的变动
    int intX = (self.coreView.contentOffset.x) / CGRectGetWidth(self.frame);
    if (intX <= 1) {
        self.pageControl.currentPage = 0;
    }else if (intX >= self.dataArray.count){
        
        self.pageControl.currentPage = self.dataArray.count;
    }else{
        
        self.pageControl.currentPage = intX - 1;
    }
}
//无限轮播处理
- (void)p_alwaysScrollView{

    //判断是否处于将要改变顺序的两个位置
    if (self.coreView.contentOffset.x == 0) {
       //转换到最后一个
        [self.coreView setContentOffset:CGPointMake((self.dataArray.count) * CGRectGetWidth(self.frame), 0) animated:NO];
    }else if (self.coreView.contentOffset.x == (self.dataArray.count + 1) * CGRectGetWidth(self.frame)){
        
        //转换到第一个
        [self.coreView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
    }
}

//视觉效果处理
- (void)p_visionDeal{

    int intX = self.coreView.contentOffset.x / CGRectGetWidth(self.frame);
    //获取到tag对应的图片(要注意是否是两端的图片)
    ImageScrollView *nowImageScr = [self viewWithTag:intX + k_tagMargin + 1];
    if (nowImageScr && (self.coreView.contentOffset.x - intX * CGRectGetWidth(self.frame))/2 <= CGRectGetWidth(self.frame) / 2) {
    [nowImageScr setContentOffset:CGPointMake(-(self.coreView.contentOffset.x - intX * CGRectGetWidth(self.frame))/2 + CGRectGetWidth(self.frame) / 2, 0) animated:NO];
    }
    
    //判断其他的页是否正常，如果不正常转换过来
    for(int i = 0; i < self.dataArray.count + 2; i++){
        if(i != intX + 1){
        
            ImageScrollView *nowImageScr1 = [self viewWithTag:i + k_tagMargin];
            if (nowImageScr1 && nowImageScr1.contentOffset.x != 0) {
                [nowImageScr1 setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
        
    }
}

@end
