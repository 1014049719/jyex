//
//  PPUndoManager.h
//  NoteBook
//
//  Created by chen wu on 09-08-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSNotification.h>
#include <Foundation/NSInvocation.h>
#include <Foundation/NSException.h>
#include <Foundation/NSRunLoop.h>
#include "PPUndoManager.h"

/* Public notifications */
NSString *PPUndoManagerCheckpointNotification =
@"PPUndoManagerCheckpointNotification";
NSString *PPUndoManagerDidOpenUndoGroupNotification =
@"PPUndoManagerDidOpenUndoGroupNotification";
NSString *PPUndoManagerDidRedoChangeNotification =
@"PPUndoManagerDidRedoChangeNotification";
NSString *PPUndoManagerDidUndoChangeNotification =
@"PPUndoManagerDidUndoChangeNotification";
NSString *PPUndoManagerWillCloseUndoGroupNotification =
@"PPUndoManagerWillCloseUndoGroupNotification";
NSString *PPUndoManagerWillRedoChangeNotification =
@"PPUndoManagerWillRedoChangeNotification";
NSString *PPUndoManagerWillUndoChangeNotification =
@"PPUndoManagerWillUndoChangeNotification";


/*
 *      Private class for grouping undo/redo actions.
 */
@interface      PrivateUndoGroup : NSObject
{
    PrivateUndoGroup    *parent;
    NSMutableArray      *actions;
}
- (NSMutableArray*) actions;
- (void) addInvocation: (NSInvocation*)inv;
- (id) initWithParent: (PrivateUndoGroup*)parent;
- (void) orphan;
- (PrivateUndoGroup*) parent;
- (void) perform;
- (BOOL) removeActionsForTarget: (id)target;
@end

@implementation PrivateUndoGroup

- (NSMutableArray*) actions
{
	return actions;
}

- (void) addInvocation: (NSInvocation*)inv
{
	if (actions == nil)
    {
		actions = [[NSMutableArray alloc] initWithCapacity: 2];
    }
	[actions addObject: inv];
}

- (void) dealloc
{
    //	MLOG(@"<PrivateUndoGroup dealloc>");
	[actions release];
	[parent  release];
	[super dealloc];
    //	MLOG(@"<PrivateUndoGroup dealloc end>");
}

- (id) initWithParent: (PrivateUndoGroup*)p
{
	self = [super init];
	if (self)
    {
		parent = [p retain];
		actions = nil;
    }
	return self;
}

- (void) orphan
{
	id    p = parent;
	
	parent = nil;
	[p release];
}

- (PrivateUndoGroup*) parent
{
	return parent;
}

- (void) perform
{
	if (actions != nil)
    {
		unsigned  i = [actions count];
		
		while (i-- > 0)
        {
			[[actions objectAtIndex: i] invoke];
        }
    }
}

- (BOOL) removeActionsForTarget: (id)target
{
	if (actions != nil)
    {
		unsigned  i = [actions count];
		
		while (i-- > 0)
        {
			NSInvocation  *inv = [actions objectAtIndex: i];
			
			if ([inv target] == target)
            {
				[actions removeObjectAtIndex: i];
            }
        }
		if ([actions count] > 0)
        {
			return YES;
        }
    }
	return NO;
}

@end



/*
 *      Private catagory for the method used to handle default grouping
 */
@interface PPUndoManager (Private)
- (void) _loop: (id)arg;
@end

@implementation PPUndoManager (Private)
- (void) _loop: (id)arg
{
	if (groupsByEvent)
    {
		if (group != nil)
        {
			[self endUndoGrouping];
        }
		[self beginUndoGrouping];
    }
}
@end



/*
 *      The main part for the PPUndoManager implementation.
 */
