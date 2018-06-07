//
//  ViewController.m
//  FCCarouselControl
//
//  Created by 魏晓堃 on 2018/6/7.
//  Copyright © 2018年 魏晓堃. All rights reserved.
//

#import "ViewController.h"
#import "FCCarouselView.h"

@interface ViewController ()

@property(nonatomic, strong) FCCarouselView *carouseView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    _carouseView = ({
        FCCarouselView *view = [[FCCarouselView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenFrame), 250)];
        view.maxNumber = 9;
        view.backgroundColor = [UIColor cyanColor];
        view;
    });
    [self.view addSubview:_carouseView];
    
    // 异步线程模拟耗时操作

    
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)imgLoad:(id)sender {
    for (int i = 0; i < 9; i ++) {
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int sleepTime = arc4random() % (10 - 0);
            [NSThread sleepForTimeInterval:sleepTime];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.carouseView setImage:img index:i];
            });
        });
    }
}

- (IBAction)imgListLoad:(id)sender {
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 9; i ++) {
        [imgArr addObject:[UIImage imageNamed:@"placeholder"]];
    }
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 9; i ++) {
            int sleepTime = arc4random() % (2 - 0);
            [NSThread sleepForTimeInterval:sleepTime];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
            imgArr[i] = img;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.carouseView setImageArr:imgArr];
        });
    });
    

}

- (IBAction)clean:(id)sender {
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 9; i ++) {
        [imgArr addObject:[UIImage imageNamed:@"placeholder"]];
    }
    [_carouseView setImageArr:imgArr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
