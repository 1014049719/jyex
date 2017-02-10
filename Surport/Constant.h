/*
 *  Constant.h
 *  PPCatalog
 *
 *  Created by chen wu on 09-7-15.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#define RGBA(r,g,b,a) r/256.0, g/256.0, b/256.0, a
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
#define _(s) NSLocalizedString((s),@"")

#define CONFIGURE_FILE_PATH @"91Note.app/NoteBookConfig.plist"

// notificationName
#define kRefeshAplphaNotification			@"freshAplhaValue"
#define kDismissMenuNotification			@"dismissMenu"
#define kFreshUploadFlagNotification		@"freshUploadFlag"
#define kNoteTextFieldChangeNotification	@"textFieldChanged"
#define kHaveSynDataNotification			@"haveSynData"
#define NO_LIST								@"noList"
#define TIME_OUT							@"timeOut"

#define kDownCatesNotification              @"downCatesFinished"      //下载目录完成
#define kDownNewNotesNotification           @"downNewNotesFinished"   //下载最新笔记完成
#define kDownNotesByCateNotification        @"downNotesByCateFinished" //文件夹笔记下载完成
#define kDownSingleNotesNotification        @"downSingleNoteFinished"   //下载单个笔记完成
#define KDownSearchNotesNotificatiton       @"downSearchFinished"       //下载搜索结果完成

#define nRefreshNoteNew						@"refreshNoteNew"	// 刷新最新笔记
#define nRefreshNoteCate					@"refreshNoteCate"	// 刷新目录浏览

#define kUploadNoteListNotification         @"uploadNoteListFinish"