@implementation PPUndoManager
@synthesize redoStack;
- (void) beginUndoGrouping
{
	PrivateUndoGroup      *parent;
	
	if (isUndoing == NO)
    {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName: PPUndoManagerCheckpointNotification
		 object: self];
    }
	parent = (PrivateUndoGroup*)group;
	group = [[PrivateUndoGroup alloc] initWithParent: parent];
	if (group == nil)
    {
		group = parent;
		[NSException raise: NSInternalInconsistencyException
					format: @"beginUndoGrouping failed to greate group"];
    }
	else
    {
		[parent release];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName: PPUndoManagerDidOpenUndoGroupNotification
		 object: self];
    }
}

- (BOOL) canRedo
{
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerCheckpointNotification
	 object: self];
	if ([redoStack count] > 0)
    {
		return YES;
    }
	else
    {
		return NO;
    }
}

- (BOOL) canUndo
{
	if ([undoStack count] > 0)
    {
		return YES;
    }
	if (group != nil && [[group actions] count] > 0)
    {
		return YES;
    }
	return NO;
}

- (void) dealloc
{
    //	MLOG(@"<PPUndoManager dealloc>");
	[[NSRunLoop currentRunLoop] cancelPerformSelector: @selector(_loop:)
											   target: self
											 argument: nil];
    
	[redoStack release];
	[undoStack release];
	[actionName release];
	[group  release];
	[super dealloc];
    //	MLOG(@"<PPUndoManager dealloc end>");
}

- (void) disableUndoRegistration
{
	disableCount++;
}

- (void) enableUndoRegistration
{
	if (disableCount > 0)
    {
		disableCount--;
		registeredUndo = NO;      /* No operations since registration enabled. */
    }
	else
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"enableUndoRegistration without disable"];
    }
}

- (void) endUndoGrouping
{
	PrivateUndoGroup      *g;
	PrivateUndoGroup      *p;
	
	if (group == nil)
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"endUndoGrouping without beginUndoGrouping"];
    }
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerCheckpointNotification
	 object: self];
	g = (PrivateUndoGroup*)group;
	p =[[g parent] retain];
	group = p;
	[g orphan];//释放当前节点
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerWillCloseUndoGroupNotification
	 object: self];
	if (p == nil)//如果是根节点
    {
		if (isUndoing)
        {
			if (levelsOfUndo > 0 && [redoStack count] == levelsOfUndo)
            {
				[redoStack removeObjectAtIndex: 0];
            }
			[redoStack addObject: g];
        }
		else
        {
			if (levelsOfUndo > 0 && [undoStack count] == levelsOfUndo)
            {
				[undoStack removeObjectAtIndex: 0];
            }
			[undoStack addObject: g];
        }
    }
	else if ([g actions] != nil)
    {
		NSArray   *a = [g actions];
		unsigned  i;
		
		for (i = 0; i < [a count]; i++)
        {
			[p addInvocation: [a objectAtIndex: i]];
        }
    }
	[g release];
}

- (void) forwardInvocation: (NSInvocation*)anInvocation
{
	NSLog(@"forwardInvocation 日");
	if (disableCount == 0)
    {
		if (nextTarget == nil)
        {
			[NSException raise: NSInternalInconsistencyException
						format: @"forwardInvocation without perparation"];
        }
		if (group == nil)
        {
			[NSException raise: NSInternalInconsistencyException
						format: @"forwardInvocation without beginUndoGrouping"];
        }
		[anInvocation setTarget: nextTarget];
		nextTarget = nil;
		[group addInvocation: anInvocation];
		if (isUndoing == NO)
        {
			[redoStack removeAllObjects];
        }
		registeredUndo = YES;
    }
}

- (int) groupingLevel
{
	PrivateUndoGroup      *g = (PrivateUndoGroup*)group;
	int                   level = 0;
	
	while (g != nil)
    {
		level++;
		g = [g parent];
    }
	return level;
}

- (BOOL) groupsByEvent
{
	return groupsByEvent;
}

