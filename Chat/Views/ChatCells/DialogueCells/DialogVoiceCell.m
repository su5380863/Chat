//
//  DialogVoiceCell.m
//  Chat
//
//  Created by su_fyu on 16/1/7.
//  Copyright © 2016年 su_fyu. All rights reserved.
//  语音类型消息

#import "DialogVoiceCell.h"

@interface DialogVoiceCell()<UUAVAudioPlayerDelegate>

@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *second; //秒
@property (nonatomic, strong) UIImageView *voice; //语音图片
@property (nonatomic, strong) UIActivityIndicatorView *indicator;   //下载


@property (nonatomic) BOOL contentVoiceIsPlaying; //语音是否在播放
@property (nonatomic, weak) UUAVAudioPlayer *audio; //播放器

@property (nonatomic, strong) NSData *songData;   //音频流

@end

@implementation DialogVoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        [self initVoiceComponents];
        
        [self addNotifications];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //CGFloat sendbackWidth = CGRectGetWidth(self.sendBackBBView.bounds);
    CGFloat sendbackHeight = CGRectGetHeight(self.sendBackBBView.bounds);
    
    CGPoint voiceBackCenter = _voiceBackView.center;
    voiceBackCenter.y = sendbackHeight/2;
    _voiceBackView.center = voiceBackCenter;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    dialogVoicePlayingIndex = nil;
    
}

#pragma mark --ovrride func
- (void)setMessageFrame:(UUMessageFrame *)messageFrame withIndex:(NSIndexPath *)indexPath withTable:(UITableView *)tableView {
    
    [super setMessageFrame:messageFrame withIndex:indexPath withTable:tableView];
    
    UIImage *imageVoice = nil;
    if ([self isMyMessage]) {
        
        self.voiceBackView.frame = CGRectMake(15, 9, 130, 32);
        self.second.textColor = [UIColor whiteColor];
        
        imageVoice = [UIImage imageNamed:@"message_im_sound_r3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"message_im_sound_r1"],
                                      [UIImage imageNamed:@"message_im_sound_r2"],
                                      [UIImage imageNamed:@"message_im_sound_r3"],nil];
        
        
    }else{
        
        self.voiceBackView.frame = CGRectMake(25, 9, 130, 32);
        
        self.second.textColor = [UIColor grayColor];
        
        imageVoice = [UIImage imageNamed:@"message_im_sound_l3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"message_im_sound_l1"],
                                      [UIImage imageNamed:@"message_im_sound_l2"],
                                      [UIImage imageNamed:@"message_im_sound_l3"],nil];
    }
    
    self.voice.image = imageVoice;
    self.voice.animationDuration = 1;
    self.voice.animationRepeatCount = 0;
    
    
    if([indexPath compare:dialogVoicePlayingIndex] == NSOrderedSame ){
        
        if (dialogVoicePlayingIndex !=nil) {
            NSLog(@"voicePlayingIndex =%@, section =%zi,row =%zi",dialogVoicePlayingIndex,dialogVoicePlayingIndex.section,dialogVoicePlayingIndex.row);
            [self didPlayVoice];
        }
        
    }
    
    UUMessage *message = self.messageFrame.message;
    
    NSData *voiceData = nil;
    
    if(message.content){ //缓存里面取
        NSString *path = [ChatTools getCachePathByFold:UUSoundFileCache withFileName:message.content];
        
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        voiceData = [[NSData alloc] initWithContentsOfURL:fileUrl];
    }
    
    _songData = voiceData;

    CGFloat duration = [UUAVAudioPlayer getMP3DataTime:voiceData];
    NSString *strVoiceTime = [NSString stringWithFormat:@"%.0f''",duration];
    self.second.text = strVoiceTime;
 
}

#pragma mark --custom methods
- (void)initVoiceComponents {
    
    _voiceBackView = [[UIView alloc]init];
    _voiceBackView.userInteractionEnabled = YES;
    _voiceBackView.backgroundColor = [UIColor clearColor];
    [self.sendBackBBView addSubview:_voiceBackView];
    
    UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceTapClick:)];
    voiceTap.numberOfTapsRequired = 1;
    voiceTap.numberOfTouchesRequired = 1;
    [_voiceBackView addGestureRecognizer:voiceTap];
    
    //
    _second = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _second.textAlignment = NSTextAlignmentCenter;
    _second.font = [UIFont systemFontOfSize:14];
    _second.backgroundColor = [UIColor clearColor];
    
    //
    _voice = [[UIImageView alloc]initWithFrame:CGRectMake(80, 3.5, 20, 25)];
    _voice.contentMode = UIViewContentModeScaleAspectFit;
    _voice.backgroundColor = [UIColor clearColor];
    //
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center=CGPointMake(80, 15);
    
    [_voiceBackView addSubview:_indicator];
    [_voiceBackView addSubview:_voice];
    [_voiceBackView addSubview:_second];

}

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioPlayerDidFinishPlay) name:VoicePlayHasInterrupt object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioPlayerDidFinishPlay) name:VoicePlayMessageFinish object:nil];
}

#pragma mark --语音点击
- (void)voiceTapClick:(UITapGestureRecognizer *)tapGesture {
    
    if(!self.contentVoiceIsPlaying){
        
        if(self.songData==nil) return;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VoicePlayHasInterrupt object:nil];
        
        self.contentVoiceIsPlaying = YES;
        
        self.audio = [UUAVAudioPlayer sharedInstance];
        
        self.audio.delegate = self;
        
        [self.audio playSongWithData:self.songData];
        
        dialogVoicePlayingIndex = self.aIndexPath;
    }else{
        [self UUAVAudioPlayerDidFinishPlay];
    }
}

#pragma mark --语音播放结束
- (void)audioPlayerDidFinishPlay {
    
    _contentVoiceIsPlaying = NO;
    dialogVoicePlayingIndex = nil;
    [self stopPlay];
}



static NSIndexPath *dialogVoicePlayingIndex = nil; //记录播放语音的index
#pragma mark --UUAVAudioPlayerDelegate
- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self benginLoadVoice];
}

- (void)UUAVAudioPlayerBeiginPlay
{
    [self didPlayVoice];
}

- (void)UUAVAudioPlayerDidFinishPlay
{
    [self audioPlayerDidFinishPlay];
}

#pragma mark -- public
-(void)startVoiceAnimating
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}

-(void)stopVoiceAnimating
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
}

- (void)benginLoadVoice
{
    [self startVoiceAnimating];
}

- (void)didPlayVoice
{
    [self stopVoiceAnimating];
    [self.voice startAnimating];
}

-(void)stopPlay
{
    [self.voice stopAnimating];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
