//
//  PhotesBrows.m
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  相册选择调用

#import "PhotesBrows.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import "MBProgressHUD.h"
//#import "NSString+RectSize.h"

#define ViduoMovieMaxTime   10.f //最大 录音时间
#define ViduoMovieMinTime   3.f  //最小

@interface PhotesBrows()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *assets;

@property (nonatomic) BOOL saveMovies;//保存视频到本地

@end

@implementation PhotesBrows

-(id)init
{
    
    self = [super init];
    
    if(self){
        
        _maxNumberOfPhotos = 1;
        
        //self.vc = AppRootViewController;
        
    }
    
    return self;
    
}

static PhotesBrows *shareBrowns = nil;

+ (instancetype)getShareBrowns
{
    @synchronized(self){
        
        shareBrowns = [[self alloc] init];
        
        if(shareBrowns){
            shareBrowns.maxNumberOfPhotos = 1;
            
            shareBrowns.vc = nil;
        }
        
        return shareBrowns;
    }
}


-(id)initWithViewController:(UIViewController *)vc withDelegate:(id<PhotesBrowsDelegate>) delegate;
{

    self = [self init];
    
    if(self){
        
        _delegate = delegate;
        
        if(vc)
            self.vc = vc;
        
    }
    
    return self;
    
}

-(void)setVc:(UIViewController *)vc
{
    if(vc){
        
        vc = vc;
        vc.edgesForExtendedLayout = UIRectEdgeNone;
        vc.extendedLayoutIncludesOpaqueBars = NO;
        vc.modalPresentationCapturesStatusBarAppearance = NO;
        
        _vc = vc.navigationController?vc.navigationController:vc;
    }
}

-(void)show
{
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"照片",nil];
    
    actionSheet.delegate = self;
    
    [actionSheet showInView:_vc.view];
    
}

-(void)showCarema
{
    [self addCarema];
}

-(void)showPhotos
{
    [self pickAssets];
    
}

-(void)showMovies:(BOOL)isSelectMovie
{
    if(!_vc) return;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];

        picker.delegate = self;
        picker.allowsEditing = _caremaCanEidt;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
//        if(IOS8){
//            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        }else{
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
//        }

        if(isSelectMovie){ //选取
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        }else{  //录像
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            picker.videoMaximumDuration = ViduoMovieMaxTime;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        }

        [_vc presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您设备不支持摄像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema]; //拍照
    }else if (buttonIndex == 1){
        [self pickAssets]; //相册
    }else{
        [self didCancel];
    }
}

#pragma mark --拍照
-(void)addCarema{
    
    if(!_vc) return;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        picker.delegate = self;
        picker.allowsEditing = _caremaCanEidt;

        if(IOS8){
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        }else{
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
        }

        [_vc presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您设备不支持摄像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark 照片
- (void)pickAssets
{
    if (!_assets)
        _assets = [[NSMutableArray alloc] init];
    
    if(!_vc) return;
    
    
    if(_useSysDefault){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //picker.navigationBar.tintColor = CommonTextColor;
            picker.delegate = self;
            picker.allowsEditing = _caremaCanEidt;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            //picker.previousStatusBarHidden;
            if(IOS8){
                picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            }else{
                picker.modalPresentationStyle = UIModalPresentationFullScreen;
            }
            
            [_vc presentViewController:picker animated:YES completion:^{}];
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您设备不支持相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = _maxNumberOfPhotos;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        
        [_vc presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是照片
        
        UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(_caremaCanEidt){
            
            editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        //压缩
        editImage = [UIImage jpegImage:editImage];
        //得到无旋转图片
        editImage = [editImage fixOrientation];
        
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            if(_delegate && [_delegate respondsToSelector:@selector(didSelectCameraPicture:withBrows:)]){
                
                [_delegate didSelectCameraPicture:editImage withBrows:self];
                
            }
            
        }];

        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        
        AVAsset *avAsset = [AVAsset assetWithURL:url];
        CMTime assetTime = [avAsset duration];
        Float64 duration = CMTimeGetSeconds(assetTime);
        NSLog(@"视频时长 %.1f\n",duration);
        
        if(duration <ViduoMovieMinTime){
            
            NSString *showMessage = [NSString stringWithFormat:@"视频过短，范围在%.0f~%.0fs",ViduoMovieMinTime,ViduoMovieMaxTime];
            
            [ChatTools showLabelView:showMessage rootView:_vc.view superController:_vc];
            
        }else if(duration >ViduoMovieMaxTime + 1){
            
             NSString *showMessage = [NSString stringWithFormat:@"视频太长，范围在%.0f~%.0fs",ViduoMovieMinTime,ViduoMovieMaxTime];
            [ChatTools showLabelView:showMessage rootView:_vc.view superController:_vc];
        }else{
            [self encodeMp4With:url];
            
            //        NSString *urlStr = [url path];
            //        //异步保存本地
            //        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            //        }
        }
        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self didCancel];
        
        
    }];
}


#pragma mark - 视屏保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo{
    if (error) {
        NSString *errorSting =[NSString stringWithFormat:@"保存视频过程中发生的错误，错误信息：%@",error.localizedDescription];
        NSLog(@"errStri = %@",errorSting);
        [ChatTools showLabelView:errorSting rootView:_vc.view superController:_vc];
    }else{
        NSLog(@"视频保存成功%@",videoPath);

    }
}

