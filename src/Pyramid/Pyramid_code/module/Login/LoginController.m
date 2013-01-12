//
//  LoginController.m
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LoginController.h"

@interface LoginController () <UITextFieldDelegate>
{
    UITextField* _nameInput;
    UITextField* _pwInput;
}
@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel* test = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    test.text = LKString(@"login");
    [self.view addSubview:test];

    _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(50, 30, 220, 30)];
    _nameInput.borderStyle = UITextBorderStyleRoundedRect;
    _nameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameInput.keyboardType = UIKeyboardTypeEmailAddress;
    _nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameInput.enablesReturnKeyAutomatically = YES;
    _nameInput.returnKeyType = UIReturnKeyNext;
    _nameInput.delegate = self;
    [self.view addSubview:_nameInput];
    
    _pwInput = [[UITextField alloc] initWithFrame:CGRectMake(50, 80, 220, 30)];
    _pwInput.secureTextEntry = YES;
    _pwInput.borderStyle = UITextBorderStyleRoundedRect;
    _pwInput.keyboardType = UIKeyboardTypeASCIICapable;
    _pwInput.enablesReturnKeyAutomatically = YES;
    _pwInput.returnKeyType = UIReturnKeyGo;
    _pwInput.delegate = self;
    [self.view addSubview:_pwInput];
    
    [_nameInput becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameInput) {
        [_pwInput becomeFirstResponder];
    }
    else if (textField == _pwInput) {
        [self startLogin];
    }
    return NO;
}

#pragma mark - inner method
-(void)startLogin
{
    [_delegate loginSuccess];
}

@end