- (id) init
{
	self = [super init];
	if (self)
    {
		actionName = @"";
		redoStack = [[NSMutableArray alloc] initWithCapacity: 16];
		undoStack = [[NSMutableArray alloc] initWithCapacity: 16];
		[self setRunLoopModes:
		 [NSArray arrayWithObjects: NSDefaultRunLoopMode, nil]];
    }
	return self;
}

- (BOOL) isRedoing
{
	return isRedoing;
}

- (BOOL) isUndoing
{
	return isUndoing;
}

- (BOOL) isUndoRegistrationEnabled
{
	if (disableCount == 0)
    {
		return YES;
    }
	else
    {
		return NO;
    }
}

- (unsigned int) levelsOfUndo
{
	return levelsOfUndo;
}

- (id) prepareWithInvocationTarget: (id)target
{
	nextTarget = target;
	
	return self;
}

- (void) redo
{
	printf(" \n onRedo $$$$ undo stack count = %d \n",[undoStack count]);
	printf(" \n onRedo $$$$ redo stack count = %d \n",[redoStack count]);
	if (isUndoing || isRedoing)
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"redo while undoing or redoing"];
    }
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerCheckpointNotification
	 object: self];
	
	if ([redoStack count] > 0)
    {
		PrivateUndoGroup  *oldGroup;
		PrivateUndoGroup  *groupToRedo;
		
		[[NSNotificationCenter defaultCenter]
		 postNotificationName: PPUndoManagerWillRedoChangeNotification
		 object: self];
		groupToRedo = [redoStack lastObject];//[redoStack objectAtIndex: [redoStack count] - 1];
		
		[groupToRedo retain];
		[redoStack removeLastObject];
		oldGroup = group;
        
		group = nil;
		isRedoing = YES;
        
        
		[self beginUndoGrouping];
		[groupToRedo perform];
		[groupToRedo release];
		[self endUndoGrouping];
		isRedoing = NO;
		group = oldGroup;
        
		[[NSNotificationCenter defaultCenter]
		 postNotificationName: PPUndoManagerDidRedoChangeNotification
		 object: self];
    }
}

- (NSString*) redoActionName
{
	if ([self canRedo] == NO)
    {
		return nil;
    }
	return actionName;
}

- (NSString*) redoMenuItemTitle
{
	return [self redoMenuTitleForUndoActionName: [self redoActionName]];
}

- (NSString*) redoMenuTitleForUndoActionName: (NSString*)name
{
	if (name)
    {
		if ([name isEqual: @""])
        {
			return @"Redo";
        }
		else
        {
			return [NSString stringWithFormat: @"Redo %@", name];
        }
    }
	return name;
}

- (void) registerUndoWithTarget: (id)target
                       selector: (SEL)aSelector
                         object: (id)anObject
{
	if (disableCount == 0)
    {
		NSMethodSignature *sig;
		NSInvocation      *inv;
		PrivateUndoGroup  *g;
		
		if (group == nil)
        {
			[NSException raise: NSInternalInconsistencyException
						format: @"registerUndo without beginUndoGrouping"];
        }
		g = group;
		sig = [target methodSignatureForSelector: aSelector];
		inv = [NSInvocation invocationWithMethodSignature: sig];
		[inv setTarget: target];
		[inv setSelector: aSelector];
		
		if(anObject!=nil)
			[inv setArgument: &anObject atIndex:2];
		[g addInvocation: inv];
        
		registeredUndo = YES;
        
    }
}

- (void) removeAllActions
{
	[redoStack removeAllObjects];
	[undoStack removeAllObjects];
	isRedoing = NO;
	isUndoing = NO;
	disableCount = 0;
}

- (void) removeAllActionsWithTarget: (id)target
{
	unsigned      i;
	
	i = [redoStack count];
	while (i-- > 0)
    {
		PrivateUndoGroup  *g;
		
		g = [redoStack objectAtIndex: i];
		if ([g removeActionsForTarget: target] == NO)
        {
			[redoStack removeObjectAtIndex: i];
        }
    }
	i = [undoStack count];
	while (i-- > 0)
    {
		PrivateUndoGroup  *g;
		
		g = [undoStack objectAtIndex: i];
		if ([g removeActionsForTarget: target] == NO)
        {
			[undoStack removeObjectAtIndex: i];
        }
    }
}

