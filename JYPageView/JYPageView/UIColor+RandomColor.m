//
//  UIColor+RandomColor.m
//  JYPageController
//
//  Created by hb on 2017/4/14.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (instancetype)randomColor
{
    int r = arc4random()%255;
    int g = arc4random()%255;
    int b = arc4random()%255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
