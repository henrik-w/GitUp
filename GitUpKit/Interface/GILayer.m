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

#if __has_feature(objc_arc)
#error This file requires MRC
#endif

#import "GIPrivate.h"

@implementation GILayer {
  NSMutableArray<GINode*>* _nodes;
  NSMutableArray<GILine*>* _lines;
}

- (instancetype)initWithIndex:(NSUInteger)index {
  if ((self = [super init])) {
    _index = index;

    _nodes = [[NSMutableArray arrayWithCapacity:0] retain];
    _lines = [[NSMutableArray arrayWithCapacity:0] retain];
  }
  return self;
}

- (void)dealloc {
  if (nil != _lines) {
    [_lines release];
  }
  if (nil != _nodes) {
    [_nodes release];
  }

  [super dealloc];
}

- (NSArray<GINode*>*)nodes {
  return _nodes;
}

- (NSArray<GILine*>*)lines {
  return _lines;
}

- (void)addNode:(GINode*)node {
  [_nodes addObject:node];
}

- (void)addLine:(GILine*)line {
  [_lines addObject:line];
}

- (NSString*)description {
  return [NSString stringWithFormat:@"[%@] Index=%lu Y=%g Nodes=%lu Lines=%lu", self.class, (unsigned long)_index, _y, (unsigned long)self.nodes.count, (unsigned long)self.lines.count];
}

@end
