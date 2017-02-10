//
//  UIFolderList.m
//  NoteBook
//
//  Created by cyl on 12-11-5.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "BizLogicAll.h"
#import  "DBMngAll.h"
#import "UIFolderList.h"

///
#import "UIFolderPaiXu.h"

@implementation UIFolderList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->m_FolderItemList = nil;
        //[self drawFolderList];
        // Initialization code
    }
    return self;
}

-(void)FreeAllFolderList
{
    if ( self->m_FolderItemList ) {
        UIFolderItemView *folderItrm = nil;
        for (NSUInteger i = 0; i < [self->m_FolderItemList count]; ++i ) {
            folderItrm = [self->m_FolderItemList objectAtIndex:i];
            if ( folderItrm ) {
                [folderItrm removeFromSuperview];
            }
        }
        [self->m_FolderItemList release];
        self->m_FolderItemList = nil;
    }
}

-(void)dealloc
{
    [self FreeAllFolderList];
    [super dealloc];
}

-(NSArray *)getFolderListData
{
    return [self getFolderListDataWithGUID:@""];
}

-(NSArray *)getFolderListDataWithGUID:(NSString*)strGUID
{
    return [BizLogic getCateList:strGUID];
}

-(void)drawFolderListWithGUID:(NSString*)strGUID
{
    if ( self->m_FolderItemList ) {
        [self FreeAllFolderList];
        [self->m_FolderItemList release];
        self->m_FolderItemList = nil;
    }
    self->m_FolderItemList = [[NSMutableArray alloc] init];
    assert( self->m_FolderItemList );
    
    NSArray *arrCate = [self getFolderListDataWithGUID:strGUID];
    if( !arrCate || [arrCate count] == 0) {
        return;
    }
    
    NSUInteger i=0;
    TCateInfo *cateInfor = nil;
    float y = 0.0;
    UIFolderItemView *folderItem = nil;
    CGRect r;
    for ( i = 0; i < [arrCate count]; ++i ) {
        cateInfor = (TCateInfo *)[arrCate objectAtIndex: i];
        assert( cateInfor );
        folderItem = [[UIFolderItemView alloc] initWithFrame:CGRectMake(0.0, y, 0.0, 0.0)];
        [folderItem setInforWithCateInfor:cateInfor];
        [folderItem drawFolderItem];
        [self addSubview:folderItem];
        [self->m_FolderItemList addObject:folderItem];
        if ( i == 0 ) {
            r = folderItem.frame;
        }
        y += r.size.height * 104.0/144.0;
        [folderItem release];  //add 2013.1.12
    }
    y += r.size.height * 40.0/144.0;
    self.frame = CGRectMake(0.0, 0.0, r.size.width, y);
}

-(void)drawFolderList
{
    if ( self->m_FolderItemList ) {
        [self FreeAllFolderList];
        [self->m_FolderItemList release];
        self->m_FolderItemList = nil;
    }
    self->m_FolderItemList = [[NSMutableArray alloc] init];
    assert( self->m_FolderItemList );
    
    NSArray *arrCate = [self getFolderListData];
    if( !arrCate || [arrCate count] == 0) {
        return;
    }
    
    NSUInteger i = 0;
    TCateInfo *cateInfor = nil;
    float y = 0.0;
    UIFolderItemView *folderItem = nil;
    CGRect r;
    for ( i = 0; i < [arrCate count]; ++i ) {
        cateInfor = (TCateInfo *)[arrCate objectAtIndex: i];
        assert( cateInfor );
        folderItem
        = [[UIFolderItemView alloc] initWithFrame:CGRectMake(0.0, y, 0.0, 0.0)];
        [folderItem setInforWithCateInfor:cateInfor];
        [folderItem drawFolderItem];
        [self addSubview:folderItem];
        [self->m_FolderItemList addObject:folderItem];
        if ( i == 0 ) {
            r = folderItem.frame;
        }
        y += r.size.height * 104.0/144.0;
        [folderItem release]; //add 2013.1.12
    }
    y += r.size.height * 40.0/144.0;
    self.frame = CGRectMake(0.0, 0.0, r.size.width, y);
}

-(int)getFolderCount
{
    return (self->m_FolderItemList ? [self->m_FolderItemList count] : 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
