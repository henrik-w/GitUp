//  Copyright (C) 2015-2018 Pierre-Olivier Latour <info@pol-online.net>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

#import "GCPrivate.h"

@implementation GCOrderedSet {
  NSMutableArray<GCObject*>* _objects;  // Contains all the objects, even removed ones
  NSMutableSet<NSString*>* _actualObjectHashes;  // Objects that were added but have not been removed
  NSMutableSet<NSString*>* _removedObjectHashes;
}

- (instancetype)init {
  if (nil != (self = [super init])) {
    _objects = [NSMutableArray array];
    _actualObjectHashes = [NSMutableSet set];
    _removedObjectHashes = [NSMutableSet set];
  }
  return self;
}

- (void)addObject:(GCObject*)object {
  if (![self containsObject:object]) {
    if ([_removedObjectHashes containsObject:object.SHA1]) {
      [_removedObjectHashes removeObject:object.SHA1];
    } else {
      [_objects addObject:object];
    }
    [_actualObjectHashes addObject:object.SHA1];
  }
}

- (void)removeObject:(GCObject*)object {
  if ([self containsObject:object]) {
    // Removing object from NSMutableArray is expensive,
    // so we just moving SHA from one set to another.
    [_actualObjectHashes removeObject:object.SHA1];
    [_removedObjectHashes addObject:object.SHA1];
  }
}

- (BOOL)containsObject:(GCObject*)object {
  return [_actualObjectHashes containsObject:object.SHA1];
}

- (NSArray<GCObject*>*)objects {
  NSMutableArray<GCObject*>* result = [NSMutableArray arrayWithCapacity:_objects.count];
  for (GCObject* object in _objects) {
    if ([self containsObject:object]) {  // Return only objects that were not removed
      [result addObject:object];
    }
  }
  return result;
}

@end
