//
//  FCCarouselView.h
//  FCCarouselControl
//
//  Created by 魏晓堃 on 2018/6/7.
//  Copyright © 2018年 魏晓堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCCarouselView : UIView

@property(nonatomic, assign) int maxNumber;

// 单个图片
- (void)setImage:(UIImage *)image index:(NSInteger)index;

// 批量图片
- (void)setImageArr:(NSArray<UIImage *> *)imgArr;


@end
