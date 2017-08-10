//
//  ConfirmOrdCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ConfirmOrdCell.h"
@interface ConfirmOrdCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *baseLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;
@end

@implementation ConfirmOrdCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"conOrdCell";
    ConfirmOrdCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[ConfirmOrdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ConfirmOrdCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setListInfo:(OrderListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        UIButton *btn = self.allBtns[0];
        btn.selected = _listInfo.isSel;
        [self.picImg sd_setImageWithURL:[ NSURL URLWithString:_listInfo.pic] placeholderImage:DefaultImage];
        self.titleLab.text = _listInfo.title;
        self.baseLab.text = _listInfo.baseInfo;
        self.priceLab.hidden = ![[AccountTool account].isShow intValue];
        self.priceLab.text = [OrderNumTool strWithPrice:_listInfo.price];
        self.numLab.text = [NSString stringWithFormat:@"%@件",_listInfo.number];
        self.infoLab.text = _listInfo.info;
    }
}

- (void)setIsBtnHidden:(BOOL)isBtnHidden{
    if (isBtnHidden) {
        _isBtnHidden = isBtnHidden;
        [self.allBtns[0] setHidden:YES];
    }
}

- (void)setIsTopHidden:(BOOL)isTopHidden{
    if (isTopHidden) {
        _isTopHidden = isTopHidden;
        [self.topView removeFromSuperview];
    }
}

- (IBAction)allClick:(UIButton *)sender {
    NSInteger index = [self.allBtns indexOfObject:sender];
    [self.delegate btnCellClick:self andIndex:index];
}

@end
