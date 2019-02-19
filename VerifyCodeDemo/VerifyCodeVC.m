//
//  VerifyCodeVC.m
//  VerifyCodeDemo
//
//  Created by fenglei on 2018/11/26.
//  Copyright © 2018 fenglei. All rights reserved.
//

#import "VerifyCodeVC.h"
#import "VerifyCodeView/VerifyCodeView.h"
#import "Define.h"
#import <Masonry.h>

@interface VerifyCodeVC ()

@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) VerifyCodeView *codeView;

@end

@implementation VerifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self refresh:nil];
    
    _codeView = [[VerifyCodeView alloc]initWithFrame:CGRectZero withCodeLength:4];
    
    __weak __typeof(self) weakSelf = self;
    _codeView.inputTextBlock = ^(NSString *text) {
        if ([text.lowercaseString isEqualToString:weakSelf.codeLabel.text.lowercaseString]) {
            [weakSelf alertTitle:@"校验成功"];
        }else{
            [weakSelf alertTitle:@"校验失败"];
        }
    };
    
    [self.view addSubview:_codeView];
    [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.refreshBtn.mas_bottom).with.offset(50);
    }];
}
- (void)alertTitle:(NSString *)text{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.codeView becomeTextFieldFirstResponder];
        [self refresh:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)refresh:(UIButton *)sender{/*刷新验证码*/
    self.codeLabel.text = [self generateTradeNO];
}
//产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 4;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - lazy load
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.font = _kFont(30);
        [self.view addSubview:_codeLabel];
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(100);
            make.height.mas_equalTo(50);
        }];
    }
    return _codeLabel;
}
- (UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = _kFont(13);
        [_refreshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_refreshBtn];
        [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.top.equalTo(self.codeLabel.mas_bottom).with.offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
    }
    return _refreshBtn;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.codeView resignTextFieldFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
