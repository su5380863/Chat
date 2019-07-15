//
//  FaceViews.m
//  Chat
//
//  Created by su_fyu on 15/6/1.
//  Copyright (c) 2015年 su_fyu. All rights reserved.
//  表情图片

#import "FaceViews.h"

#define Face_Image_PaddingY     15.f  //表情图片垂直间隙

#define Face_PageViw_height     20.f  //page页面高度

#define Face_BottomHeight       40.f  //底部高度

@protocol faceItemViewDelegate <NSObject>

-(void)didSelectedFaceIndex:(NSInteger)index withFaceText:(NSString *)faceText;

-(void)didDeleteIconImage;

@end

@interface FaceItemView : UIView

+ (NSInteger)calculateWithNumberWidth:(CGFloat)width andHeight:(CGFloat)height withIconSize:(CGSize) iconSzie;

- (void)setIconArr:(NSArray *)iconArr;

@property (nonatomic,strong) NSMutableArray *itemsViewArr; //按钮数组
@property (nonatomic,strong) NSArray *iconArr; //表情数组

@property (nonatomic,weak) id <faceItemViewDelegate>delegate;

//当前一页能显示的列个数
@property (nonatomic) NSUInteger colNumber; //default 5

//能实现的列个数
@property (nonatomic, assign) NSUInteger workingNumberOfRow;
//水平间隙
@property (nonatomic, assign) CGFloat faceImagePaddingX;
//行数
@property (nonatomic, assign) NSUInteger lines;
//表情大小
@property (nonatomic, assign) CGSize iconSize;

@property (nonatomic, strong) UIButton *delBtn;

@end


@implementation FaceItemView

static CGFloat face_X = 15.f;
+ (NSInteger)calculateWithNumberWidth:(CGFloat)width andHeight:(CGFloat)height withIconSize:(CGSize) iconSzie
{

    int row = [self calcauteRowByHeight:height withIconSize:iconSzie];
    
    if(row <1) row =1;
    
    int col =[self calcauteRowByWidth:width withIconSize:iconSzie];
    
    if(col <1) col =1;
    
    NSInteger total = (row * col);
    
    return  total- 1;  //最后一个是删除按钮

}

#pragma mark --
+(int)calcauteRowByHeight:(CGFloat)height withIconSize:(CGSize)iconSize
{
    int row =(height - Face_Image_PaddingY) /(iconSize.height + Face_Image_PaddingY);
    
    return row;
}

#pragma mark --
+(int)calcauteRowByWidth:(CGFloat)width withIconSize:(CGSize)iconSize
{
    int col =( width - face_X )/(face_X +iconSize.width);
    
    return col;
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

-(void)initPropertys
{
    self.backgroundColor = [UIColor clearColor];
    
    _itemsViewArr = [[NSMutableArray alloc] init];
    
    _iconSize = CGSizeMake(20.f, 20.f);
    
    _colNumber = 5;

}

-(void)initComponents
{
    _delBtn = [[UIButton alloc] init];
    [_delBtn addTarget:self action:@selector(deleteIcon:) forControlEvents:UIControlEventTouchUpInside];
    [_delBtn setBackgroundImage:[UIImage imageNamed:@"message_btn_delete"] forState:UIControlStateNormal];
    [self addSubview:_delBtn];
}

- (void)setIconArr:(NSArray *)iconArr
{
    _iconArr = iconArr;
    
    for(NSInteger i = 0 ; i < [iconArr count]; i++){
        
        NSString *iconKey = [iconArr objectAtIndex:i];
        
        NSString *iconFile = [iconKey stringByAppendingPathExtension:@"png"];
        
        UIImage *backImg = [UIImage imageNamed:iconFile];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setExclusiveTouch:YES];
        [btn setBackgroundImage:backImg forState:UIControlStateNormal];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(faceSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [_itemsViewArr addObject:btn];
        
    }
}

-(void)faceSelected:(UIButton *)sender
{
    NSInteger selectedIndex = sender.tag;
    
    NSString *iconKey = [_iconArr objectAtIndex:selectedIndex];
    
    NSDictionary *faceDic = [FaceIconFile getFaceMap];
    
    NSString *faceText = faceDic[iconKey];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectedFaceIndex:withFaceText:)]){
        
        [_delegate didSelectedFaceIndex:selectedIndex withFaceText:faceText ];
        
    }
}

