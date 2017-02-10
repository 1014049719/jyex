//
//  UIImageEditorVC.m
//  CLImageEditorDemo
//
//  Created by zd on 14-2-19.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "UIImageEditorVC.h"
#import "CLImageEditor.h"
#import "UIImage+Scale.h"
#import "CImagePicker.h"

@interface UIImageEditorVC ()
<CLImageEditorDelegate>
@end

@implementation UIImageEditorVC
@synthesize callBackObject ;
@synthesize callBackSEL ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->pic = nil ;
        self->callBackObject = nil ;
        self->callBackSEL = nil ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->_scrollView.delegate = self ;
    self->_tabBar.delegate = self ;
    
    if( self->pic != nil )
    {
        if( !pic.editFlag )
        {
            /*
            CGImageRef ref = [[pic.picAlasset defaultRepresentation] fullResolutionImage];
            UIImage *img = [[UIImage alloc] initWithCGImage:ref];
            img = [CImagePicker fixOrientation:img] ;
            self->_imageView.image = img ;*/
            
            UIImage *img = [UIImage imageWithContentsOfFile:pic.strPictureFileBig];
            self->_imageView.image = img ;
        }
        else
        {
            UIImage *img = [UIImage imageWithContentsOfFile:pic.strPictureFileBig];
            self->_imageView.image = img ;
        }
    }
    [self refreshImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)pushedNewBtn
{
    //UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    //////
    //update by zd 2014-2-24
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
    //////
    [sheet showInView:self.view.window];
}

- (void)pushedEditBtn
{
    if(_imageView.image){
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:_imageView.image];
        editor.delegate = self;
        
        //CLImageEditor *editor = [[CLImageEditor alloc] initWithDelegate:self];
        
        /*
         NSLog(@"%@", editor.toolInfo);
         NSLog(@"%@", editor.toolInfo.toolTreeDescription);
         
         CLImageToolInfo *tool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
         tool.available = NO;
         
         tool = [editor.toolInfo subToolInfoWithToolName:@"CLRotateTool" recursive:YES];
         tool.available = NO;
         
         tool = [editor.toolInfo subToolInfoWithToolName:@"CLHueEffect" recursive:YES];
         tool.available = NO;
         */
        
        [self presentViewController:editor animated:YES completion:nil];
        
        //[self.navigationController pushViewController:editor animated:NO];
        //[editor showInViewController:self withImageView:_imageView];
    }
    else
    {
        [self pushedNewBtn];
    }
}

- (void)pushedSaveBtn
{
    if(_imageView.image){
        /*
        NSArray *excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
        
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[_imageView.image] applicationActivities:nil];
        
        activityView.excludedActivityTypes = excludedActivityTypes;
        activityView.completionHandler = ^(NSString *activityType, BOOL completed){
            if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"照片修改保存成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        };
        
        [self presentViewController:activityView animated:YES completion:nil];*/
        
        if( self.callBackObject != nil && self.callBackSEL != nil &&self->pic != nil )
        {
            pic.editFlag = YES ;
            NSData *data = nil ;
            BOOL ret ;
            data = UIImageJPEGRepresentation( _imageView.image, 1.0 ) ;
            ret = [data writeToFile:pic.strPictureFileBig atomically:YES] ;
            if( !ret )
            {
                NSLog( @"保存图片：[%@]失败", pic.strPictureFileBig ) ;
            }
            ret = [UIImage createScreenWidthImageFile:_imageView.image filename:pic.strPictureFileSmall] ;
            if( !ret )
            {
                NSLog( @"保存图片：[%@]失败", pic.strPictureFileSmall ) ;
            }

            if( [self.callBackObject respondsToSelector:self.callBackSEL] )
            {
                [self.callBackObject performSelector:self.callBackSEL withObject:self->pic] ;
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        [self pushedNewBtn];
    }
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    _imageView.image = image;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Tapbar delegate

- (void)deselectTabBarItem:(UITabBar*)tabBar
{
    tabBar.selectedItem = nil;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self performSelector:@selector(deselectTabBarItem:) withObject:tabBar afterDelay:0.2];
    
    //NSLog(@"didSelectItem.........");
    
    switch (item.tag) {
        case 0:
            [self pushedNewBtn];
            break;
        case 1:
            [self pushedEditBtn];
            break;
        case 2:
            //[self pushedSaveBtn];
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存图片?" delegate:self cancelButtonTitle:@"保存" otherButtonTitles:@"取消", nil];
                [alertView show] ;
            }
            break;
        case 3:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存编辑的图片?" delegate:self cancelButtonTitle:@"保存" otherButtonTitles:@"取消", nil];
                [alertView show] ;
            }
            break;
        default:
            break;
    }
    
}

#pragma mark-UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        [self pushedSaveBtn];
    }
    
    if( self.callBackObject != nil && self.callBackSEL != nil )
    {
        if( [self.callBackObject respondsToSelector:self.callBackSEL] )
        {
            [self.callBackObject performSelector:self.callBackSEL withObject:self->pic] ;
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
        if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark- ScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.superview.frame.size.width;
    CGFloat H = _imageView.superview.frame.size.height;
    
    CGRect rct = _imageView.superview.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.superview.frame = rct;
}

- (void)resetZoomScale
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
}

- (void)resetImageViewFrame
{
    CGRect rct = _imageView.bounds;
    rct.size = CGSizeMake(_scrollView.zoomScale*_imageView.image.size.width, _scrollView.zoomScale*_imageView.image.size.height);
    _imageView.frame = rct;
    _imageView.superview.bounds = _imageView.bounds;
}

- (void)resetZoomScaleWithAnimate:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width/_imageView.image.size.width;
    CGFloat Rh = _scrollView.frame.size.height/_imageView.image.size.height;
    CGFloat ratio = MIN(Rw, Rh);
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = ratio;
    _scrollView.maximumZoomScale = MAX(ratio/240, 1/ratio);
    
    [_scrollView setZoomScale:ratio animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (void)refreshImageView
{
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimate:NO];
}

- (void)setEditPicture:(CPictureSelected*)p
{
    self->pic = p ;
}

@end