- (NSArray*) runLoopModes
{
	return modes;
}

- (void) setActionName: (NSString*)name
{
	if (name != nil && actionName != name)
    {
		
		actionName = [name copy];
    }
}

- (void) setGroupsByEvent: (BOOL)flag
{
	if (groupsByEvent != flag)
    {
		groupsByEvent = flag;
    }
}

- (void) setLevelsOfUndo: (unsigned)num
{
	levelsOfUndo = num;
	if (num > 0)
    {
		while ([undoStack count] > num)
        {
			[undoStack removeObjectAtIndex: 0];
        }
		while ([redoStack count] > num)
        {
			[redoStack removeObjectAtIndex: 0];
        }
    }
}

- (void) setRunLoopModes: (NSArray*)newModes
{
	if (modes != newModes)
    {
		modes = [NSArray arrayWithArray:newModes];
		[[NSRunLoop currentRunLoop] cancelPerformSelector: @selector(_loop:)
												   target: self
												 argument: nil];
		[[NSRunLoop currentRunLoop] performSelector: @selector(_loop:)
											 target: self
										   argument: nil
											  order: 0
											  modes: modes];
    }
}

- (void) undo
{
	printf("\n onUndo *** undo stack count = %d \n",[undoStack count]);
	printf("\n onUndo *** redo stack count = %d \n",[redoStack count]);
	if ([self groupingLevel] == 1)
    {
		[self endUndoGrouping];
    }
	if (group != nil)
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"undo with nested groups"];
    }
	[self undoNestedGroup];
}

- (NSString*) undoActionName
{
	if ([self canUndo] == NO)
    {
		return nil;
    }
	return actionName;
}

- (NSString*) undoMenuItemTitle
{
	return [self undoMenuTitleForUndoActionName: [self undoActionName]];
}

- (NSString*) undoMenuTitleForUndoActionName: (NSString*)name
{
	if (name)
    {
		if ([name isEqual: @""])
        {
			return @"Undo";
        }
		else
        {
			return [NSString stringWithFormat: @"Undo %@", name];
        }
    }
	return name;
}

- (void) undoNestedGroup
{
	PrivateUndoGroup      *oldGroup;
	PrivateUndoGroup      *groupToUndo;
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerCheckpointNotification
	 object: self];
#if 0
	/*
	 *      The documentation says we should raise an exception - but I can't
	 *      make sense of it - raising an exception seems to break everything.
	 *      It would make more sense to raise an exception if NO undo operations
	 *      had been registered.
	 */
	if (registeredUndo)
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"undoNestedGroup with registered undo ops"];
    }
#endif
	if (isUndoing || isRedoing)
    {
		[NSException raise: NSInternalInconsistencyException
					format: @"undoNestedGroup while undoing or redoing"];
	}
	if (group != nil && [undoStack count] == 0)
    {
		return;
    }
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerWillUndoChangeNotification
	 object: self];
	oldGroup = group;
	group = nil;
	isUndoing = YES;
	if (oldGroup)
    {
		groupToUndo = oldGroup;
		oldGroup = [[oldGroup parent] retain];
		[groupToUndo orphan];
		[redoStack addObject: groupToUndo];
    }
	else
    {
		groupToUndo = [undoStack lastObject];
		
		[groupToUndo retain];
		[undoStack removeLastObject];
	}
	[self beginUndoGrouping];
	[groupToUndo perform];
	[groupToUndo release];
	[self endUndoGrouping];
    
	isUndoing = NO;
	group = oldGroup;
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: PPUndoManagerDidUndoChangeNotification
	 object: self];
}

@end
