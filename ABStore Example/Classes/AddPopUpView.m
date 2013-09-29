//
//  AddPopUpView.m
//  ABStore Example
//
//  Created by Alexander Blunck on 9/28/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "AddPopUpView.h"

@interface AddPopUpView () <UITextFieldDelegate>
{
    UIView *_backgroundView;
    void (^_completionBlock)(NSString *text);
    
    UITextField *_textField;
    CGRect _initialTextFieldRect;
    CGRect _finalTextFieldRect;
}
@end

@implementation AddPopUpView

#pragma mark - LifeCycle
-(void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.frame = [[self applicationTopView] bounds];
    self.backgroundColor = [UIColor clearColor];
    
    [self layout];
}



#pragma mark - Layout
-(void) layout
{
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.0f;
    [self addSubview:_backgroundView];
    
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    
    _initialTextFieldRect = CGRectMake(0, [self applicationTopView].bounds.size.height, self.bounds.size.width, 40.0f);
    _finalTextFieldRect = CGRectMake(0, ((self.bounds.size.height - 40.0f) / 2) - 20.0f, self.bounds.size.width, 40.0f);
    
    _textField = [[UITextField alloc] initWithFrame:_initialTextFieldRect];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.0f, _textField.bounds.size.height)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.placeholder = @"Name";
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [self addSubview:_textField];
}



#pragma mark - Show / Hide
-(void) showWithCompletion:(void(^)(NSString *text))block
{
    _completionBlock = [block copy];
    
    [self show:YES];
}

-(void) hide
{
    [self show:NO];
}

-(void) hideWithText
{
    if (_completionBlock && _textField.text.length != 0)
    {
        _completionBlock(_textField.text);
    }
    
    [self show:NO];
}

-(void) show:(BOOL)show
{
    if (show)
    {
        [[self applicationTopView] addSubview:self];
    }
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _backgroundView.alpha = (show) ? 0.5f : 0.0f;
        _textField.frame = (show) ? _finalTextFieldRect : _initialTextFieldRect;
        
    } completion:^(BOOL finished) {
        
        if (!show)
        {
            [self removeFromSuperview];
        }
        else
        {
            [_textField becomeFirstResponder];
        }
        
    }];
}



#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self hideWithText];
    
    return YES;
}



#pragma mark - Helper
-(UIViewController*) applicationTopViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(UIView*) applicationTopView
{
    return [[self applicationTopViewController] view];
}

@end
