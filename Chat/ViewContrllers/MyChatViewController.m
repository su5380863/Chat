//
//  MyChatViewController.m
//  Chat
//
//  Created by su_fyu on 15/5/26.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  聊天

#import "MyChatViewController.h"
#import "ChatModel.h"
#import "UUInputFunctionView.h"
#import "NSString+StringCheck.h"
#import "Conversation+CoreDataClass.h"
#import "UUAVAudioPlayer.h"
#import "PhotesBrows.h"
#import "NSString+Tools.h"
//cells
#import "DialogueBaseCell.h"

#import "NSManagedObjectContext+SafyCommit.h"

@interface MyChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UUInputFunctionViewDelegate,PhotesBrowsDelegate,DialogueCellDelegate>

@property (nonatomic ,strong) UITableView *chatTable; //table

@property (strong, nonatomic) ChatModel *chatModel; //聊天组

@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;//table底部约束

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;//数据管理器

@end

@implementation MyChatViewController
{
    UUInputFunctionView *iFView; //输入框
    
    NSString *_to_client_id; //userId
    
    PhotesBrows *_photobrow ; //相册调用
}

#pragma mark --lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _to_client_id = ToUser;
    
    [self initComponents];
    
    [self loadBaseViewsAndData];
    
    _managedObjectContext = [NSManagedObjectContext createNewManagedObjectContext];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getLocalMessage];

    [iFView addNotifications];
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottomByNoti:) name:UIKeyboardDidShowNotification object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [iFView cancelVoiceRecordIfNeed];
    [iFView removeNotications];
    [[UUAVAudioPlayer sharedInstance] stopSound];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [super viewWillDisappear:animated];
}

#pragma mark --键盘弹出或隐藏
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = - (keyboardEndFrame.size.height + CGRectGetHeight(iFView.frame));
    }else{
        self.bottomConstraint.constant = -(CGRectGetHeight(self.view.bounds) - CGRectGetMinY(iFView.frame));
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark --组件
-(void)initComponents
{
    _chatTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _chatTable.backgroundColor = [UIColor hexRGB:0xeeeeee];
    _chatTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    _chatTable.showsVerticalScrollIndicator = YES;
    _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTable.separatorColor = [UIColor orangeColor];
    
    _chatTable.delegate = self;
    _chatTable.dataSource = self;
    
    [self.view addSubview:_chatTable];
    
    UITapGestureRecognizer *tableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resgitFisrt:)];
    tableTap.numberOfTapsRequired = 1;
    tableTap.numberOfTouchesRequired = 1;
    [_chatTable addGestureRecognizer:tableTap];
    
    NSArray *constraints = nil;
    
    NSDictionary *views = @{@"view": self.view,@"_chatTable":_chatTable};
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_chatTable]|" options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_chatTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    [self.view addConstraint:topConstraint];
    
    _bottomConstraint = [NSLayoutConstraint constraintWithItem:_chatTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-UUInputView_DefaultHeight ];
    [self.view addConstraint:_bottomConstraint];
    
}

