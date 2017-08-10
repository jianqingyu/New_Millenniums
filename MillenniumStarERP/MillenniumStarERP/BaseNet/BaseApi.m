//
//  BaseApi.m
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "BaseApi.h"
#import "RequestClient.h"
#import "ShowLoginViewTool.h"
#import "LoginViewController.h"
@implementation BaseApi

+ (void)getNoLogGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [[BaseResponse alloc]init];
        result.error = responseObject[@"error"];
        result.data = responseObject[@"data"];
        result.message = responseObject[@"message"];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
//更新数据接口
+ (void)upData:(REQUEST_CALLBACK)callback URL:(NSString*)URL params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[RequestClient sharedClient] GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [[BaseResponse alloc]init];
        result.error = responseObject[@"error"];
        result.data = responseObject[@"data"];
        result.message = responseObject[@"message"];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*通用GET接口弹出登录
 */
+ (void)getGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                             params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [[BaseResponse alloc]init];
        result.error = responseObject[@"error"];
        result.data = responseObject[@"data"];
        result.message = responseObject[@"message"];
        if ([result.error intValue]==2) {
            UIViewController *vc = [ShowLoginViewTool getCurrentVC];
            LoginViewController *login = [LoginViewController new];
            login.noLogin = YES;
            [vc presentViewController:login animated:YES completion:nil];
            [SVProgressHUD dismiss];
            return ;
        }
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*通用POST接口
 */
+ (void)postGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                            params:(NSMutableDictionary*)params{
    params[@"QxVersion"] = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[RequestClient sharedClient] POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse*result = [[BaseResponse alloc]init];
        result.error = responseObject[@"error"];
        result.data = responseObject[@"data"];
        result.message = responseObject[@"message"];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
//清楚队列
+ (void)cancelAllOperation{
    [[RequestClient sharedClient].operationQueue cancelAllOperations];
}

@end
