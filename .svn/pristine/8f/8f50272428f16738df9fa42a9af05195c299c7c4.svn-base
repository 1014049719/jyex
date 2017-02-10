/*
 *  UpStruct.h
 *  NoteBook
 *
 *  Created by chen wu on 09-10-27.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

// 笔记结构

typedef enum NOTE_STATE
	{
		NOTE_NEW = 1011,
		NOTE_DEL ,
		NOTE_EDIT
	}NO_STATE;


typedef struct UPLOAD_STURCT
	{
		int				len;
		id				itemContent;
		NSString		*noteId;
		NSString		*itemId;
		NSString		*title;
		NSString		*firstExt;
		NSString		*address;
		NSString		*src;

		int				cVerId;
		int				mVerId;
		NO_STATE		nState;
		ENUM_NOTE_TYPE	noteType;
		ENUM_ITEM_TYPE	itemType;
	} UP_STRUCT;