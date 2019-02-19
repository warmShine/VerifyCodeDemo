//
//  VerifyCodeTextField.h
//  iOS
//
//  Created by fenglei on 2018/8/24.
//  Copyright © 2018年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerifyCodeTextFieldDelegate <NSObject>

- (void)verifyCodeTextFieldDelete:(UITextField *)textField;

@end

@interface VerifyCodeTextField : UITextField

@property (nonatomic, weak) id<VerifyCodeTextFieldDelegate> deleteDelegate;

@end
