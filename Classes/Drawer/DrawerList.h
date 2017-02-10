//
//  drawerList.h
//  photoEdit
//
//  Created by chen wu on 09-8-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Node : NSObject
{
	Node * next;
	CGPoint point;
}
@property(nonatomic) CGPoint point;
@property(nonatomic,retain) Node *next;// try assign
-(id)initWithPoint:(CGPoint) pt;

@end


@interface DrawerList : NSObject {
	Node	*currentNode;
	Node	*headNode;
	Node	*endNode;
	int		count;
}
-(void) addNode:(CGPoint) point;
-(Node*) getHead;
-(void) removeAll;
@property(nonatomic) int count;
@end
