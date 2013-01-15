//
//  PersonalController.m
//  Pyramid
//
//  Created by andregao on 13-1-14.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "PersonalController.h"
#import "ASIHTTPRequest.h"

@interface PersonalController ()
{
    NSNumber* _curPersonID;
}
@end

@implementation PersonalController

-(id)init
{
    self = [super init];
    self.title = LKString(myProfile);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public method
-(void)showProfileWithID:(NSNumber*)personID
{
    _curPersonID = personID;
    [self requestPersonalData];
}

#pragma mark - inner method
-(void)requestPersonalData
{
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/host/profile/%@/",_curPersonID.stringValue];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString* res = [request responseString];
    LKLog(res);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    LKLog(responseString);
    
    NSError *error = [request error];
    LKLog([error localizedDescription]);
}


@end
