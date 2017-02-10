//
//  CPictureSelected.m
//  JYEX
//
//  Created by zd on 14-3-5.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import "CPictureSelected.h"
#import "CommonAll.h"
#import "UIImage+Scale.h"

@implementation CPictureSelected
@synthesize strFileName ;
@synthesize strPictureFileBig ;
@synthesize strPictureFileSmall ;
@synthesize editFlag ;
@synthesize picAlasset ;
@synthesize ID ;
@synthesize strPinLun ;

static int GID = 0 ;

+ (int)GetNextID
{
    GID++ ;
    return GID ;
}

+ (void)ResetID
{
    GID = 0 ;
}

- (id) init
{
    self = [super init] ;
    if( self )
    {
        self->strFileName = nil ;
        self->strPictureFileBig = nil ;
        self->strPictureFileSmall = nil ;
        self->picAlasset = nil ;
        self->editFlag = NO ;
        self->ID = [CPictureSelected GetNextID] ;
        self->strPinLun = nil ;
        self->lbPinLun = nil ;
    }
    return self ;
}

- (void)dealloc
{
    self.strFileName = nil ;
    self.strPictureFileBig = nil ;
    self.strPictureFileSmall = nil ;
    self.picAlasset = nil ;
    self.lbPinLun = nil ;
    self.strPinLun = nil ;
    [super dealloc] ;
}

- (void)initFileName
{
    NSString *strItemGuid = nil ;
    strItemGuid = [CommonFunc createGUIDStr] ;
    self.strFileName = strItemGuid ;
    self.strPictureFileSmall = [CommonFunc getItemPath:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    self.strPictureFileBig = [CommonFunc getItemPathAddSrc:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]] ;
}


@end
