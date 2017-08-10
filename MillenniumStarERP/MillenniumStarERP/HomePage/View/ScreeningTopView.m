//
//  ScreeningTopView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ScreeningTopView.h"
#import "ScreeningInfo.h"
#import "ScreenDetailInfo.h"
@interface ScreeningTopView ()
@property (nonatomic,strong)NSMutableArray *mutA;
@property (nonatomic,strong)NSMutableArray *mutB;
@end
@implementation ScreeningTopView

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = DefaultColor;
        self.mutA = @[].mutableCopy;
        self.mutB = @[].mutableCopy;
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"已选条件";
        lab.textColor = [UIColor redColor];
        lab.font = [UIFont systemFontOfSize:16];
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
        }];
    }
    return self;
}

- (void)setGoods:(NSArray *)goods{
    if (goods) {
        _goods = goods;
        [self.mutA removeAllObjects];
        for (ScreeningInfo *info in _goods) {
            for (ScreenDetailInfo *dInfo in info.attributeList) {
                if (dInfo.isSelect) {
                    [self.mutA addObject:dInfo];
                }
            }
        }
        for (UIButton *btn in _mutB) {
            [btn removeFromSuperview];
        }
        int num = 4;
        CGFloat labH = 30;
        CGFloat height = 24;
        CGFloat width = (self.width - 5*5)/4;
        if (width<0) {
            width = (MIN(SDevWidth, SDevHeight)*0.8 - 5*5)/4;
        }
        for (int i=0; i<self.mutA.count; i++) {
            int column = i % num;
            int row = i / num;
            ScreenDetailInfo *dInfo = self.mutA[i];
            UIButton *btn = [self creatBtn];
            btn.frame = CGRectMake((width+5)*column+5,labH+(height+5)*row,width, height);
            btn.tag = i;
            NSString *title = [NSString stringWithFormat:@"x %@",dInfo.title];
            [btn setTitle:title forState:UIControlStateNormal];
            [self.mutB addObject:btn];
        }
    }
}

- (UIButton *)creatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn setLayerWithW:5 andColor:MAIN_COLOR andBackW:1];
    [btn addTarget:self action:@selector(subCateBtnAction:)
                                 forControlEvents:UIControlEventTouchUpInside]; 
    [self addSubview:btn];
    return btn;
}

- (void)subCateBtnAction:(UIButton *)btn{
    ScreenDetailInfo *dInfo = self.mutA[btn.tag];
    dInfo.isSelect = NO;
    [btn removeFromSuperview];
    [self.mutB removeObject:btn];
    if (self.back) {
        self.back(_goods);
    }
}

@end