#pragma mark --tap点击事件
-(void)resgitFisrt:(UIGestureRecognizer *)geture
{
    if (geture.state == UIGestureRecognizerStateEnded){
        
        CGPoint point = [geture locationInView:_chatTable];
        NSIndexPath *indexPath = [_chatTable indexPathForRowAtPoint:point];
        
        if(indexPath ==nil){
            
            [self endEditing];
        }else{
            
            [self tableView:_chatTable didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (void)loadBaseViewsAndData
{
    _chatModel = [[ChatModel alloc]init];
    _chatModel.isGroupChat = NO;
    iFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    iFView.delegate = self;
    [self.view addSubview:iFView];
    
    [_chatTable reloadData];
    [self tableViewScrollToBottom:YES];
}

-(void)getLocalMessageSny
{
    @synchronized(self) {
        [self getLocalMessage];
    }
}
//获取本地数据
-(void)getLocalMessage
{
    NSString *user_id = UserSelf;
    
    NSPredicate *pre =[NSPredicate predicateWithFormat:@"(from_client_id==%@ and to_client_id==%@) or (from_client_id==%@ and to_client_id==%@)",_to_client_id,user_id,user_id,_to_client_id];
    
    //排序 时间升序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    //
    NSArray *mutablResult = [_managedObjectContext queryDatas:[Conversation class] predicate:pre sorts:@[sort]];
    
    [_chatModel.dataSource removeAllObjects];
    [_chatModel resetPriousTime];
    
    for(Conversation * entityObject in mutablResult){
        
        NSMutableDictionary *messageDic = nil;
        
        [_chatModel addMessageObjectEntity:entityObject withMoreParams:messageDic];
    }
    
    [_chatTable reloadData];

    
    [self tableViewScrollToBottom:NO];
}

- (void)tableViewScrollToBottomByNoti:(NSNotification *)notification
{
    [self tableViewScrollToBottom:YES];
}

#pragma mark -- tableView Scroll到底部
- (void)tableViewScrollToBottom:(BOOL)animate
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    @try {
        
        NSInteger count = _chatModel.dataSource.count ;
        NSInteger scrollRow = [self.chatTable numberOfRowsInSection:0];
        
        if(scrollRow >= count - 1){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_chatModel.dataSource.count-1 inSection:0];
            
            [self.chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animate];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"reason =%@,name =%@",exception.reason,exception.name);
    }
    @finally {
        
    }
}

#pragma mark ----------------------------------------------
#pragma mark - InputFunctionViewDelegate 文本
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    NSMutableString *contentText = [[NSMutableString alloc] initWithString:@""];
    
    BOOL isMinLengh = NO;
    if(message.length <3){ //最小宽度长度
        [contentText appendString:@" "];
        isMinLengh = YES;
    }
    
    [contentText appendString:message];
    
    if(isMinLengh){
        [contentText appendString:@" "];
    }
    NSDictionary * dic = [self saveContext:nil content:message withType:UUMessageTypeText from:UUMessageFromMe duration:0.f];
    [self dealTheFunctionData:dic from:UUMessageFromMe];
    
    NSDictionary * dic1 = [self saveContext:nil content:message withType:UUMessageTypeText from:UUMessageFromOther duration:0.f];
    [self dealTheFunctionData:dic1 from:UUMessageFromOther];
    iFView.TextViewInput.text = @"";
    [iFView changeSendBtnWithPhoto:YES];
}

- (NSDictionary *) saveContext:(NSData *)data content:(NSString *)content withType:(UUMessageEnumType)type from:(UUMessageEnumFrom) from duration:(CGFloat)duration
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    switch (from) {
        case UUMessageFromMe:
            [dic setValue:ToUser forKey:UUMessageTo_UserID];
            [dic setValue:UserSelf forKey:UUMessageUserID];
            break;
            
        default:
            [dic setValue:UserSelf forKey:UUMessageTo_UserID];
            [dic setValue:ToUser forKey:UUMessageUserID];
            break;
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    [dic setValue:currentDateString forKey:UUMessageTime];
    
    
    LoadType loadtype = 0;
    switch (type) {
        case UUMessageTypeVoice:
            [dic setValue:@"audio" forKey:@"media"];
            [dic setValue:[NSString stringWithFormat:@"%.0f",duration] forKey:UUMessageVoiceTime];
            loadtype = kTypeAudio;
            break;
        case UUMessageTypePicture:
            [dic setValue:@"image" forKey:@"media"];
            loadtype = kTypeImg;
            break;
            
        default:
            [dic setValue:@"text" forKey:@"media"];
            break;
    }
    
    if (type == UUMessageTypeText) {
         [dic setValue:content forKey:UUMessageContent];
    }else{
        
        NSString *namekey = [NSString nameKeyByMessageMedia:loadtype withDuration:duration];
        
        [self saveLoaclSoucreByFile:namekey withData:data andType:type];
        
        [dic setValue:namekey forKey:UUMessageContent];
    }
    
    [dic setValue:@"1232" forKey:@"id"];
    [dic setValue:@"123" forKey:@"img"];
    [dic setValue:@"用户名" forKey:UUMessageName];
    return dic;
}


- (void)handlerImageMessage:(UIImage *)image
{
   
    NSDictionary *dic = [NSDictionary dictionary];
        
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    
    dic = [self saveContext:imgData content:@"" withType:UUMessageTypePicture from:UUMessageFromMe duration:0.f];
    [self dealTheFunctionData:dic from:UUMessageFromMe];
    
    NSDictionary * dic1 = [self saveContext:imgData content:@"" withType:UUMessageTypePicture from:UUMessageFromOther duration:0.f];
   
    [self dealTheFunctionData:dic1 from:UUMessageFromOther];
}

#pragma mark --图片
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    [self handlerImageMessage:image];
}

