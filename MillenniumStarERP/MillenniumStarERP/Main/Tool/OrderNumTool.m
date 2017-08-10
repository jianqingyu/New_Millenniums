//
//  OrderNumTool.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderNumTool.h"

@implementation OrderNumTool

+ (void)orderWithNum:(int)number andView:(UILabel *)sLab{
    if (number>0&&number<=99) {
        sLab.text = [NSString stringWithFormat:@"%d",number];
        sLab.hidden = NO;
    }else if(number>99){
        sLab.text = @"99+";
        sLab.hidden = NO;
    }else{
        sLab.hidden = YES;
    }
}

+ (NSString *)strWithPrice:(float)price{
    return [NSString stringWithFormat:@"￥%0.0f",price];
}

@end
