//
//  ProcResult.h
//  Money
//  执行结果定义
//  Created by shenqiliang on 10-6-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CS_RESULT_ID_SUCCESS   0
#define CS_RESULT_ID_WARNNING   1
#define CS_RESULT_ID_FAILURE   -1
#define CS_RESULT_ID_CONFIRMATION 2


@interface ProcResult : NSObject {
@public
	
	NSInteger resultID;
	NSString * resultInfo;	
    NSString * sysResultInfo;
}
@property (nonatomic) NSInteger resultID;
@property (nonatomic, copy) NSString *resultInfo;
@property (nonatomic, copy) NSString *sysResultInfo;
		   
-(id) init;	

@end
