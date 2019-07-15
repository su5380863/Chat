//
//  UUAVAudioPlayer.h
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@protocol UUAVAudioPlayerDelegate <NSObject>

- (void)UUAVAudioPlayerBeiginLoadVoice;
- (void)UUAVAudioPlayerBeiginPlay;
- (void)UUAVAudioPlayerDidFinishPlay;

@end

@interface UUAVAudioPlayer : NSObject
@property (nonatomic ,strong)  AVAudioPlayer *player;
@property (nonatomic, assign)id <UUAVAudioPlayerDelegate>delegate;
+ (UUAVAudioPlayer *)sharedInstance;

-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

#pragma mark --获取MP3时长
+(CGFloat)getMP3DataTime:(NSData *)soundData;

@end
