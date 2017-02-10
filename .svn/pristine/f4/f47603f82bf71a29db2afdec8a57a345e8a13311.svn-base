//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"
//#import <objc/objc-class.h>
//#import "YcKeyBoardView.h"


@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    //UIButton *_saveImageBtn;
    
    //增加点赞还有发表评论的按钮 add by zd 2014-12-29
    //UILabel *_imagexqLabel;//相片详情
    UIButton *_dzImageBtn;//点赞
    UIButton *_plImageBtn;//评论
    UIButton *_xqImageBtn;//详情
    
}

@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    /*
    _imagexqLabel = [[UILabel alloc] init];
    _imagexqLabel.font = [UIFont systemFontOfSize:10];
    _imagexqLabel.frame = CGRectMake(5, 0, self.bounds.size.width - 10, 15);
    _imagexqLabel.backgroundColor = [UIColor clearColor];
    _imagexqLabel.textColor = [UIColor whiteColor];
    _imagexqLabel.textAlignment = NSTextAlignmentLeft ;
    _imagexqLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imagexqLabel.text = @"这里显示的是该相片的相片详情" ;
    [self addSubview:_imagexqLabel];
     */
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    CGFloat btnWidth = self.bounds.size.height;
    
    
    /*
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
     */
    
    
    //点攒按钮
    //btnWidth = self.bounds.size.height;
    _dzImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dzImageBtn.frame = CGRectMake(5, 1, btnWidth, btnWidth);
    _dzImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_dzImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_dzImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_dzImageBtn addTarget:self action:@selector(dzImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dzImageBtn];
    
    
    //发表评论按钮
    //btnWidth = self.bounds.size.height;
    _plImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _plImageBtn.frame = CGRectMake(btnWidth, 1, btnWidth, btnWidth);
    _plImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_plImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_plImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_plImageBtn addTarget:self action:@selector(plImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_plImageBtn];
    
    //查看图片详情的按钮
    //btnWidth = self.bounds.size.height;
    _xqImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xqImageBtn.frame = CGRectMake( self.bounds.size.width - 80 - 5, 1, 80, btnWidth);
    _xqImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _xqImageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //[_xqImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    //[_xqImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_xqImageBtn setTitle:@"查看详情>>" forState:UIControlStateNormal];
    [_xqImageBtn addTarget:self action:@selector(xqImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_xqImageBtn];
    
}

//点赞
- (void)dzImage
{
    NSLog( @"点赞" ) ;
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    objc_msgSend( callobject, @selector(imageDZ:),photo.imageDic );
}

//评论
- (void)plImage
{
    NSLog( @"评论" ) ;
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    objc_msgSend( callobject, @selector(sendPL:), photo.imageDic );
}

//查看图片详情
- (void)xqImage
{
    NSLog( @"详情" ) ;
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    objc_msgSend( callobject, @selector(imageXQ:),photo.imageDic );
}





- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        //_saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    NSString *xq = [photo.imageDic objectForKey:@"imagexq"];
    objc_msgSend( callobject, @selector(showImageXQ:), xq );
    //_imagexqLabel.text = xq ;
    
    // 更新页码
    //_indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", _currentPhotoIndex + 1, _photos.count];
    NSString *str = [NSString stringWithFormat:@"%ld / %ld", _currentPhotoIndex + 1, _photos.count];
    //[callobject performSelector:callbackSEL withObject:str];
    objc_msgSend( callobject, callbackSEL, str );
    
    //MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    //_saveImageBtn.enabled = photo.image != nil && !photo.save;
}




@end
