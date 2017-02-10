//
//  PPUndoManager.h
//  NoteBook
//
//  Created by chen wu on 09-08-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef __PPUndoManager_h_OBJECTS_INCLUDE
#define __PPUndoManager_h_OBJECTS_INCLUDE

#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>

@class NSArray;
@class NSMutableArray;
@class NSInvocation;

/* Public notification */
extern NSString *PPUndoManagerCheckpointNotification;
extern NSString *PPUndoManagerDidOpenUndoGroupNotification;
extern NSString *PPUndoManagerDidRedoChangeNotification;
extern NSString *PPUndoManagerDidUndoChangeNotification;
extern NSString *PPUndoManagerWillCloseUndoGroupNotification;
extern NSString *PPUndoManagerWillRedoChangeNotification;
extern NSString *PPUndoManagerWillUndoChangeNotification;

@interface PPUndoManager: NSObject
{
@private
    NSMutableArray      *redoStack;
    NSMutableArray      *undoStack;
    NSString            *actionName;
    id                  group;
    id                  nextTarget;
    NSArray             *modes;
    BOOL                isRedoing;
    BOOL                isUndoing;
    BOOL                groupsByEvent;
    BOOL                registeredUndo;
	
    unsigned            disableCount;
    unsigned            levelsOfUndo;
}

- (void) beginUndoGrouping;
- (BOOL) canRedo;
- (BOOL) canUndo;
- (void) disableUndoRegistration;
- (void) enableUndoRegistration;
- (void) endUndoGrouping;
- (void) forwardInvocation: (NSInvocation*)anInvocation;
- (int) groupingLevel;
- (BOOL) groupsByEvent;
- (BOOL) isRedoing;
- (BOOL) isUndoing;
- (BOOL) isUndoRegistrationEnabled;
- (unsigned int) levelsOfUndo;
- (id) prepareWithInvocationTarget: (id)target;
- (void) redo;
- (NSString*) redoActionName;
- (NSString*) redoMenuItemTitle;
- (NSString*) redoMenuTitleForUndoActionName: (NSString*)actionName;
- (void) registerUndoWithTarget: (id)target
                       selector: (SEL)aSelector
                         object: (id)anObject;
- (void) removeAllActions;
- (void) removeAllActionsWithTarget: (id)target;
- (NSArray*) runLoopModes;
- (void) setActionName: (NSString*)actionName;
- (void) setGroupsByEvent: (BOOL)flag;
- (void) setLevelsOfUndo: (unsigned)num;
- (void) setRunLoopModes: (NSArray*)modes;
- (void) undo;
- (NSString*) undoActionName;
- (NSString*) undoMenuItemTitle;
- (NSString*) undoMenuTitleForUndoActionName: (NSString*)name;
- (void) undoNestedGroup;
@property(nonatomic,retain) NSMutableArray      *redoStack;
@end

#endif /* __PPUndoManager_h_OBJECTS_INCLUDE */