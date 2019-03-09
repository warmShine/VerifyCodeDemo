//
//  VerifyCodeView.m
//  iOS
//
//  Created by fenglei on 2018/8/22.
//  Copyright © 2018年 Earth. All rights reserved.
//

#import "VerifyCodeView.h"
#import "VerifyCodeTextField.h"
#import <Masonry.h>
#import "Define.h"

static NSInteger maxDefaultCodeLength = 4;
static NSInteger textFieldTag = 1100;
static CGFloat leftSpace = 25.f;
static CGFloat midSpace = 15.f;
@interface VerifyCodeView ()<UITextFieldDelegate,VerifyCodeTextFieldDelegate>
{
    BOOL _keyBoardShow;//键盘是否显示
}

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) NSString *inputText;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) NSMutableArray *textfieldArray;
@property (nonatomic, assign) NSInteger maxCodeLength;

@end

@implementation VerifyCodeView

- (void)dealloc{
    
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero withCodeLength:maxDefaultCodeLength];

}
- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withCodeLength:maxDefaultCodeLength];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame:CGRectZero withCodeLength:maxDefaultCodeLength];
}
- (instancetype)initWithFrame:(CGRect)frame withCodeLength:(NSInteger)length{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCodeLength = length;
        self.inputText = @"";
        self.lineArray = [NSMutableArray arrayWithCapacity:0];
        self.textfieldArray = [NSMutableArray arrayWithCapacity:0];
        _keyBoardShow = YES;
        [self configVerifyCodeView];
        [self addTapGesture];
    }
    return self;
}
- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
- (void)tap:(UITapGestureRecognizer *)gesture{
    if (_keyBoardShow) {
        return;
    }
    [self.currentTextField becomeFirstResponder];
}
- (void)configVerifyCodeView{
    _Noti_Add(self, @selector(keyboardWillShow:), UIKeyboardWillShowNotification, nil);
    _Noti_Add(self, @selector(keyboardWillHide:), UIKeyboardWillHideNotification, nil);
    CGFloat width = (ScreenWidth-2*(leftSpace)-(self.maxCodeLength-1)*(midSpace))/self.maxCodeLength;
    for (int i = 0; i < self.maxCodeLength; i++) {/*创建多个textFiled实现多个验证码输入*/
        VerifyCodeTextField *textfield = [[VerifyCodeTextField alloc]init];
        textfield.tag = textFieldTag + i;
        textfield.delegate = self;
        textfield.deleteDelegate = self;
        textfield.textAlignment = NSTextAlignmentCenter;
        textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textfield.keyboardType = UIKeyboardTypeASCIICapable;
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textfield.clearsOnBeginEditing = NO;
        textfield.borderStyle = UITextBorderStyleNone;
        textfield.font = _kFont(20);
        textfield.textColor = _COLOR_RGB(0x333333);
        textfield.tintColor = _COLOR_RGB(0xf85d00);
        [self addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset((leftSpace)+i*(width+(midSpace)));
            make.top.bottom.mas_offset(0);
            make.width.mas_equalTo(width);
        }];
        [self.textfieldArray addObject:textfield];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = _COLOR_RGB(0xf1f1f1);
        lineView.tag = textFieldTag + i;
        [textfield addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_offset(0);
            make.height.mas_equalTo(0.5);
        }];
        if (i == 0) {
            [textfield becomeFirstResponder];
            self.currentTextField = textfield;
            lineView.backgroundColor = _COLOR_RGB(0xf85d00);
        }
        [self.lineArray addObject:lineView];
    }

}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}
- (void)verifyCodeTextFieldDelete:(UITextField *)textField{/*删除验证码代理方法*/
    [self textFieldDeleteInputText:textField];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length != 0) {
        if (self.inputText.length >= self.maxCodeLength) {
            return NO;
        }
        NSString *text = [string substringToIndex:1];
        if (self.inputText.length <= self.maxCodeLength) {
            self.inputText = [self.inputText stringByAppendingString:text];
        }
        if (self.inputText.length == self.maxCodeLength) {
            [self resignTextFieldFirstResponder];
            if (self.inputTextBlock) {
                self.inputTextBlock(self.inputText);
            }
        }else{
            [self textFieldBecomeFirstResponder:(textFieldTag+(self.inputText.length<self.maxCodeLength?self.inputText.length:self.maxCodeLength-1))];
        }
        textField.text = text;
    }else{
        [self textFieldDeleteInputText:textField];
    }
    return NO;
}
- (void)textFieldDeleteInputText:(UITextField *)textField{
    if (self.inputText.length > 0 && self.inputText.length <= self.maxCodeLength) {
        if (textField.text.length < 1) {
            self.inputText = [self.inputText substringToIndex:self.inputText.length-1];
            NSInteger tag = (textFieldTag+((self.inputText.length > 0)?self.inputText.length:0));
            VerifyCodeTextField *textField1 = (VerifyCodeTextField *)[self viewWithTag:tag];
            textField1.text = @"";
            [self textFieldBecomeFirstResponder:tag];
        }else{
            textField.text = @"";
            self.inputText = [self.inputText substringToIndex:self.inputText.length-1];
            [self textFieldBecomeFirstResponder:(textFieldTag+(((self.inputText.length-1)>0)?self.inputText.length-1:0))];
        }
    }
}
- (void)textFieldBecomeFirstResponder:(NSInteger)tag{
    if (tag < textFieldTag || tag > textFieldTag+self.maxCodeLength-1) {
        return;
    }
    UITextField *textfield = (UITextField *)[self viewWithTag:tag];
    [textfield becomeFirstResponder];
    self.currentTextField = textfield;
    for (UIView *lineView in self.lineArray) {
        if (lineView.tag == tag) {
            lineView.backgroundColor = _COLOR_RGB(0xf85d00);
        }else{
            lineView.backgroundColor = _COLOR_RGB(0xf1f1f1);
        }
    }
    
}
#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyBoardShow = YES;

}
- (void)keyboardWillHide:(NSNotification *)notification{
    _keyBoardShow = NO;
}
#pragma mark - custom method
- (void)becomeTextFieldFirstResponder{ /* 成为第一响应 */
    for (UITextField *textfield in self.textfieldArray) {
        if (textfield.tag == textFieldTag) {
            self.currentTextField = textfield;
            [textfield becomeFirstResponder];
        }
        textfield.text = @"";
    }
    self.inputText = @"";
    for (UIView *lineView in self.lineArray) {
        if (lineView.tag == textFieldTag) {
            lineView.backgroundColor = _COLOR_RGB(0xf85d00);
        }else{
            lineView.backgroundColor = _COLOR_RGB(0xf1f1f1);
        }
    }
}
- (void)resignTextFieldFirstResponder{ /*收键盘*/
    [self endEditing:YES];
}
@end
