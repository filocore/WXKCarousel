//
//  FCCarouselView.m
//  FCCarouselControl
//
//  Created by 魏晓堃 on 2018/6/7.
//  Copyright © 2018年 魏晓堃. All rights reserved.
//

#import "WXKCarouselView.h"

static CGFloat viewWidth = 0.f;
static CGFloat viewHeight = 0.f;
static NSInteger carouseTag = 1000;
static NSInteger curentPage = 0;

@interface WXKCarouselView() <UIScrollViewDelegate>

@property(nonatomic, strong) NSMutableArray *imgArr;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation WXKCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewWidth = CGRectGetWidth(frame);
        viewHeight = CGRectGetHeight(frame);
    }
    return self;
}

static UIColor * _Nonnull extracted() {
    return [UIColor clearColor];
}

- (void)setupUI {
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.contentSize = CGSizeMake(viewWidth * 3, viewHeight);
        scrollView.contentOffset = CGPointMake(viewWidth, 0);
        scrollView.backgroundColor = extracted();
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        scrollView;
    });
    
    
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth * i, 0, viewWidth, viewHeight)];
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i - 1 < 0 ? ABS(i + 1 - _maxNumber) : i - 1]];
//        UIImage *img = [UIImage imageNamed:@"placeholder"];
        UIImage *img = self.imgArr[i - 1 < 0 ? ABS(i + 1 - _maxNumber) : i - 1];
        imgView.image = img;
        imgView.tag = carouseTag + i;
        [_scrollView addSubview:imgView];
    }
    
    _pageControl = ({
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 50, viewWidth, 50)];
        pageControl.backgroundColor = [UIColor blackColor];
        pageControl.alpha = 0.5;
        pageControl.numberOfPages = _maxNumber - 1;
        [self addSubview:pageControl];
        pageControl;
    });
    
    
    [self resetTimeer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        // 上一页
        curentPage = curentPage == 0 ? ABS(curentPage - (_maxNumber - 1)) : curentPage - 1;
        [self resetCarousel:scrollView];
    } else if (scrollView.contentOffset.x == 2 * viewWidth) {
        // 下一页
        curentPage = curentPage == _maxNumber - 1 ? 0 : curentPage + 1;
        [self resetCarousel:scrollView];
    } else {
        
    }
    _pageControl.currentPage = curentPage;
    [self resetTimeer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetTimeer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetTimeer];
}

#pragma mark -- action response


#pragma mark -- private methods

- (void)resetCarousel:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(viewWidth, 0)];
    UIImageView *curImgView = [_scrollView viewWithTag:carouseTag + 1];
    UIImageView *lastImgView = [_scrollView viewWithTag:carouseTag];
    UIImageView *nextImgView = [_scrollView viewWithTag:carouseTag + 2];
    curImgView.image = self.imgArr[curentPage];
    lastImgView.image = self.imgArr[curentPage - 1 < 0 ? _maxNumber - 1 : curentPage - 1];
    nextImgView.image = self.imgArr[curentPage + 1 >= _maxNumber ? 0 : curentPage + 1];
}

- (void)reloadCurImageView {
    UIImageView *curImgView = [_scrollView viewWithTag:carouseTag + 1];
    curImgView.image = self.imgArr[curentPage];
}

- (void)scrollToNext {
    if (_scrollView.isDragging || _scrollView.isDecelerating) {
        return;
    }
    [_scrollView setContentOffset:CGPointMake(2 * viewWidth, 0) animated:YES];
}


- (void)resetTimeer {
    [self endTimer];
    [self startTimer];
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
}

- (void)endTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- setters and getters

- (void)setMaxNumber:(int)maxNumber {
    _maxNumber = maxNumber;
    for (int i = 0; i < maxNumber; i ++) {
        UIImage *img = [UIImage imageNamed:@"placeholder"];
        [self.imgArr addObject:img];
    }
    [self setupUI];
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

- (void)setImage:(UIImage *)image index:(NSInteger)index {
    self.imgArr[index] = image;
    [self reloadCurImageView];
}

- (void)setImageArr:(NSArray<UIImage *> *)imgArr {
    self.imgArr = [imgArr mutableCopy];
    [self reloadCurImageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
