//
//  Plist.h
//  CallInfo
//
//  Created by WU CHEN on 20/01/2009.
//  Copyright 2009 154. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlistController : NSObject {
	NSString *filePath;
}

- (id)initWithPath:(NSString *)plistPath;
- (NSMutableDictionary *)readDicPlist;
- (NSArray *)readArrPlist;
- (void) wirteArrTofile:(NSArray * )plistArr;
- (void)writeToPlistWithKey:(NSString *) key vlaue:(id) val;

@property(nonatomic,retain)NSString *filePath;
@end
