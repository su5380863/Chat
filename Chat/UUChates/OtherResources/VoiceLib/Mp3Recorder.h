//
//  Mp3Recorder.h
//  BloodSugar
//
//  Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol Mp3RecorderDelegate <NSObject>
@optional
- (void)failRecord;
- (void)beginConvert;
- (void)endConvertWithData:(NSData *)voiceData;
@end

@interface Mp3Recorder : NSObject
@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;
@property (nonatomic, strong) AVAudioRecorder *recorder;

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate;
- (BOOL)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
//dealloc前 调用 防止crash
- (void)cancelRecordIfNeed;

- (NSString *)mp3Path;
@end
