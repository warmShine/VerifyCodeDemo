//
//  VerifyCodeTextField.m
//  iOS
//
//  Created by fenglei on 2018/8/24.
//  Copyright © 2018年 Earth. All rights reserved.
//

#import "VerifyCodeTextField.h"

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
@end
