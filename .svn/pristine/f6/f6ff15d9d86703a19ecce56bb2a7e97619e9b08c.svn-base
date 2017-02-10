//
//  Plist.mm
//  CallInfo
//
//  Created by WU CHEN on 20/01/2009.
//  Copyright 2009 154. All rights reserved.
//

#import "Plist.h"


@implementation PlistController
@synthesize filePath;
-(id)initWithPath:(NSString *)plistPath
{
	if(self = [super init])
	{
		self.filePath =  plistPath;
		//MLOG(@"plist path = %@",plistPath);
	}
	return self;
}
-(NSMutableDictionary *)readDicPlist
{
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return  [plistDict autorelease];
}

- (NSArray *)readArrPlist
{
	NSMutableArray * plistArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
	return [plistArr autorelease];
}
- (void) wirteArrTofile:(NSArray * )plistArr
{
	[plistArr writeToFile:filePath atomically:YES];
}
- (void)writeToPlistWithKey:(NSString *) key vlaue:(id) val
{
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	[plistDict setValue:val forKey:key];
	[plistDict writeToFile:filePath atomically: YES];
	[plistDict  release];
}

- (void)dealloc
{
	[filePath release];
	[super dealloc];	
}
@end