#pragma mark --图片多选
-(void)UUInputFunctionView:(UUInputFunctionView *)funcView sendAssets:(NSArray *)assets
{
    if([assets count] > 0){
        
        ALAsset *asset = [assets objectAtIndex:0];
        //UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        CGImageRef fullResImage = [rep fullResolutionImage];
        //UIImage *image = [UIImage imageWithCGImage:fullResImage ];
        UIImage *image = [UIImage imageWithCGImage:fullResImage scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        image = [UIImage jpegImage:image];
        
        [self handlerImageMessage:image];
    }
}

#pragma mark --语音
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(CGFloat)second
{

    NSDictionary * dic = [self saveContext:voice content:@"" withType:UUMessageTypeVoice from:UUMessageFromMe duration:second];
    
    [self dealTheFunctionData:dic from:UUMessageFromMe];
    NSDictionary * dic1 = [self saveContext:voice content:@"" withType:UUMessageTypeVoice from:UUMessageFromOther duration:second];
    [self dealTheFunctionData:dic1 from:UUMessageFromOther];
}

#pragma mark --取消图片选择
-(void)UUInputFunctionViewDidPhotosCancel:(UUInputFunctionView *)funcView
{
    NSLog(@"图片取消");
}

#pragma mark --改变frame
-(void)UUInputFunctionViewChangeFrame:(UUInputFunctionView *)funcView animate:(BOOL)animate
{
    NSTimeInterval anmiteTime = 0.f;
    
    if(animate){
        anmiteTime = 0.3;
    }
    
    [UIView animateWithDuration:anmiteTime animations:^{
        
        CGRect funcFrame = funcView.frame;
        
        CGFloat bottom = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(funcFrame);
        
        self.bottomConstraint.constant = -bottom;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finish){
        
        [self tableViewScrollToBottom:YES];
        
    }];
}

#pragma mark --------------------------------------------------------------

#pragma mark --发送文件消息 先保存到本地缓存
-(NSString *)saveLoaclSoucreByFile:(NSString *)fileName withData:(NSData *)data andType:(UUMessageEnumType)type
{
    if(!data) return nil;
    
    NSString *foldName = [self getFoldName:type];
    
    NSString *filePath = [ChatTools getCachePathByFold:foldName withFileName:fileName];
    
    if([data writeToFile:filePath atomically:YES]){
        
        return filePath;
    };
    
    return nil;
}

-(NSString *)getFoldName:(UUMessageEnumType)type
{
    NSString *foldName = @"";
    
    if(type ==UUMessageTypePicture){
        foldName = UUImageFileCache;
    }else if (type == UUMessageTypeVoice){
        foldName = UUSoundFileCache;
    }else{
        
    }
    return foldName;
}

#pragma mark --增加聊天 cell *****
- (void)dealTheFunctionData:(NSDictionary *)dic from:(UUMessageEnumFrom) from
{
    if (from == UUMessageFromMe) {
         [_chatModel addSpecifiedItem:dic];
    }else{
         [_chatModel addOtherItem:dic];
    }
   
    [ChatModel saveMessageDataForDic:dic];
    [_chatTable reloadData];
    [self tableViewScrollToBottom:YES];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    
    UUMessageFrame *uuframe = (UUMessageFrame *) _chatModel.dataSource[row];
    
    UUMessageEnumType type = uuframe.message.type;
    
    BaseMessageCell *cell = [BaseMessageCell tableView:tableView cellForRowAtIndexPath:indexPath messageType:type];
    
//    cell.delegate = self;
    
    [cell setMessageFrame:uuframe withIndex:indexPath withTable:tableView];
    
    [cell setNeedsLayout];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UUMessageFrame *frame= _chatModel.dataSource[indexPath.row];
    CGFloat height = [frame chatCellHeight];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self endEditing];
}

-(void)endEditing
{
    [self.view endEditing:YES];
    [iFView resignFirstResponderText];
}

#pragma mark --srollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self endEditing];
}


#pragma mark  --- PhotesBrowsDelegate
- (void)didFinishPickingAssets:(NSArray *)assets withBrows:(PhotesBrows *)brows
{
    if([assets count] <1) return;
    
    ALAsset *asset = [assets objectAtIndex:0];
    ALAssetRepresentation *rep = asset.defaultRepresentation;
    CGImageRef fullResImage = [rep fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:fullResImage];
    
}


#pragma mark --布局
-(void)updateViewConstraints
{
    [super updateViewConstraints];
}

-(void)dealloc
{
    [UUAVAudioPlayer sharedInstance].delegate = nil;
    [[UUAVAudioPlayer sharedInstance] stopSound];
    _managedObjectContext = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSLog(@"chatViewDelloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
