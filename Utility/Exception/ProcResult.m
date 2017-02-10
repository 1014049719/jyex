//
//  ProcResult.m
//  Money
//
//  Created by shenqiliang on 10-6-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProcResult.h"


@implementation ProcResult

@synthesize resultID, resultInfo, sysResultInfo;

-(id)init
{
	self = [super init];
    if ( self ) {
        resultID = CS_RESULT_ID_SUCCESS;
        resultInfo = @"";
		sysResultInfo = @"";
    }
	return self;
}

-(void)dealloc
{
	self.resultInfo = nil;
	self.sysResultInfo = nil;
	
	[super dealloc];
}


@end
