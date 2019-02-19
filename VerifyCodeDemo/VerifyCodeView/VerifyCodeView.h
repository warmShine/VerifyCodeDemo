//
//  VerifyCodeView.h
//  iOS
//
//  Created by fenglei on 2018/8/22.
//  Copyright © 2018年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputTextBlock)(NSString *text);

@interface VerifyCodeView : UIView

@property (nonatomic, copy) InputTextBlock inputTextBlock;

/**

 @param length 验证码数量 
 */
- (instancetype)initWithFrame:(CGRect)frame withCodeLength:(NSInteger)length;
- (void)becomeTextFieldFirstResponder;
- (void)resignTextFieldFirstResponder;
@end
