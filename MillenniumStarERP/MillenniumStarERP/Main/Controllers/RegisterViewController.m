//
//  RegisterViewController.m
//  CityHousekeeper
//
//  Created by yjq on 15/11/18.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "PackagingTool.h"
#import "ZBButten.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *userFie;
@property (weak, nonatomic) IBOutlet UITextField *namefie;
@property (weak, nonatomic) IBOutlet UITextField *phonefie;
@property (weak, nonatomic) IBOutlet UITextField *keyfie;
@property (weak, nonatomic) IBOutlet UITextField *keyfie2;
@property (weak, nonatomic) IBOutlet UITextField *codefie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) int userType;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
              [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone
                                       target:self action:@selector(backClick)];
    [self setBaseView];
    self.userType = 1;
}

- (void)backClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBaseView{
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    self.codeBtn.layer.cornerRadius = 2;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

- (IBAction)getCode:(UIButton *)btn{
    if (self.phonefie.text.length!=11) {
        SHOWALERTVIEW(@"您输入的手机号有误");
        return;
    }
    //发送命令
    [self requestCheckWord];
}

- (void)requestCheckWord
{
    NSString *codeUrl = [NSString stringWithFormat:@"%@GetRegisterVerifyCodeDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phonefie.text;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
        }else{
            [self.codeBtn resetBtn];
            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (IBAction)chooseClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.userType = sender.selected?2:1;
}

- (IBAction)nextClick:(id)sender {
    if ([PackagingTool stringContainsEmoji:self.userFie.text]) {
        SHOWALERTVIEW(@"不能输入特殊符号");
        return;
    }
    if (![self.keyfie.text isEqualToString:self.keyfie2.text]||self.keyfie.text.length<5){
        SHOWALERTVIEW(@"密码输入错误");
        return;
    }
    [SVProgressHUD show];
    NSString *regiUrl = [NSString stringWithFormat:@"%@userRegisterDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = self.userFie.text;
    params[@"password"] = self.keyfie.text;
    params[@"trueName"] = self.namefie.text;
    params[@"phone"] = self.phonefie.text;
    params[@"phoneCode"] = self.codefie.text;
    params[@"userType"] = @(self.userType);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"isShow"] = [AccountTool account].isShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            [self backClick];
            [MBProgressHUD showSuccess:@"注册成功"];
        }else{
            SHOWALERTVIEW(response.message);
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

@end
