//
//  ChatMoreView.m
//  Chat
//
//  Created by su_fyu on 15/6/3.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//

#import "ChatMoreView.h"

@interface ChatItemView : UIView

@property (nonatomic,strong) UIImageView *itemImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@end


@implementation ChatItemView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self initComponents];
    }
    
    return self;
    
}

-(void)initComponents
{
    _itemImageView = [[UIImageView alloc] init];
    _itemImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_itemImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    //
    _itemImageView.frame = CGRectMake(0.f, 0.f, width, height - ChatMoreTitle_height);
    //
    _titleLabel.frame = CGRectMake(0.f, CGRectGetMaxY(_itemImageView.frame), width, height -CGRectGetMaxY(_itemImageView.frame) );
    
}

@end

@interface ChatMoreView()

//间隙
@property (nonatomic, assign) CGFloat buttonSpaceX;

//父容器
//@property (nonatomic, assign) UIView *referView;

//当前能实现的行个数
@property (nonatomic, assign) int workingNumberOfButtonPerLine;
//存放views数组
@property (nonatomic, strong) NSMutableArray *itemsViewArr;

//按钮组 父视图
@property (nonatomic, strong) UIScrollView *buttonsView;


//行数
@property (nonatomic, assign) NSUInteger lines;

@end

@implementation ChatMoreView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self initPropertys];
        
        [self initComponents];
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self initPropertys];
        
        [self initComponents];
    }
    
    return self;
}

#pragma mark -- 属性
-(void)initPropertys
{
    
    _workingNumberOfButtonPerLine = 1;
    
    _itemsViewArr = [[NSMutableArray alloc] init];
    
    _butSize = CGSizeMake(100.f, 30.f);
    
    _numberOfline = 4;
    
    _titleFontSize = 14.f;
}

#pragma mark -- 组件
-(void)initComponents
{
    _buttonsView = [[UIScrollView alloc] init];
    _buttonsView.backgroundColor = [UIColor clearColor];
    _buttonsView.scrollsToTop = NO;
    _buttonsView.showsVerticalScrollIndicator = NO;
    _buttonsView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_buttonsView];
}

#pragma mark -- gett setter

-(void)setTitleFontSize:(float)titleFontSize
{
    _titleFontSize = titleFontSize;
    
    for(ChatItemView *view in _itemsViewArr){
        
        view.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        
    }
}

#pragma mark setter
-(void)setItemArr:(NSArray *)itemArr
{
    
    if(itemArr ==nil) return;

    _itemArr = itemArr ;
    
    
    for(UIView *view in _buttonsView.subviews){
        
        [view removeFromSuperview];
        
    }
    
    [_itemsViewArr removeAllObjects];
    
    
    for (NSInteger i=0; i<[itemArr count]; i++) {
        
        NSDictionary *itemDic = [itemArr objectAtIndex:i];
        
        NSString *imageName = itemDic[ChatMore_ImageNameKey];
        UIImage *image = [UIImage imageNamed:imageName];
        
        NSString *title = itemDic[ChatMore_TitleKey];
        
        ChatItemView * view = [[ChatItemView alloc] init];
        view.tag = i;
        view.userInteractionEnabled = YES;
        
        [view.itemImageView setImage:image];
        view.titleLabel.text = title;
        view.titleLabel.font = [UIFont systemFontOfSize:_titleFontSize];
        view.titleLabel.textColor = CUSTOMHEBCOLOR(0x424242);

        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        tag.numberOfTapsRequired = 1;
        tag.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tag];
        
        [self.buttonsView addSubview:view];
        
        [_itemsViewArr addObject:view];
    }
    
    
    [self layoutIfNeeded];
    
}


-(void)setNumberOfline:(int)numberOfline
{
    _numberOfline =numberOfline;
    [self calculateButtonSpaceWithNumberOfButtonPerLine:_numberOfline];
    
    [self setNeedsLayout] ;
}

-(void)setButSize:(CGSize)butSize
{
    _butSize = butSize;
    
    [self calculateButtonSpaceWithNumberOfButtonPerLine:self.workingNumberOfButtonPerLine];
    
    [self setNeedsLayout] ;
    
}

#pragma mark --   得到有效行数 及水平间隙
- (void)calculateButtonSpaceWithNumberOfButtonPerLine:(int)number
{
    if(number==-1) return;
    
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    self.buttonSpaceX =(width -_butSize.width *number)/(number + 1);
    
    if(self.buttonSpaceX <0){
        [self calculateButtonSpaceWithNumberOfButtonPerLine:number-1];
    }else{
           
       self.workingNumberOfButtonPerLine =number;
       
       self.buttonSpaceX =(width -_butSize.width *number)/(number + 1);
    }
    
}

-(void)viewClick:(UITapGestureRecognizer *)gesture
{
    
    UIView *view = gesture.view;
    
    NSInteger index = view.tag;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectedItem:forChatMoreView:)]){
        
        [_delegate didSelectedItem:index forChatMoreView:self];
        
    }
}

#pragma mark --布局
-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    _buttonsView.frame = self.bounds;
    
    [self calculateButtonSpaceWithNumberOfButtonPerLine:_numberOfline];
    
    NSUInteger count = [_itemsViewArr count];
    
    if(_workingNumberOfButtonPerLine <=0) _workingNumberOfButtonPerLine=1;
    
    _lines = count / _workingNumberOfButtonPerLine;
    if (count % self.workingNumberOfButtonPerLine != 0) {
        
        _lines++;
        
    }
    
    static CGFloat chatViewSpaceY = 20.f;
    
    for(int i=0;i<count;i++){
        
        //列的位置
        NSUInteger column = i % _workingNumberOfButtonPerLine;
        //行的位置
        NSUInteger row = i / _workingNumberOfButtonPerLine;
        
        CGFloat butX =(column+1) * self.buttonSpaceX + column*_butSize.width;
        CGFloat butY =(row+1) * chatViewSpaceY + row *_butSize.height ;
        //NSLog(@"x%i=%lf,y%d=%lf",i,butX,i,butY);
        
        CGRect butFrame ;
        butFrame.origin =CGPointMake(butX, butY);
        butFrame.size =_butSize;
        UIView  *btIcon =[_itemsViewArr objectAtIndex:i];
        
        btIcon.frame = butFrame;
    }
    
    
    CGFloat contentHeight =(_lines+1) *chatViewSpaceY  +_lines *_butSize.height ;
    
    
    if(contentHeight >_buttonsView.bounds.size.height){
        
        _buttonsView.contentSize  =CGSizeMake(_buttonsView.frame.size.width, contentHeight);
    }else{
        _buttonsView.contentSize  =CGSizeMake(_buttonsView.frame.size.width, _buttonsView.bounds.size.height);
    }
    
}

@end
