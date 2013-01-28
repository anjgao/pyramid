//
//  ReplyController.m
//  Pyramid
//
//  Created by andregao on 13-1-26.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ReplyController.h"
#import "JsonObj.h"
#import "ASIFormDataRequest.h"
#import "PersonProfile.h"

@interface ReplyController ()
{
    // data
    Json_linkee * _linkee;
    Json_reply * _reply;
    BOOL _bRelinkee;
    
    // view
    UITextView * _input;
    
    // request
    ASIHTTPRequest * _replyRequest;
}
@end

@implementation ReplyController

- (id)initWithLinkee:(Json_linkee*)linkee reply:(Json_reply*)reply isRelinkee:(BOOL)bRelinkee;
{
    self = [super init];
    _linkee = linkee;
    _reply = reply;
    _bRelinkee = bRelinkee;
    
    if (bRelinkee)
        self.title = LKString(fw);
    else
        self.title = LKString(reply);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LKString(cancel) style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LKString(send) style:UIBarButtonItemStylePlain target:self action:@selector(sendPressed:)];
    return self;
}

-(void)dealloc
{
    [_replyRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _input = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 100)];
    _input.layer.borderWidth = 2;
    _input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_input];

    if (!_bRelinkee) {
        _input.text = [self buildPlaceHolder];
    }
    
    [_input becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
-(void)cancelPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendPressed:(id)sender
{
    if (_replyRequest)
        return;
//    if (_input.text == nil || _input.text.length == 0 ) {
//        showHUDTip(self.hud,@"please input content");
//        return;
//    }
    
    NSString * content = _input.text;
    [_input resignFirstResponder];
    [self replyLinkee:content];
}

#pragma mark - reply linkee
-(void)replyLinkee:(NSString*)content
{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"sending";
    self.hud.dimBackground = YES;
    [self.hud show:YES];
    
    if (_bRelinkee)
        [self sendFWRequest:content];
    else
        [self sendReplyRequest:content];
}

-(void)sendReplyRequest:(NSString*)content
{
    NSData * replyJson = [self makeReplyString:content];
    
    _replyRequest = [[ASIHTTPRequest alloc] initWithURL:linkkkUrl(@"/api/alpha/reply/")];
    [_replyRequest setRequestMethod:@"POST"];
    [_replyRequest setPostBody:[NSMutableData dataWithData:replyJson]];
    _replyRequest.delegate = self;
    _replyRequest.didFinishSelector = @selector(replySuccess:);
    _replyRequest.didFailSelector = @selector(replyFail:);
    [_replyRequest addRequestHeader:@"X-XSRF-TOKEN" value:LK_USER.xsrfToken];
    [_replyRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [_replyRequest startAsynchronous];
}

- (NSData*)makeReplyString:(NSString*)content
{
    // {"linkee":"/api/alpha/timeline/14240/","content":"1"}
    NSDictionary * dic = @{@"linkee":_linkee.resource_uri, @"content":content, @"tag_from":[LK_CONFIG tagFrom]};
    NSError* err = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    return jsonData;
}

-(void)replySuccess:(ASIHTTPRequest*)request
{
    _replyRequest = nil;
    
    json2obj(request.responseData, ReplyResponse)
    
    [_delegate replySuccess];
}

-(void)replyFail:(ASIHTTPRequest*)request
{
    _replyRequest = nil;
    showHUDTip(self.hud,@"reply fail");
    LKLog([[request error] localizedDescription]);
}

#pragma mark - relinkee
-(void)sendFWRequest:(NSString*)content
{
    ASIFormDataRequest * fwRequest = [[ASIFormDataRequest alloc] initWithURL:linkkkUrl(@"/io/relinkee/")];
    fwRequest.delegate = self;
    fwRequest.didFinishSelector = @selector(fwSuccess:);
    fwRequest.didFailSelector = @selector(fwFail:);
    [fwRequest addRequestHeader:@"X-XSRF-TOKEN" value:LK_USER.xsrfToken];
    [fwRequest setPostValue:_linkee.id forKey:@"linkee"];
    [fwRequest setPostValue:content forKey:@"comment"];
    [fwRequest setPostValue:[LK_CONFIG tagFrom] forKey:@"tag_from"];
    [fwRequest startAsynchronous];
    
    _replyRequest = fwRequest;
}

-(void)fwSuccess:(ASIHTTPRequest*)request
{
    _replyRequest = nil;
    
    json2obj(request.responseData, RelinkeeResponse)
    
    if ([repObj.status isEqualToString:@"okay"]) {
        [_delegate relinkeeSuccess];
    }
    else {
        showHUDTip(self.hud,@"relinkee fail");
        LKLog(request.responseString);
    }
}

-(void)fwFail:(ASIHTTPRequest*)request
{
    _replyRequest = nil;
    showHUDTip(self.hud,@"relinkee fail");
    LKLog([[request error] localizedDescription]);
}


#pragma mark
-(void)addStringToHolder:(NSMutableString*)holder strs:(NSMutableArray*)ids userName:(NSString*)name userID:(NSNumber*)userID
{
    for (NSNumber* theID in ids) {
        if ([theID isEqualToNumber:userID])
            return;
    }
    
    [holder appendFormat:@"@%@ ",name];
    [ids addObject:userID];
}

-(NSString*)buildPlaceHolder
{
    NSMutableString * str = [[NSMutableString alloc] initWithCapacity:64];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:8];
    [str appendString:LKString(reply)];
    [arr addObject:LK_USER.userID];
    
    [self addStringToHolder:str strs:arr userName:_linkee.user.username userID:_linkee.user.id];
    [self addStringToHolder:str strs:arr userName:_linkee.author.username userID:_linkee.author.id];
    
    NSRange range;
    for (Json_mention* men in _linkee.mentions) {
        range.location = men.start+1;
        range.length = men.end - men.start-1;
        NSString * user = [_linkee.content substringWithRange:range];
        [self addStringToHolder:str strs:arr userName:user userID:men.user_id];
    }
    
    if (_reply) {
        [self addStringToHolder:str strs:arr userName:_reply.author.username userID:_reply.author.id];
        for (Json_mention* men in _reply.mentions) {
            range.location = men.start+1;
            range.length = men.end - men.start-1;
            NSString * user = [_reply.content substringWithRange:range];
            [self addStringToHolder:str strs:arr userName:user userID:men.user_id];
        }
    }
    
    [str appendString:@": "];
    
    return str;
}

@end
