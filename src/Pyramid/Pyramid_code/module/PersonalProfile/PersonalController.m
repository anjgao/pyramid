//
//  PersonalController.m
//  Pyramid
//
//  Created by andregao on 13-1-14.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "PersonalController.h"
#import "ASIHTTPRequest.h"
#import "PersonProfile.h"
#import "PeopleStreamController.h"

@interface PersonalController ()
{
    // data
    NSNumber * _curPersonID;
    PersonProfile * _curProfile;
    
    // views
    UILabel * _name;
    UILabel * _area;
    UILabel * _story;
    UIButton * _friend;
    UIButton * _exp;
    UIButton * _hostedexp;
    UIImageView * _portrait;
}
@end

@implementation PersonalController

-(id)init
{
    self = [super init];
//    self.title = LKString(myProfile);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createViews];
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
-(void)createViews
{
    _name = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 30)];
    [self.view addSubview:_name];
    
    _area = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 150, 20)];
    [self.view addSubview:_area];

    _story = [[UILabel alloc] initWithFrame:CGRectMake(150, 80, 150, 60)];
    [self.view addSubview:_story];
    
    _friend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _friend.frame = CGRectMake(10, 150, 90, 30);
    [self.view addSubview:_friend];
    [_friend addTarget:self action:@selector(friendedPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _exp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _exp.frame = CGRectMake(115, 150, 90, 30);
    [self.view addSubview:_exp];
    
    _hostedexp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _hostedexp.frame = CGRectMake(220, 150, 90, 30);
    [self.view addSubview:_hostedexp];
    
    _portrait = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 130)];
    [self.view addSubview:_portrait];
}

-(void)requestPersonalData
{
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/host/profile/%@/",_curPersonID.stringValue];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    json2obj(request.responseData, PersonProfile)
    _curProfile = repObj;
    self.title = _curProfile.username;
    [self fillView];
    [self requestPortrait];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    
    LKLog([[request error] localizedDescription]);
}

-(void)fillView
{
    _name.text = _curProfile.username;
    _area.text = [_curProfile.district.name stringByAppendingString:_curProfile.district.city.name];
    _story.text = _curProfile.story;
    
    [_friend setTitle:[LKString(friend) stringByAppendingFormat:@": %@",[_curProfile.stat.circle_count stringValue]] forState:UIControlStateNormal];
    [_exp setTitle:[LKString(exps) stringByAppendingFormat:@": %@",[_curProfile.stat.team_count stringValue]] forState:UIControlStateNormal];
    [_hostedexp setTitle:[LKString(hostexps) stringByAppendingFormat:@": %@",[_curProfile.stat.hosted_team_count stringValue]] forState:UIControlStateNormal];
}

-(void)requestPortrait
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_curProfile.avatar.large]];
    request.didFinishSelector = @selector(portraitLoadFinished:);
    request.didFailSelector = @selector(portraitLoadFailed:);
    request.delegate = self;
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [request startAsynchronous];
}

- (void)portraitLoadFinished:(ASIHTTPRequest *)request
{
    BOOL a = request.didUseCachedResponse;
    _portrait.image = [UIImage imageWithData:[request responseData]];
}

- (void)portraitLoadFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

-(void)friendedPressed:(UIButton*)btn
{
    PeopleStreamController* psCtl = [[PeopleStreamController alloc] initWithID:_curPersonID];
    [self.navigationController pushViewController:psCtl animated:YES];
}

@end
