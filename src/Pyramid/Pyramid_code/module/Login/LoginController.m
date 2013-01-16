//
//  LoginController.m
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LoginController.h"
#import "ASIFormDataRequest.h"
#import "LoginResponse.h"

@interface LoginController () <UITextFieldDelegate>
{
    UITextField*    _nameInput;
    UITextField*    _pwInput;
    UILabel*        _errInfo;
    NSString*       _user;
    NSString*       _pw;
}
@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UILabel* test = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
//    test.text = LKString(login);
//    [self.view addSubview:test];

    _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(50, 30, 220, 30)];
    _nameInput.borderStyle = UITextBorderStyleRoundedRect;
    _nameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameInput.keyboardType = UIKeyboardTypeEmailAddress;
    _nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
//    _nameInput.enablesReturnKeyAutomatically = YES;
    _nameInput.returnKeyType = UIReturnKeyNext;
    _nameInput.delegate = self;
    [self.view addSubview:_nameInput];
    
    _pwInput = [[UITextField alloc] initWithFrame:CGRectMake(50, 80, 220, 30)];
    _pwInput.secureTextEntry = YES;
    _pwInput.borderStyle = UITextBorderStyleRoundedRect;
    _pwInput.keyboardType = UIKeyboardTypeASCIICapable;
//    _pwInput.enablesReturnKeyAutomatically = YES;
    _pwInput.returnKeyType = UIReturnKeyGo;
    _pwInput.delegate = self;
    [self.view addSubview:_pwInput];
    
    _errInfo = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 220, 60)];
    _errInfo.numberOfLines = 0;
    _errInfo.text = _hint;
    [self.view addSubview:_errInfo];
    
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
        _user = _nameInput.text;
        _pw = _pwInput.text;
        [self startLogin];
    }
    return NO;
}

#pragma mark - inner method
-(void)startLogin
{
    ASIFormDataRequest* loginRequest = [ASIFormDataRequest requestWithURL:linkkkUrl(@"/io/login/")];
    loginRequest.delegate = self;
    loginRequest.shouldRedirect = NO;
    
    [loginRequest setPostValue:_user forKey:@"login"];
    [loginRequest setPostValue:_pw forKey:@"password"];
    
    [loginRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    LKLog(request.responseString);
    
    json2obj(request.responseData,LoginResponse)
    
    if ([repObj.status isEqualToString:@"okay"]) {
        LK_USER.userID = repObj.data.user_id;
        [LK_USER storeUserName:_user andPW:_pw];
        [LK_UI loginSuccess];
    }
    else if ([repObj.status isEqualToString:@"oops"]) {
        if (repObj.invalidations.__all__[0]) {
            _errInfo.text = repObj.invalidations.__all__[0];
        }
        else if (repObj.invalidations.login[0]) {
            _errInfo.text = repObj.invalidations.login[0];
        }
        else if (repObj.invalidations.password[0]) {
            _errInfo.text = repObj.invalidations.password[0];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    
    LKLog([[request error] localizedDescription]);
}


@end
