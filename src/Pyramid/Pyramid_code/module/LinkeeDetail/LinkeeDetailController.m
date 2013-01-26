//
//  LinkeeDetailController.m
//  Pyramid
//
//  Created by andregao on 13-1-23.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeDetailController.h"
#import "JsonObj.h"
#import "ASIHTTPRequest.h"
#import "ReplyStreamController.h"
#import "ASIFormDataRequest.h"
#import "PersonalController.h"

@interface LinkeeDetailController () <UIAlertViewDelegate>
{
    // data
    Json_linkee * _linkee;
    int _contentEndY;
    
    // view
    UIView * _linkeeView;
    UIImageView * _portrait;
    UILabel * _name;
    UILabel * _story;
    UILabel * _content;
    UILabel * _time;
    UILabel * _exp;
    
    //
    ReplyStreamController * _reply;
    
    // request
    ASIHTTPRequest * _portraitRequest;
    ASIHTTPRequest * _picRequest;
    ASIFormDataRequest * _delRequest;
}
@end

@implementation LinkeeDetailController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithLinkee:(Json_linkee*)linkee
{
    self = [super init];
    _linkee = linkee;
    _reply = [[ReplyStreamController alloc] initWithLinkeeID:_linkee.id];
    return self;
}

- (void)dealloc
{
    [_portraitRequest clearDelegatesAndCancel];
    [_picRequest clearDelegatesAndCancel];
    [_delRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _reply.navCtl = self.navigationController;
    
    if ( [_linkee.user.id isEqualToNumber:LK_USER.userID] ) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LKString(delete) style:UIBarButtonItemStylePlain target:self action:@selector(delPressed:)];
    }
    
    [self createViews];
    
    _reply.view.frame = self.view.bounds;
    [self.view addSubview:_reply.view];
    [_reply getTable].tableHeaderView = _linkeeView;

    [self requestImg];
}

- (void)createViews
{
    int w = self.view.bounds.size.width;
    int startY = 10;
    
    _linkeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 0)];
    
    _portrait = [[UIImageView alloc] initWithFrame:CGRectMake(10, startY, 50, 50)];
    [_linkeeView addSubview:_portrait];
    _portrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked:)];
    [_portrait addGestureRecognizer:singleTap];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, w-70-10, 20)];
    _name.text = _linkee.author.username;
    [_linkeeView addSubview:_name];
    
    _story = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, w-70-10, 15)];
    _story.textColor = [UIColor grayColor];
    _story.font = [UIFont systemFontOfSize:14];
    _story.text = _linkee.author.story;
    [_linkeeView addSubview:_story];
    
    startY = 70;
    _content = [[UILabel alloc] initWithFrame:CGRectMake(10, startY, w-20, 0)];
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontOfSize:15];
    _content.text = _linkee.content;
    [_content sizeToFit];
    [_linkeeView addSubview:_content];
    startY += (_content.bounds.size.height + 10);
    _contentEndY = startY;
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, 0, 15)];
    _time.textColor = [UIColor grayColor];
    _time.font = [UIFont systemFontOfSize:14];
    _time.text = [LK_CONFIG dateDisplayString:_linkee.created];
    [_time sizeToFit];
    CGRect timeFrame = _time.frame;
    timeFrame.origin.x = w - 10 - _time.bounds.size.width;
    _time.frame = timeFrame;
    [_linkeeView addSubview:_time];
    startY += (15+10);
    
    if (_linkee.activity.current_profile.name) {
        _exp = [[UILabel alloc] initWithFrame:CGRectMake(10, startY, w-20, 18)];
        _exp.textColor = [UIColor brownColor];
        _exp.font = [UIFont systemFontOfSize:15];
        _exp.text = _linkee.activity.current_profile.name;
        startY += (18+10);
        [_linkeeView addSubview:_exp];
    }
    
    _linkeeView.frame = CGRectMake(0, 0, w, startY);
//    [self.view addSubview:_linkeeView];
}

