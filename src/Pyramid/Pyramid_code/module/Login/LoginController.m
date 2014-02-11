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
    NSString*       _user;
    NSString*       _pw;
}
@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]]];
    
    UIImage * img;
    if ([LK_CONFIG isiPhone5])
        img = [UIImage imageNamed:@"Default-568h"];
    else
        img = [UIImage imageNamed:@"Default"];
    UIImageView * bg = [[UIImageView alloc] initWithImage:img];
    CGPoint bgPos = bg.center;
    bgPos.y -= 20;
    bg.center = bgPos;
    [self.view addSubview:bg];
    
    UIImageView * inputBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login"]];
    inputBg.userInteractionEnabled = YES;
    CGPoint inputBgCenter = inputBg.center;
    inputBgCenter = bgPos;
    inputBgCenter.y = 150;
    inputBg.center = inputBgCenter;
    inputBg.alpha = 0.0;
    [self.view addSubview:inputBg];
    
    _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 252, 22)];
    _nameInput.font = [UIFont systemFontOfSize:18];
//    _nameInput.borderStyle = UITextBorderStyleLine;
    _nameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameInput.keyboardType = UIKeyboardTypeEmailAddress;
    _nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
//    _nameInput.enablesReturnKeyAutomatically = YES;
    _nameInput.returnKeyType = UIReturnKeyNext;
    _nameInput.placeholder = LKString(username);    // git测试Branch_1
    _nameInput.delegate = self;
    [inputBg addSubview:_nameInput];
    
    _pwInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 57, 252, 22)];
    _pwInput.font = [UIFont systemFontOfSize:18];
//    _pwInput.borderStyle = UITextBorderStyleLine;
    _pwInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwInput.secureTextEntry = YES;
    _pwInput.keyboardType = UIKeyboardTypeASCIICapable;
//    _pwInput.enablesReturnKeyAutomatically = YES;
    _pwInput.returnKeyType = UIReturnKeyGo;
    _pwInput.placeholder = LKString(password);
    _pwInput.delegate = self;
    [inputBg addSubview:_pwInput];
        
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    inputBg.alpha = 1.0;
    [UIView commitAnimations];
    
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
        [_pwInput resignFirstResponder];
        
        if (_user.length == 0 || _pw.length == 0)
            showHUDTip(self.hud, LKString(logininfo));
        else
            [self startLogin];
    }
    return NO;
}

#pragma mark - inner method
-(void)startLogin
{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.detailsLabelText = LKString(logining);
    [self.hud show:YES];
    
    ASIFormDataRequest* loginRequest = [ASIFormDataRequest requestWithURL:linkkkUrl(@"/io/login/")];
    loginRequest.delegate = self;
    loginRequest.shouldRedirect = NO;
    
    [loginRequest setPostValue:_user forKey:@"login"];
    [loginRequest setPostValue:_pw forKey:@"password"];
    
    [loginRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    json2obj(request.responseData,LoginResponse)
    
    if ([repObj.status isEqualToString:@"okay"]) {
        [self saveXSRFToken:request.responseCookies];
        LK_USER.userID = repObj.data.user_id;
        [LK_USER storeUserName:_user andPW:_pw];
        
        [self.hud hide:YES];
        [LK_UI loginSuccess];
    }
    else if ([repObj.status isEqualToString:@"oops"]) {
        NSString * errStr;
        if (repObj.invalidations.__all__[0]) {
            errStr = repObj.invalidations.__all__[0];
        }
        else if (repObj.invalidations.login[0]) {
            errStr = repObj.invalidations.login[0];
        }
        else if (repObj.invalidations.password[0]) {
            errStr = repObj.invalidations.password[0];
        }
        
        showHUDTip(self.hud, errStr);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
    showHUDTip(self.hud, LKString(netErr));
}

-(void)saveXSRFToken:(NSArray*)cookies
{
    for (NSHTTPCookie* cookie in cookies) {
        if ([cookie.name isEqualToString:@"XSRF-TOKEN"]) {
            LK_USER.xsrfToken = cookie.value;
            break;
        }
    }
}

@end
