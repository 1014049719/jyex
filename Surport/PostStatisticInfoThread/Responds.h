/*
 *  Responds.h
 *  NoteBook
 *
 *  Created by Huang Yan on 9/7/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#if !defined RESPONSE_H_
#define RESPONSE_H_

#import <UIKit/UIKit.h>

//void URLEncodeStr(const unsigned char *inBuf,int inBufLen,NSMutableData *outData);

//void URLEncodeData(NSData *inData,NSMutableData *outData);

/********************************************************************/
/*Fucntion: post data to server, and get return code and value. 	*/
/*url:		the url you want to post data					*/
/*paraData:	the data you want to post to server, binary data		*/
/*times:	the times which you post to server				*/
/*code:		the return code from HTTP Post, if code = 200, OK.		*/
/*return:	the response data from HTTP Post				*/
/********************************************************************/

NSData* getResponseData(NSString *url, NSData *paraData , NSInteger times, int &code);


/********************************************************************/
/*Fucntion: download file from a certain URL					*/
/*url:		the url you want to load data					*/
/*filePath:	the file path which you want to save data			*/
/*return:	get file from certain URL is success or not?			*/
/********************************************************************/

bool getFileFromURL(NSString* url,NSString* filePath);

//NSString* encryptStr(NSString *str);

#endif