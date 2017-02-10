//
//  NoteOrder.h
//  NoteBook
//
//  Created by cyl on 13-3-8.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>

//排序根据
enum {
    NoteOrderByTitle,               //按标题
    NoteOrderByCreateTime,    //按创建时间
    NoteOrderByModifyTime,   //按修改时间
    NoteOrderBySize,               //按大小
    NoteOrderByStar                //按星级
};

typedef NSUInteger NoteOrderBy;

//排序类型
enum{
    NoteOrderTypeDescending,    //降序
    NoteOrderTypeAscending       //升序
};

typedef NSUInteger NoteOrderType;

@interface NoteOrder : NSObject
{
    NoteOrderBy m_NoteOrderBy;
    NoteOrderType m_NoteOrderType;
}
+(void)orderNoteWithArray:(NSMutableArray*)noteArray \
OrderBy:(NoteOrderBy)orderBy OrderType:(NoteOrderType)orderType;

+(void)orderNoteByTitle:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType;
+(void)orderNoteBySize:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType;

+(void)orderNoteByStar:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType;

+(void)orderNoteByModifyTime:(NSMutableArray*)noteArray OrderType:(NoteOrderType)orderType;

@end
