//
//  NewLinkeeController.m
//  Pyramid
//
//  Created by andregao on 13-1-24.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "NewLinkeeController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"

@interface NewLinkeeController ()
{
    UITextView * _input;
    ASIHTTPRequest * _sendRequest;
}
@end

@implementation NewLinkeeController

- (void)dealloc
{
    [_sendRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _input = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 150)];
    _input.layer.borderWidth = 2;
    _input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_input];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(sendPressed:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelPressed:(id)sender
{
    [_input resignFirstResponder];
}

-(void)sendPressed:(id)sender
{
    [_input resignFirstResponder];
    if (_input.text == nil)
        return;
    
    [self sendLinkee];
}

-(NSData*)makeSendJson
{
    NSDictionary * dic = @{@"content":_input.text, @"image":[NSNull null], @"activity":[NSNull null]};
    NSError* err = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    return jsonData;
}

-(void)sendLinkee
{
    NSData * postJson = [self makeSendJson];
    
    _sendRequest = [ASIHTTPRequest requestWithURL:linkkkUrl(@"/api/alpha/linkee/")];
    [_sendRequest setRequestMethod:@"POST"];
    [_sendRequest setPostBody:[NSMutableData dataWithData:postJson]];
    _sendRequest.delegate = self;
    [_sendRequest addRequestHeader:@"X-XSRF-TOKEN" value:LK_USER.xsrfToken];
    [_sendRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [_sendRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    _sendRequest = nil;
    
    // Use when fetching text data
    LKLog([request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _sendRequest = nil;
    LKLog([[request error] localizedDescription]);
}

@end
