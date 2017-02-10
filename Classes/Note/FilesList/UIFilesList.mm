//
//  UIFilesList.m
//  NoteBook
//
//  Created by cyl on 12-11-9.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UIFilesList.h"
#import "UIFilesItem.h"

@implementation UIFilesList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawFilesList];
        // Initialization code
    }
    return self;
}


-(void)drawFilesList
{
    self->m_FilesList = [[NSMutableArray alloc] init];
    UIFilesItem *f
    = [[UIFilesItem alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    f->m_Title = @"第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦";
    f->m_Synopsis = @"第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦第一次测试哦,哦";
    f->m_Week = 4;
    f->m_Day = 25;
    [f drawFileItem];
    self.frame = f.frame;
    [self addSubview:f];
    [f release];
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
