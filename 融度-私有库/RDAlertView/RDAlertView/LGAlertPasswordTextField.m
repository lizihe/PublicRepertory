//
//  LGAlertPasswordTextField.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/15.
//
//

#import "LGAlertPasswordTextField.h"
#import "LGAlertViewShared.h"


@implementation LGAlertPasswordTextField

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.f];
        self.textColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:16.f];
        self.clearButtonMode = UITextFieldViewModeNever;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += kLGAlertViewPaddingW;
    bounds.size.width -= kLGAlertViewPaddingW*2;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        bounds.origin.y = self.frame.size.height/2-self.font.lineHeight/2;
        bounds.size.height = self.font.lineHeight;
    }
    
    if (self.leftView)
    {
        bounds.origin.x += (self.leftView.frame.size.width+kLGAlertViewPaddingW);
        bounds.size.width -= (self.leftView.frame.size.width+kLGAlertViewPaddingW);
    }
    
    if (self.rightView)
    bounds.size.width -= (self.rightView.frame.size.width+kLGAlertViewPaddingW);
    else if (self.clearButtonMode == UITextFieldViewModeAlways)
    bounds.size.width -= 20.f;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += kLGAlertViewPaddingW;
    bounds.size.width -= kLGAlertViewPaddingW*2;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        bounds.origin.y = self.frame.size.height/2-self.font.lineHeight/2;
        bounds.size.height = self.font.lineHeight;
    }
    
    if (self.leftView)
    {
        bounds.origin.x += (self.leftView.frame.size.width+kLGAlertViewPaddingW);
        bounds.size.width -= (self.leftView.frame.size.width+kLGAlertViewPaddingW);
    }
    
    if (self.rightView)
    bounds.size.width -= (self.rightView.frame.size.width+kLGAlertViewPaddingW);
    else if (self.clearButtonMode == UITextFieldViewModeAlways)
    bounds.size.width -= 20.f;
    
    return bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
