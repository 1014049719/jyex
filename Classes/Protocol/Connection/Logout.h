//
//  Logout.h
//  pass91
//
//  Created by Zhaolin He on 09-8-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol P91PassDelegate;
@interface Logout : NSObject {
	id<P91PassDelegate> delegate;
@private
	NSInputStream *input; 
	NSOutputStream *output;
	NSMutableData *temp_data;
	NSTimer *timer;
}
-(id)initWithInput:(NSInputStream *)inputs Output:(NSOutputStream *)outputs target:(id)obj;
-(void)logoutWithData:(NSData *)data;
@property(nonatomic,assign)id<P91PassDelegate> delegate;
@end