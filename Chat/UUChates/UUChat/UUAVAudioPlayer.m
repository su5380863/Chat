//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "UUChatHearder.h"

@interface UUAVAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic) Class preDelegateClass; //记录之前的delegate类型

@end

@implementation UUAVAudioPlayer


+ (UUAVAudioPlayer *)sharedInstance
{
    static UUAVAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });    
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if(self){
        
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    }
    return self;
}

- (void)setDelegate:(id<UUAVAudioPlayerDelegate>)delegate
{
    
    if(delegate){
        _delegate = delegate;
        
        _preDelegateClass = object_getClass(_delegate);
    }

}

-(void)playSongWithData:(NSData *)songData
{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}

-(void)playSoundWithData:(NSData *)soundData{
    if (_player) {
        [_player stop];
        _player.delegate = nil;
        _player = nil;
    }
    NSError *playerError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];

    if (_player == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
        [ChatTools showLabelView:@"语音资源已受损" rootView:AppLicationWindow superController:AppRootViewController];
        return;
    }
    
    _player.volume = 1.0f;
    CGFloat duration = [_player duration];
    NSLog(@"duration = %.2f",duration);
    
    _player.delegate = self;

    [_player play];
    
    if(_delegate && [_delegate respondsToSelector:@selector(UUAVAudioPlayerBeiginPlay)]){
        
        [self.delegate UUAVAudioPlayerBeiginPlay];

    }
}

-(void)setupPlaySound{
//    UIApplication *app = [UIApplication sharedApplication];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    
    
    Class nowDelegateClass = object_getClass(_delegate);
    
    if(nowDelegateClass == _preDelegateClass){
        
        [self audioPlayDidFinishPlayToDelegate];
    }else{
        NSLog(@"语音播放代理已改变或被dealloc");
        [[NSNotificationCenter defaultCenter] postNotificationName:VoicePlayMessageFinish object:nil]; //代理可能被释放 。 确保播放结束回执 发通知
    }
    
}

- (void)audioPlayDidFinishPlayToDelegate
{

    if(_delegate && [_delegate respondsToSelector:@selector(UUAVAudioPlayerDidFinishPlay)]){
        
        [self.delegate UUAVAudioPlayerDidFinishPlay];
    }
}

- (void)stopSound
{
    if (_player && _player.isPlaying) {
        [_player stop];
        [self audioPlayDidFinishPlayToDelegate];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
    if (_player && _player.isPlaying) {
        [_player stop];
        
        [self audioPlayDidFinishPlayToDelegate];
    }
}


+(CGFloat)getMP3DataTime:(NSData *)soundData;
{
    if(soundData == nil) return 0.f;
    
    //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    NSError *playerError;
    AVAudioPlayer *currentAvPlayer = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];
    currentAvPlayer.volume = 1.0f;
    if (currentAvPlayer == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
        return 0.f;
    }
    
    CGFloat duration = [currentAvPlayer duration];
    
    return duration;
}

@end
