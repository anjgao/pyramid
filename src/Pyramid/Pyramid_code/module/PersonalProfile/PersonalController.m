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
#import "ProfileLinkeeController.h"
#import "ExperienceStreamController.h"
#import "HostedExpStreamController.h"
#import "WatchedExpStreamController.h"

@interface PersonalController ()
{
    // data
    NSNumber * _curPersonID;
    PersonProfile * _curProfile;
    
    // controller
    ProfileLinkeeController * _linkeeCtl;
    
    // views
    UIView * _infoView;
    UILabel * _name;
    UILabel * _area;
    UILabel * _story;
    UIButton * _friend;
    UIButton * _exp;
    UIButton * _hostedexp;
    UIButton * _watch;
    UIImageView * _portrait;
    
    // request
    ASIHTTPRequest * _request;
    ASIHTTPRequest * _picRequest;
}
@end

@implementation PersonalController

-(id)init
{
    self = [super init];
//    self.title = LKString(myProfile);
    _linkeeCtl = [[ProfileLinkeeController alloc] initWithCapacity:20];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _linkeeCtl.navCtl = self.navigationController;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_request clearDelegatesAndCancel];
    [_picRequest clearDelegatesAndCancel];
}

#pragma mark - public method
-(void)showProfileWithID:(NSNumber*)personID
{
    _curPersonID = personID;
    [self requestPersonalData];
    
    _linkeeCtl.targetID = personID;
    [_linkeeCtl refresh];
}

#pragma mark - inner method
-(void)createViews
{
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 190)];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 30)];
    [_infoView addSubview:_name];
    
    _area = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 150, 20)];
    [_infoView addSubview:_area];

    _story = [[UILabel alloc] initWithFrame:CGRectMake(150, 80, 150, 60)];
    [_infoView addSubview:_story];
    
    _friend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _friend.frame = CGRectMake(0, 150, 80, 30);
    [_infoView addSubview:_friend];
    [_friend addTarget:self action:@selector(friendedPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _exp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _exp.frame = CGRectMake(80, 150, 80, 30);
    [_infoView addSubview:_exp];
    [_exp addTarget:self action:@selector(expPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _hostedexp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _hostedexp.frame = CGRectMake(160, 150, 80, 30);
    [_infoView addSubview:_hostedexp];
    [_hostedexp addTarget:self action:@selector(hostedexpPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _watch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _watch.frame = CGRectMake(240, 150, 80, 30);
    [_infoView addSubview:_watch];
    [_watch addTarget:self action:@selector(watchPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _portrait = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 130)];
    [_infoView addSubview:_portrait];
    
    _linkeeCtl.view.frame = self.view.bounds;
    [self.view addSubview:_linkeeCtl.view];
    UITableView * table = [_linkeeCtl getTable];
    table.tableHeaderView = _infoView;
}

-(void)requestPersonalData
{
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/host/profile/%@/",_curPersonID.stringValue];
    _request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    _request = nil;
    
    json2obj(request.responseData, PersonProfile)
    _curProfile = repObj;
    self.title = _curProfile.username;
    [self fillView];
    [self requestPortrait];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _request = nil;
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
    [_hostedexp setTitle:[LKString(hostexps) stringByAppendingFormat:@": %d",_curProfile.stat.hosted_experiences.count] forState:UIControlStateNormal];
    [_watch setTitle:[LKString(watchExp) stringByAppendingFormat:@": %@",[_curProfile.stat.watched_exp_count stringValue]] forState:UIControlStateNormal];
}

-(void)requestPortrait
{
    _picRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_curProfile.avatar.large]];
    _picRequest.didFinishSelector = @selector(portraitLoadFinished:);
    _picRequest.didFailSelector = @selector(portraitLoadFailed:);
    _picRequest.delegate = self;
    _picRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [_picRequest startAsynchronous];
}

- (void)portraitLoadFinished:(ASIHTTPRequest *)request
{
    _picRequest = nil;
    _portrait.image = [UIImage imageWithData:[request responseData]];
}

- (void)portraitLoadFailed:(ASIHTTPRequest *)request
{
    _picRequest = nil;
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

-(void)friendedPressed:(UIButton*)btn
{
    PeopleStreamController* psCtl = [[PeopleStreamController alloc] initWithID:_curPersonID];
    [self.navigationController pushViewController:psCtl animated:YES];
}

-(void)expPressed:(UIButton*)btn
{
    ExperienceStreamController * psCtl = [[ExperienceStreamController alloc] initWithUserID:_curPersonID];
    [self.navigationController pushViewController:psCtl animated:YES];
}

-(void)hostedexpPressed:(UIButton*)btn
{
    HostedExpStreamController* psCtl = [[HostedExpStreamController alloc] initWithUserID:_curPersonID];
    [self.navigationController pushViewController:psCtl animated:YES];
}

-(void)watchPressed:(UIButton*)btn
{
    WatchedExpStreamController * psCtl = [[WatchedExpStreamController alloc] initWithUserID:_curPersonID];
    [self.navigationController pushViewController:psCtl animated:YES];
}

@end