-(void)deleteIcon:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(didDeleteIconImage)]){
        
        [_delegate didDeleteIconImage ];
        
    }
}

#pragma mark --布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);

    //[self calculateButtonSpaceWithNumberOfButtonPerLine:_colNumber];
    _colNumber = (width -face_X) / (_iconSize.width + face_X);
    
    _faceImagePaddingX =(width - _iconSize.width * _colNumber) /(_colNumber + 1);
    
    NSUInteger count = [_itemsViewArr count];
    
    for(int i=0;i<count;i++){
        
        //列的位置
        NSUInteger column = i % _colNumber;
        //行的位置
        NSUInteger row = i / _colNumber;
        
        CGFloat butX =(column+1) * _faceImagePaddingX + column*_iconSize.width;
        CGFloat butY =(row+1) * Face_Image_PaddingY + row *_iconSize.height ;
        
        CGRect btnFrame = CGRectMake(butX, butY, _iconSize.width, _iconSize.height);
        
        UIView  *btIcon =[_itemsViewArr objectAtIndex:i];
        
        btIcon.frame = btnFrame;
    }
    
    
    _lines = [[self class] calcauteRowByHeight:height withIconSize:_iconSize];
    if(_lines <1) _lines = 1;
    
    CGFloat delx = width - _iconSize.width - _faceImagePaddingX;
    CGFloat dely = _lines * Face_Image_PaddingY + (_lines -1) * _iconSize.height + 1;
    _delBtn.frame = CGRectMake(delx, dely, 36.f,26.6f);
}

#pragma mark --   得到有效列间隙
- (void)calculateButtonSpaceWithNumberOfButtonPerLine:(NSUInteger)rowNumber
{
    
//    CGFloat width = CGRectGetWidth(self.bounds);
//
//    if(_faceImagePaddingX <0){
//        [self calculateButtonSpaceWithNumberOfButtonPerLine:rowNumber-1];
//    } else if (_faceImagePaddingX > _iconSize.width ){
//        
//        [self calculateButtonSpaceWithNumberOfButtonPerLine:rowNumber+1];
//        
//    }else{
//        
//        _faceImagePaddingX =(width - _iconSize.width * rowNumber) /(rowNumber + 1);
//        
//        _rowNumber = rowNumber;
//    }
    
}

@end

@interface FaceViews()<UIScrollViewDelegate,faceItemViewDelegate>


//按钮组 滚动视图
@property (nonatomic, strong) UIScrollView *buttonsView;
//页码
@property (nonatomic, strong) UIPageControl *pageView;
//底部
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *senderBtn; //发送按钮

@end

@implementation FaceViews


-(id)initWithFrame:(CGRect)frame
{
    
    self = [ super initWithFrame:frame];
    
    if(self){
        
        [self initFaceProperty];
        
        [self initComponents];

        //[self createBtnFaceIconByFile];
    }
    
    return self;
    
}

#pragma mark --初始组件
-(void)initComponents
{
    //
    self.backgroundColor = [UIColor whiteColor];
    _buttonsView = [[UIScrollView alloc] init];
    _buttonsView.scrollsToTop = NO;
    _buttonsView.backgroundColor = [UIColor clearColor];
    _buttonsView.showsVerticalScrollIndicator = NO;
    _buttonsView.showsHorizontalScrollIndicator = NO;
    _buttonsView.delegate = self;
    _buttonsView.pagingEnabled = YES;
    [self addSubview:_buttonsView];
    
    //
    _pageView = [[UIPageControl alloc] init];
    _pageView.currentPageIndicatorTintColor = CUSTOMHEBCOLOR(0x424242);
    _pageView.pageIndicatorTintColor = CUSTOMHEBCOLOR(0xbdbdbd);
    _pageView.enabled = NO;
    [self addSubview:_pageView];
    
    //
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.layer.borderColor = CUSTOMHEBCOLOR(0xbdbdbd).CGColor;
    _bottomView.layer.borderWidth = 0.5;
    [self addSubview:_bottomView];
        //发送按钮
    _senderBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_senderBtn setTitle:@"发送" forState:UIControlStateNormal];
    _senderBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
    [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_senderBtn setBackgroundImage:[UIImage createImageWithColor:CommonTextColor] forState:UIControlStateNormal];
    [_senderBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_senderBtn];
    
}

#pragma mark --属性
-(void)initFaceProperty
{
    _butSize = CGSizeMake(30.f, 30.f);
    
}

