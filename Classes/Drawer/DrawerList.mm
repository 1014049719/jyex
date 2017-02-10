//
//  drawerList.m
//  photoEdit
//
//  Created by chen wu on 09-8-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DrawerList.h"

@implementation Node
@synthesize point,next;
-(id)initWithPoint:(CGPoint) pt
{
	if(self = [super init])
	{
		point.x = pt.x;
		point.y = pt.y;
		next = nil;
	}
	return self;
}

@end

@implementation DrawerList
@synthesize count;
- (id) init
{
	if(self = [super init])
	{
		currentNode = nil;
		headNode = nil;
		endNode = nil;
		count = 0;
	}
	return self;
}

-(void) addNode:(CGPoint) point
{
	currentNode = [[Node alloc] initWithPoint:point];
	
	if(headNode == nil)
	{
		headNode = currentNode;
		endNode = currentNode;
	}else
	{
		endNode.next = currentNode;
		endNode = currentNode;
	}
	count++;
}
- (void) removeAll
{
	if(headNode == nil) return;
	Node * node = headNode;
	while (count>0) {
		headNode = headNode.next;
		[node release];
		node = headNode;
		count--;
	}
	headNode = endNode = nil;
}
- (Node *) getHead
{
	return headNode;
}
- (void)dealloc
{
    //	MLOG(@"dealloc note list");
	Node * node = headNode;
	for(int i = 0; i< count; i++)
	{
		Node * nextNode = node.next;
		[node release];
		node = nextNode;
	}
	headNode = nil;
	endNode = nil;
    //	MLOG(@"dealloc note list end");
	[super dealloc];
}
@end
