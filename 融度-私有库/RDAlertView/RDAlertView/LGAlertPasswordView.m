//
//  LGAlertPasswordView.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/20.
//
//

#import "LGAlertPasswordView.h"

static NSString * const LimitedField = @"0123456789";

@interface LGAlertPasswordView ()

/**
 输入的密码
 */
@property (nonatomic, copy) NSMutableString *inputText;

@end

@implementation LGAlertPasswordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self propertyValue];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self propertyValue];
    }
    return self;
}

- (void)propertyValue
{
    _inputText = [NSMutableString string];
    _passwordCount = 6;
    _rectBorderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
}

- (NSString *)inputCode
{
    return [_inputText copy];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat squareWidth = rect.size.width/_passwordCount;
    CGFloat pointRadius = 5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(context, CGRectMake( 0, 0, width, height));
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, _rectBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //画竖条
    for (int i = 1; i <= _passwordCount; i++) {
        CGContextMoveToPoint(context, i*squareWidth, 0);
        CGContextAddLineToPoint(context, i*squareWidth, squareWidth);
        CGContextClosePath(context);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    //画黑点
    for (int i = 1; i <= _inputText.length; i++) {
        CGContextAddArc(context,  i*squareWidth - squareWidth/2.0, height/2, pointRadius, 0, M_PI*2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }

}

- (UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

- (BOOL)becomeFirstResponder
{
    if (_delegate && [_delegate respondsToSelector:@selector(passwordBeginInput:)]) {
        [_delegate passwordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}
#pragma mark - UIKeyInput
- (BOOL)hasText
{
    return _inputText.length > 0;
}

- (void)insertText:(NSString *)text
{
    if (_inputText.length < _passwordCount) {
        //过滤符合规则的字符串
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LimitedField] invertedSet];
        NSString *filteredString = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        //判断输入字符串是否符合规则
        BOOL isPass = [text isEqualToString:filteredString]&&(_inputText.length + text.length <= _passwordCount);
        if(isPass)
        {
            [_inputText appendString:text];
            if (_delegate && [_delegate respondsToSelector:@selector(passwordDidChange:)]) {
                [_delegate passwordDidChange:self];
            }
            if (_inputText.length == _passwordCount) {
                if (_delegate && [_delegate respondsToSelector:@selector(passwordCompleteInput:)]) {
                    [_delegate passwordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}
- (void)deleteBackward
{
    if (_inputText.length > 0) {
        [_inputText deleteCharactersInRange:NSMakeRange(_inputText.length - 1, 1)];
        if (_delegate && [_delegate respondsToSelector:@selector(passwordDidChange:)]) {
            [_delegate passwordDidChange:self];
        }
    }
    [self setNeedsDisplay];
}
@end
