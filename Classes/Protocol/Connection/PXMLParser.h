//
//  PXMLParser.h
//  pass91
//
//  Created by Zhaolin He on 09-8-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PXMLParser : NSObject {
	
}
+(BOOL) parseXMLWithURL:(NSURL *)url returnValue:(NSDictionary **)retValue;
@end
