//
//  NoteOrder.m
//  NoteBook
//
//  Created by cyl on 13-3-8.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "NoteOrder.h"
#import "UIFolder.h"

@implementation NoteOrder
+(void)orderNoteByTitle:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType
{
    if ( noteArray && [noteArray count] > 1 ) {
        if ( orderType == NoteOrderTypeDescending) {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 return [item2->m_Title localizedCompare:item1->m_Title];
                 
             } ];
        }
        else
        {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 return [item1->m_Title localizedCompare:item2->m_Title];
                 
             } ];
        }
    }
}
    
+(void)orderNoteBySize:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType
{
    if ( noteArray && [noteArray count] > 1 )
    {
        if ( orderType == NoteOrderTypeDescending) {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item2->m_noteInfor.nNoteSize > item1->m_noteInfor.nNoteSize) {
                     return  NSOrderedDescending;
                 }
                 else if ( item2->m_noteInfor.nNoteSize < item1->m_noteInfor.nNoteSize) {
                     return  NSOrderedAscending;
                 }
                 return NSOrderedSame;
             } ];
        }
        else
        {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item1->m_noteInfor.nNoteSize > item2->m_noteInfor.nNoteSize) {
                     return  NSOrderedDescending;
                 }
                 else if ( item1->m_noteInfor.nNoteSize < item2->m_noteInfor.nNoteSize) {
                     return  NSOrderedAscending;
                 }
                 return NSOrderedSame;
             } ];
        }
    }
}

+(void)orderNoteByStar:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType
{
    if ( noteArray && [noteArray count] > 1 )
    {
        if ( orderType == NoteOrderTypeDescending) {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item2->m_noteInfor.nStarLevel > item1->m_noteInfor.nStarLevel) {
                     return  NSOrderedDescending;
                 }
                 else if ( item2->m_noteInfor.nStarLevel < item1->m_noteInfor.nStarLevel) {
                     return  NSOrderedAscending;
                 }
                 return NSOrderedSame;
             } ];
        }
        else
        {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item1->m_noteInfor.nStarLevel > item2->m_noteInfor.nStarLevel) {
                     return  NSOrderedDescending;
                 }
                 else if ( item1->m_noteInfor.nStarLevel < item2->m_noteInfor.nStarLevel) {
                     return  NSOrderedAscending;
                 }
                 return NSOrderedSame;
             } ];
        }
    }
}

+(void)orderNoteByModifyTime:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType
{
    if ( noteArray && [noteArray count] > 1 )
    {
        if ( orderType == NoteOrderTypeDescending) {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item2->m_Year > item1->m_Year ) {
                     return  NSOrderedDescending;
                 }
                 else if( item2->m_Year < item1->m_Year )
                 {
                     return  NSOrderedAscending;
                 }
                 else
                 {
                     if ( item2->m_Month > item1->m_Month ) {
                         return  NSOrderedDescending;
                     }
                     else if( item2->m_Month < item1->m_Month )
                     {
                         return  NSOrderedAscending;
                     }
                     else
                     {
                         if ( item2->m_Day > item1->m_Day ) {
                             return  NSOrderedDescending;
                         }
                         else if( item2->m_Day < item1->m_Day )
                         {
                             return  NSOrderedAscending;
                         }
                         else
                         {
                             return NSOrderedSame;
                         }
                     }
                 }
             }];
        }
        else
        {
            [noteArray sortUsingComparator:(NSComparator)^(id obj1, id obj2)
             {
                 UIFilesItem *item1 = (UIFilesItem *)obj1;
                 UIFilesItem *item2 = (UIFilesItem *)obj2;
                 if ( item1->m_Year > item2->m_Year ) {
                     return  NSOrderedDescending;
                 }
                 else if( item1->m_Year < item2->m_Year )
                 {
                     return  NSOrderedAscending;
                 }
                 else
                 {
                     if ( item1->m_Month > item2->m_Month ) {
                         return  NSOrderedDescending;
                     }
                     else if( item1->m_Month < item2->m_Month )
                     {
                         return  NSOrderedAscending;
                     }
                     else
                     {
                         if ( item1->m_Day > item2->m_Day ) {
                             return  NSOrderedDescending;
                         }
                         else if( item1->m_Day < item2->m_Day )
                         {
                             return  NSOrderedAscending;
                         }
                         else
                         {
                             return NSOrderedSame;
                         }
                     }
                 }
             }];
        }
    }
}
@end