#pragma mark - delete linkee
-(void)delPressed:(id)sender
{
    UIAlertView * delAlert = [[UIAlertView alloc] initWithTitle:LKString(sureDelete) message:nil delegate:self cancelButtonTitle:LKString(cancel) otherButtonTitles:LKString(delete), nil];
    [delAlert show];
}

-(void)deleteLinkee
{
    _delRequest = [[ASIFormDataRequest alloc] initWithURL:linkkkUrl(@"/io/delete/linkee/")];
    _delRequest.delegate = self;
    _delRequest.didFinishSelector = @selector(delSuccess:);
    _delRequest.didFailSelector = @selector(delFail:);
    [_delRequest addRequestHeader:@"X-XSRF-TOKEN" value:LK_USER.xsrfToken];
    [_delRequest setPostValue:_linkee.id forKey:@"linkee"];
    [_delRequest startAsynchronous];
}

-(void)delSuccess:(ASIFormDataRequest*)request
{
    _delRequest = nil;
    json2obj(request.responseData, DeleteLinkeeResponse)
    if ([repObj.status isEqualToString:@"okay"]) {
        showHUDTip(self.hud,@"delete success");        
    }
    else {
        showHUDTip(self.hud,@"delete fail");
    }
}

-(void)delFail:(ASIFormDataRequest*)request
{
    _delRequest = nil;
    showHUDTip(self.hud,@"delete fail");
    LKLog([[request error] localizedDescription]);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1)
        return;
    
    [self deleteLinkee];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}

#pragma mark - request images
- (void)requestImg
{
    _portraitRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_linkee.author.medium_avatar]];
    _portraitRequest.didFinishSelector = @selector(portraitLoadFinished:);
    _portraitRequest.didFailSelector = @selector(portraitLoadFailed:);
    _portraitRequest.delegate = self;
    _portraitRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [_portraitRequest startAsynchronous];

    
    _picRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_linkee.image.large]];
    _picRequest.didFinishSelector = @selector(picLoadFinished:);
    _picRequest.didFailSelector = @selector(picLoadFailed:);
    _picRequest.delegate = self;
    _picRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [_picRequest startAsynchronous];
}

- (void)portraitLoadFinished:(ASIHTTPRequest *)request
{
    _portraitRequest = nil;
    _portrait.image = [UIImage imageWithData:[request responseData]];
}

- (void)portraitLoadFailed:(ASIHTTPRequest *)request
{
    _portraitRequest = nil;
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

- (void)picLoadFinished:(ASIHTTPRequest *)request
{
    _picRequest = nil;
    UIImage * img = [UIImage imageWithData:[request responseData]];
    UIImageView * imgV = [[UIImageView alloc] initWithImage:img];
    if ([LK_CONFIG isRetina]) {
        CGRect vf = imgV.frame;
        vf.size.height /= 2;
        vf.size.width /= 2;
        imgV.frame = vf;
    }
    CGRect vf = imgV.frame;
    vf.origin.x = (self.view.bounds.size.width - vf.size.width)/2;
    vf.origin.y = _contentEndY;
    imgV.frame = vf;
    
    int newOffset = vf.size.height + 10;
    CGPoint centre = _time.center;
    centre.y += newOffset;
    _time.center = centre;
    centre = _exp.center;
    centre.y += newOffset;
    _exp.center = centre;
    
    CGRect lvFrame = _linkeeView.frame;
    lvFrame.size.height += newOffset;
    _linkeeView.frame = lvFrame;
    [_linkeeView addSubview:imgV];
    
    [_reply getTable].tableHeaderView = _linkeeView;
    
//    [UIView transitionWithView:_linkeeView
//                      duration:0.3
//                       options: UIViewAnimationOptionLayoutSubviews
//                    animations:nil
//                    completion:nil];
}

- (void)picLoadFailed:(ASIHTTPRequest *)request
{
    _picRequest = nil;
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

#pragma mark - inner method
-(void)headClicked:(UITapGestureRecognizer*)gr
{
    PersonalController * personCtrl = [[PersonalController alloc] init];
    [self pushCtl:personCtrl];
    [personCtrl showProfileWithID:_linkee.author.id];
}

@end