#pragma mark --mp4压缩
-(void)encodeMp4With:(NSURL *)_videoURL
{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) //中等压缩
        
    {
        NSDate *date = [NSDate date];
        //设置日期的格式 ：2015年01月03日 03：32：12
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSString *fileName = [dateString stringByAppendingPathExtension:@"mp4"];
        NSString *_mp4Path = [ChatTools getCachePathByFold:MAMovieFileCache withFileName:fileName];
        NSLog(@"mp4Path = %@",_mp4Path);
        //视频文件地址
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetMediumQuality];

        
        NSFileManager * filemanager = [[NSFileManager alloc]init] ;
        if([filemanager fileExistsAtPath:_mp4Path]){
            
            BOOL delete= [filemanager removeItemAtPath:_mp4Path error:nil];
            if(delete){
                NSLog(@"delete");
            }
        }

        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        
         MBProgressHUD *_mbHUD = [[MBProgressHUD alloc] initWithView:_vc.view];
        _mbHUD.removeFromSuperViewOnHide = YES;
        _mbHUD.label.text = _encodeMovieString;
        [_vc.view addSubview:_mbHUD];
        [_mbHUD showAnimated:YES];
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mbHUD hideAnimated:YES];
                
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                    {
                        [ChatTools showLabelView:[[exportSession error] localizedDescription] rootView:_vc.view superController:_vc];
                        break;
                    }
                        
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Export canceled");
                        
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        NSLog(@"Export Successful!");
                        
                        
                        
                        if(_delegate && [_delegate respondsToSelector:@selector(didFinishMoviesMp4:withBrows:)]){
                            
                            [_delegate didFinishMoviesMp4:_mp4Path withBrows:self];
                        }
                        
                        break;
                    default:
                        break;
                }
                
                
            });
 
        }];
    }else{
        
        [ChatTools showLabelView:@"视频压缩失败，请尝试重试" rootView:_vc.view superController:_vc];
    }
}

#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    if(_delegate && [_delegate respondsToSelector:@selector(didFinishPickingAssets:withBrows:)]){
        
        [_delegate didFinishPickingAssets:assets withBrows:self];
        
    }
    
}


- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    NSLog(NSLocalizedString(@"取消选相册",nil));
    
    [self didCancel];
    
}

#pragma mark --取消
-(void)didCancel
{
    if(_delegate && [_delegate respondsToSelector:@selector(didCancelWithBrows:)]){
        
        [_delegate didCancelWithBrows:self];
        
    }
}

#pragma mark --navginationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    BOOL isPhotoVc = ([viewController isKindOfClass:NSClassFromString(@"PLUIImageViewController")] || [viewController isKindOfClass:NSClassFromString(@"CAMCameraViewController")] );
//    //CAMCameraViewController
//    if (_isUpHeadFace && _caremaCanEidt && isPhotoVc ) {
//        
//        static  NSInteger viewTipTag = 100101;
//        
//        UIView *view = [viewController.view viewWithTag:viewTipTag];
//        if(view){
//            [viewController.view addSubview:view];
//            return;
//        }
//        
//        NSString *tipMesasge = @"请上传真实头像，面部清晰完成。禁止使用明星、裸露、含联系方式、广告、水印等照片。";
//        CGFloat panddingX = 15.f;
//        UIFont *font = [UIFont systemFontOfSize:16.f];
//        CGFloat width = viewController.view.bounds.size.width - 2 *panddingX;
//        
//        CGSize size = [tipMesasge labelSizeWithWidth:width font:font];
//        size.height +=3.f;
//        CGRect stringFrame = CGRectMake(panddingX, 30.f, size.width, size.height);
//        
//        UILabel *tipLa = [[UILabel alloc] initWithFrame:stringFrame];
//        tipLa.font = font;
//        tipLa.textAlignment = NSTextAlignmentLeft;
//        tipLa.backgroundColor = [UIColor clearColor];
//        tipLa.text = tipMesasge;
//        tipLa.numberOfLines = 0;
//        tipLa.textColor = [UIColor whiteColor];
//        //tipLa.tag = viewTipTag;
//        
//        UIView *supView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f , viewController.view.bounds.size.width, size.height + 30)];
//        supView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//        supView.tag = viewTipTag;
//        
//        [supView addSubview:tipLa];
//        [viewController.view addSubview:supView];
//    }
    
}

- (UIView *)getTipView {
    NSString *tipMesasge = @"请上传真实头像，面部清晰完成。禁止使用明星、裸露、含联系方式、广告、水印等照片。";
    CGFloat panddingX = 15.f;
    UIFont *font = [UIFont systemFontOfSize:16.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 *panddingX;
    
    CGSize size = [tipMesasge labelSizeWithWidth:width font:font];
    size.height +=3.f;
    CGRect stringFrame = CGRectMake(panddingX, 30.f, size.width, size.height);
    
    UILabel *tipLa = [[UILabel alloc] initWithFrame:stringFrame];
    tipLa.font = font;
    tipLa.textAlignment = NSTextAlignmentLeft;
    tipLa.backgroundColor = [UIColor clearColor];
    tipLa.text = tipMesasge;
    tipLa.numberOfLines = 0;
    tipLa.textColor = [UIColor whiteColor];
    //tipLa.tag = viewTipTag;
    
    UIView *supView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f , [UIScreen mainScreen].bounds.size.width, size.height + 30)];
    supView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [supView addSubview:tipLa];
    
    return supView;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isPhotoVc = ([viewController isKindOfClass:NSClassFromString(@"PLUIImageViewController")] || [viewController isKindOfClass:NSClassFromString(@"CAMCameraViewController")] );
    //CAMCameraViewController
    if (_isUpHeadFace && _caremaCanEidt && isPhotoVc ) {
    } else {
        return;
    }
    NSArray *views = viewController.view.subviews;
    UIView *frontView = [views lastObject];
    [frontView addSubview:[self getTipView]];
}

#pragma mark ---
-(void)dealloc{
    _vc = nil;
    _delegate = nil;
}


@end
