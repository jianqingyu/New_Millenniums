//
//  EditUserInfoCell.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/28.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "EditUserInfoCell.h"
@interface EditUserInfoCell()
@property (weak, nonatomic) IBOutlet UISwitch *showBtn;

@end
@implementation EditUserInfoCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    EditUserInfoCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[EditUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditUserInfoCell" owner:nil
                                          options:nil][0];
    }
    return self;
}

- (void)setMInfo:(MasterCountInfo *)mInfo{
    if (mInfo) {
        _mInfo = mInfo;
        [self.showBtn setOn:_mInfo.isShowOriginalPrice];
        self.shopFie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.modelAddtion];
        self.driFie.text = [NSString stringWithFormat:@"%0.0f",_mInfo.stoneAddtion];
    }
}

- (IBAction)showPriceClick:(UISwitch *)btn {
    NSString *url = [NSString stringWithFormat:@"%@modifyUserIsShowOriginalPriceDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"isNoShow"] = @(btn.on);
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    _mInfo.isShowOriginalPrice = btn.on;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"更新成功"];
        }
    } requestURL:url params:params];
}

- (IBAction)shopAccClick:(id)sender {
    double str = [self.shopFie.text doubleValue];
    str = str-1;
    self.shopFie.text = [NSString stringWithFormat:@"%0.0f",str];
}

- (IBAction)shopAddClick:(id)sender {
    double str = [self.shopFie.text doubleValue];
    str = str+1;
    self.shopFie.text = [NSString stringWithFormat:@"%0.0f",str];
}

- (IBAction)driAccClick:(id)sender {
    double str = [self.driFie.text doubleValue];
    str = str-1;
    self.driFie.text = [NSString stringWithFormat:@"%0.0f",str];
}

- (IBAction)driAddClick:(id)sender {
    double str = [self.driFie.text doubleValue];
    str = str+1;
    self.driFie.text = [NSString stringWithFormat:@"%0.0f",str];
}

@end
