//
//  PhotesBrows.h
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  相册选择调用

#import <Foundation/Foundation.h>
#import "CTAssetsPickerController.h"


@class PhotesBrows;
@protocol PhotesBrowsDelegate <NSObject>

@optional
//拍照相册
-(void)didSelectCameraPicture:(UIImage *)cameraImage withBrows:(PhotesBrows *)brows;

//照片多选
-(void)didFinishPickingAssets:(NSArray *)assets withBrows:(PhotesBrows *)brows;

//视频返回
-(void)didFinishMoviesMp4:(NSString *)mp4Url withBrows:(PhotesBrows *)brows;

//取消
- (void)didCancelWithBrows:(PhotesBrows *)brows;

@end



@interface PhotesBrows : NSObject

@property (nonatomic) BOOL caremaCanEidt; //是否可编辑

@property (nonatomic) BOOL useSysDefault; //是否用系统样式

@property (nonatomic) BOOL isUpHeadFace ; //是否上传头像


@property (nonatomic) NSUInteger maxNumberOfPhotos; //相册最大选项个数 default 1

@property (nonatomic, weak) id<PhotesBrowsDelegate> delegate;

@property (nonatomic ,weak) UIViewController *vc;

+ (instancetype)getShareBrowns;

-(id)initWithViewController:(UIViewController *)vc withDelegate:(id<PhotesBrowsDelegate>) delegate;


-(void)show;


-(void)showCarema;

-(void)showPhotos;

-(void)showMovies:(BOOL)isSelectMovie;

@property (nonatomic,copy) NSString *encodeMovieString;

@end
