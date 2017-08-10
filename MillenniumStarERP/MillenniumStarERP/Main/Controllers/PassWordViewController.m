//
//  PassWordViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/7.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PassWordViewController.h"
#import "YQItemTool.h"
#import "ZBButten.h"
@interface PassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWord2;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic,  copy) NSString *code;
@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:
      [UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStyleDone target:
                                                   self action:@selector(back)];
    [self setBaseView];
}

- (void)setBaseView{
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

- (void)back{
    if (self.isForgot) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)getCode:(id)sender {
    if (self.phoneFie.text.length!=11) {
        SHOWALERTVIEW(@"您输入的手机号有误");
        return;
    }
    //发送命令
    [self requestCheckWord];
}

- (void)requestCheckWord
{
    NSString *codeUrl;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isForgot) {
        params[@"phone"] = self.phoneFie.text;
        codeUrl = [NSString stringWithFormat:@"%@GetForgetPasswordVerifyCodeDo",baseUrl];
    }else{
        params[@"tokenKey"] = [AccountTool account].tokenKey;
        codeUrl = [NSString stringWithFormat:@"%@GetUserModifyPasswordVerifyCodeDo",baseUrl];
    }
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:response.message];
        }else{
            [self.codeBtn resetBtn];
            SHOWALERTVIEW(response.message);
        }
    } requestURL:codeUrl params:params];
}

- (IBAction)confirmClick:(id)sender {
    if (self.codeFie.text==0) {
        SHOWALERTVIEW(@"验证码输入有误");
    }else if (![self.passWord.text isEqualToString:self.passWord2.text]||self.passWord.text.length<5){
        SHOWALERTVIEW(@"密码输入错误");
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *passUrl;
        if (self.isForgot) {
            params[@"password"] = self.passWord.text;
            params[@"phoneCode"] = self.codeFie.text;
            params[@"phone"] = self.phoneFie.text;
            passUrl = [NSString stringWithFormat:@"%@userForgetPasswordDo",baseUrl];
        }else{
            params[@"password"] = self.passWord.text;
            params[@"phoneCode"] = self.codeFie.text;
            params[@"tokenKey"] = [AccountTool account].tokenKey;
            passUrl = [NSString stringWithFormat:@"%@userModifyPasswordDo",baseUrl];
        }
        [self loadNetEditPassWithDic:params andUrl:passUrl];
    }
}
//修改密码与忘记密码
- (void)loadNetEditPassWithDic:(NSMutableDictionary*)params andUrl:(NSString *)passUrl{
    [BaseApi getNoLogGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            params[@"userName"] = [AccountTool account].userName;
            params[@"phoneCode"] = [AccountTool account].phone;
            params[@"isShow"] = [AccountTool account].isShow;
            params[@"isNorm"] = [AccountTool account].isNorm;
            params[@"tokenKey"] = response.data[@"tokenKey"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            [MBProgressHUD showSuccess:response.message];
            [self back];
        }else{
            SHOWALERTVIEW(response.message);
        }
        [SVProgressHUD dismiss];
    } requestURL:passUrl params:params];
}

@end
