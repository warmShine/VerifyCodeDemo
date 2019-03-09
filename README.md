# VerifyCodeDemo

简易验证码校验控件
------
![](https://github.com/warmShine/VerifyCodeDemo/raw/master/resources/example1.png
)
![](https://github.com/warmShine/VerifyCodeDemo/raw/master/resources/example2.png
)
##功能介绍
功能比较简单：包括顺序输入及删除，点击验证码输入部分弹收起键盘。暂未实现随意输入及删除验证码。
##核心代码
使用部分：
```
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
```
实现原理：
```
for (int i = 0; i < self.maxCodeLength; i++) {/*创建多个textFiled实现多个验证码输入*/
VerifyCodeTextField *textfield = [[VerifyCodeTextField alloc]init];
textfield.tag = textFieldTag + i;
textfield.delegate = self;
textfield.deleteDelegate = self;
...
}
```
遇到的问题：
创建多个textfield,当删除输入码时，并不能从当前textfield回到上一个textfield中。
解决办法：自定义textfield继承UITextField，重写deleteBackward方法。
```
@implementation VerifyCodeTextField

- (void)deleteBackward{
[super deleteBackward];
if ([self.deleteDelegate respondsToSelector:@selector(verifyCodeTextFieldDelete:)]) {
[self.deleteDelegate verifyCodeTextFieldDelete:self];
}
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
return nil;
}
```
实现代理：
```
- (void)verifyCodeTextFieldDelete:(UITextField *)textField{/*删除验证码代理方法*/
[self textFieldDeleteInputText:textField];
}
```


