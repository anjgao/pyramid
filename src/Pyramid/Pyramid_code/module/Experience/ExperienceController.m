//
//  ExperienceController.m
//  Pyramid
//
//  Created by andregao on 13-1-24.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ExperienceController.h"
#import "JsonObj.h"

@interface ExperienceController ()
{
    Json_experience * _exp;
    UIWebView * _webView;
}
@end

@implementation ExperienceController
- (id)initWithExp:(Json_experience*)exp
{
    self = [super initWithCapacity:20];
    _exp = exp;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.scalesPageToFit = YES;
    NSString * urlPath = [@"/experience/" stringByAppendingString:[_exp.id stringValue]];
    [_webView loadRequest:[NSURLRequest requestWithURL:linkkkUrl(urlPath)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
