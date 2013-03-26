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
#import "ASIFormDataRequest.h"
#import "JsonObj.h"
#import "MBProgressHUD.h"

@interface NewLinkeeController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    // view
    UITextView * _input;
    
    // data
    PicUploadResponse * _picUploadRes;
    BOOL _sendWhenImgUploadOK;
    BOOL _sending;
    
    // request
    ASIHTTPRequest * _sendRequest;
    ASIFormDataRequest * _picPostRequest;
}
@end

@implementation NewLinkeeController

- (void)dealloc
{
    [_sendRequest clearDelegatesAndCancel];
    [_picPostRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _input = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 100)];
    _input.layer.borderWidth = 2;
    _input.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_input];
    
    UIButton * photoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoBtn setTitle:@"photo" forState:UIControlStateNormal];
    photoBtn.frame = CGRectMake(10, 120, 70, 30);
    [photoBtn addTarget:self action:@selector(photoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
-(void)photoPressed:(id)sender
{    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    [actionSheet addButtonWithTitle:LKString(takePhoto)];
    [actionSheet addButtonWithTitle:LKString(selectPhoto)];
    [actionSheet addButtonWithTitle:LKString(cancel)];
    actionSheet.cancelButtonIndex = 2;
    actionSheet.delegate = self;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    return;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 2)
        return;
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (buttonIndex == 0)
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else if (buttonIndex == 1)
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_picPostRequest) {
        [_picPostRequest clearDelegatesAndCancel];
        _picPostRequest = nil;
        _sendWhenImgUploadOK = NO;
    }
    
//    NSString * tyep =  [info objectForKey:UIImagePickerControllerMediaType];
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage * img2 = [info objectForKey:UIImagePickerControllerEditedImage];
//    [info objectForKey:UIImagePickerControllerCropRect];
//    NSURL * url1 = [info objectForKey:UIImagePickerControllerMediaURL];
//    NSURL * url2 = [info objectForKey:UIImagePickerControllerReferenceURL];
//    [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    NSData * jpeg = [self jpegData:img];
    
    _picPostRequest = [[ASIFormDataRequest alloc] initWithURL:linkkkUrl(@"/winterfell/upload/")];
    _picPostRequest.delegate = self;
    _picPostRequest.didFinishSelector = @selector(postPicSuccess:);
    _picPostRequest.didFailSelector = @selector(postPicFail:);
    [_picPostRequest setData:jpeg forKey:@"image"];
    [_picPostRequest startAsynchronous];
}

- (NSData*)jpegData:(UIImage*)ori
{
    int measure = 640;
    CGSize newSize;
    CGSize oriSize = ori.size;
    if (oriSize.width > oriSize.height) {
        if (oriSize.height > measure) {
            newSize.height = measure;
            newSize.width = oriSize.width * newSize.height /oriSize.height;
        }
        else {
            newSize = oriSize;
        }
    }
    else {
        if (oriSize.width > measure) {
            newSize.width = measure;
            newSize.height = oriSize.height * newSize.width / oriSize.width;
        }
        else {
            newSize = oriSize;
        }
    }
    
    UIImage * newImg = scaleImage(ori,newSize);
    NSData * jpeg = UIImageJPEGRepresentation(newImg,0.7);
    
    return jpeg;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];    
}

-(void)postPicSuccess:(ASIFormDataRequest*)request
{
    _picPostRequest = nil;
    
    json2obj(request.responseData, PicUploadResponse)
    if ([repObj.status isEqualToString:@"okay"]) {
        _picUploadRes = repObj;
        if (_sendWhenImgUploadOK) {
            _sendWhenImgUploadOK = NO;
            [self postLinkeeData];
        }
    }
    else {
        showHUDTip(self.hud,@"upload image fail");
        if (_sendWhenImgUploadOK) {
            _sendWhenImgUploadOK = NO;
            _sending = NO;
        }
    }
}

-(void)postPicFail:(ASIFormDataRequest*)request
{
    _picPostRequest = nil;
    if (_sendWhenImgUploadOK) {
        _sendWhenImgUploadOK = NO;
        _sending = NO;
    }
    
    LKLog([[request error] localizedDescription]);
    showHUDTip(self.hud,@"upload image fail");
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
-(void)sendPressed:(id)sender
{
    [_input resignFirstResponder];
    if (_input.text == nil)
        return;
    
    [self sendLinkee];
}

-(NSData*)makeSendJson
{
    // {"content":"test","image":"/api/alpha/image/28276/","activity":"/api/alpha/activity/81/"}
    id img = [NSNull null];
    if (_picUploadRes)
        img = _picUploadRes.data.resource_uri;
    
    NSDictionary * dic = @{@"content":_input.text, @"image":img, @"activity":[NSNull null], @"tag_from":[LK_CONFIG tagFrom]};
    NSError* err = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    return jsonData;
}

-(void)sendLinkee
{
    if (_sending)
        return;
    
    if ( _input.text == nil || _input.text.length == 0 ) {
        showHUDTip(self.hud,@"please input content");
        return;
    }
    
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.detailsLabelText = @"sending";
    self.hud.dimBackground = YES;
    [self.hud show:YES];
    
    _sending = YES;
    
    if (!_picPostRequest) {
        [self postLinkeeData];
        _sendWhenImgUploadOK = NO;
    }
    else
        _sendWhenImgUploadOK = YES;
}

-(void)postLinkeeData
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
    _sending = NO;
    
    json2obj(request.responseData, NewLinkeeResponse);
    
    showHUDTip(self.hud,@"send success");
    _picUploadRes = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _sendRequest = nil;
    _sending = NO;
    LKLog([[request error] localizedDescription]);
    
    showHUDTip(self.hud,@"send fail");
}

@end