#pragma mark -发送
-(void)sendMessage
{
    if(_delegate && [_delegate respondsToSelector:@selector(didSenderMessageWithView:)]){
        
        [_delegate didSenderMessageWithView:self];
        
    }
}

-(void)setFaceIconViews
{
    [self layoutIfNeeded];
    
    CGFloat height = CGRectGetHeight(_buttonsView.bounds);
    CGFloat width = CGRectGetWidth(_buttonsView.bounds);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *faceDic = [FaceIconFile getFaceMap];
        
        NSArray *faceArr =[[faceDic allKeys] sortedArrayUsingComparator:^NSComparisonResult (NSString *key1,NSString *key2){
            
            NSUInteger lengh1 = key1.length;
            NSUInteger lengh2 = key2.length;
            
            if(lengh1 < lengh2){
                
                return NSOrderedAscending;
                
            }else if (lengh1 > lengh2){
                
                return NSOrderedDescending;
                
            }else{
                
                NSComparisonResult result = [key1 compare:key2];
                
                return result;
            }
            
            
        }];
        
        NSInteger itemCount = [FaceItemView calculateWithNumberWidth:width andHeight:height withIconSize:_butSize];  //一页的表情个数
        if(itemCount <=0) return ;

        NSInteger faceCount = [faceArr count];  //页数
        
        NSInteger countView = faceCount/itemCount; //余数
        
        NSInteger yushu = faceCount % itemCount;
        
        if(yushu != 0){
            
            countView ++ ;
        }

        
        for(NSInteger i =0; i< countView; i++){
            
            NSMutableArray *iconArr = [[NSMutableArray alloc] initWithCapacity:itemCount];
            
            FaceItemView *faceItemView = [[FaceItemView alloc] initWithFrame:CGRectMake(width * i, 0.f, width, height)];
            faceItemView.delegate = self;
            faceItemView.iconSize = _butSize;
            
            for(NSInteger j= 0; j< itemCount; j++){
                
                NSInteger index = i * itemCount +j ;
                
                if(index >= faceCount) break;
                
                id item = [faceArr objectAtIndex:index];
                [iconArr addObject:item];

            }

            
            [faceItemView setIconArr:iconArr];
            
            [_buttonsView addSubview:faceItemView];
            
        }
        
        _buttonsView.contentSize = CGSizeMake(width * countView, height);
        _pageView.numberOfPages  = countView;
    });
}

#pragma mark --setter
-(void)setButSize:(CGSize)butSize
{
    _butSize = butSize;
    
}


#pragma mark FaceItemViewDelegate
-(void)didSelectedFaceIndex:(NSInteger)index withFaceText:(NSString *)faceText
{
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectedFaceIndex:withFaceText:withView:)]){
        
        [_delegate didSelectedFaceIndex:index withFaceText:faceText withView:self];
        
    }
}

-(void)didDeleteIconImage
{
    if(_delegate && [_delegate respondsToSelector:@selector(didDeleteIconImageWithView:)]){
        
        [_delegate didDeleteIconImageWithView:self];
        
    }
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)ascrollView
{
    [self setPageViewCurrentPage:ascrollView];
}

// scrollview停止 表示新contentoffset 位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView
{
    
    [self setPageViewCurrentPage:ascrollView];
    
}

-(void)setPageViewCurrentPage:(UIScrollView *)ascrollView
{
    CGFloat width = CGRectGetWidth(ascrollView.bounds);
    
    CGFloat offsetX = ascrollView.contentOffset.x;
    
    NSInteger index = offsetX / width;
    
    _pageView.currentPage = index;
}

#pragma mark --布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat heightSelf = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    //
    _buttonsView.frame = CGRectMake(0.f, 0.f, width, heightSelf - Face_PageViw_height - Face_BottomHeight);
    //
    CGFloat pagePaddingY = 10.f;
    _pageView.frame = CGRectMake(0.f, CGRectGetMaxY(_buttonsView.frame), width, Face_PageViw_height - pagePaddingY);
    
    //
    _bottomView.frame = CGRectMake(0.f, CGRectGetMaxY(_pageView.frame) + pagePaddingY, width, Face_BottomHeight);
    CGFloat sendBtnW = 75.f * autoSacleX;
    
    CGFloat sendW = MAX(75.f, sendBtnW);
    _senderBtn.frame = CGRectMake(width - sendW, 0.f, sendW, Face_BottomHeight);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
