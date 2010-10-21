//
//  ObjCHiredis_03_List_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-20.
//  Copyright 2010 Modul. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>

#ifdef IOS
#import "ObjCHiredis.h"
#endif

#ifndef IOS
#import "ObjCHiredis/ObjCHiredis.h"
#endif

@interface ObjCHiredis_03_List_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_03_List_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
	[redis command:@"RPUSH BASKET PRUNE"];
	[redis command:@"RPUSH BASKET TOMATO"];
	[redis command:@"RPUSH BASKET ZUCHINI"];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_RPUSH {
	id retVal = [redis command:@"RPUSH BASKET APPLE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"RPUSH returned class is not NSNumber, got %d", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:4]], @"RPUSH return value is wrong, got %d", [retVal integerValue]);
}

- (void)test_02_LPUSH {
	id retVal = [redis command:@"LPUSH BASKET APPLE"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"LPUSH returned class is not NSNumber, got %d", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:4]], @"LPUSH return value is wrong, got %d", [retVal integerValue]);
}

- (void)test_03_LLEN {
	STAssertTrue([[redis command:@"LLEN BASKET"] isKindOfClass:[NSNumber class]], @"LLEN didn't return an NSNumber, got: %@", [[redis command:@"LLEN BASKET"] class]);
	STAssertTrue([[redis command:@"LLEN BASKET"] isEqualToNumber:[NSNumber numberWithInt:3]], @"LLEN returned wrong count, should be 3, got: %d", [[redis command:@"LLEN BASKET"] integerValue]);
}

- (void)test_04_LRANGE {
	STAssertTrue([[redis command:@"LRANGE BASKET 0 2"] isKindOfClass:[NSArray class]], @"LRANGE didn't return an Array, got %@", [[redis command:@"LRANGE BASKET 0 2"] class]);
	STAssertTrue([[redis command:@"LRANGE BASKET 0 2"] count] == 3 , @"LRANGE returned bad length, should be 3, got %d", [[redis command:@"LRANGE BASKET 0 2"] count]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:0] isEqualToString:@"PRUNE"], @"LRANGE returned wrong objects, should be PRUNE, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:0]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:1] isEqualToString:@"TOMATO"], @"LRANGE returned wrong objects, should be TOMATO, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:1]);
	STAssertTrue([[[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:2] isEqualToString:@"ZUCHINI"], @"LRANGE returned wrong objects, should be ZUCHINI, got: %@", [[redis command:@"LRANGE BASKET 0 2"] objectAtIndex:2]);
}

- (void)test_05_LTRIM {
	STAssertTrue([[redis command:@"LTRIM BASKET 0 1"] isKindOfClass:[NSString class]], @"LTRIM didn't return NSString status code, got: %@", [[redis command:@"LTRIM BASKET 0 1"] class]);
	STAssertTrue([[redis command:@"LTRIM BASKET 1 2"] isEqualToString:@"OK"], @"LTRIM didn't return proper status code value, got: %@", [redis command:@"LTRIM BASKET 0 1"]);
	STAssertTrue([[redis command:@"LLEN BASKET"] isEqualToNumber:[NSNumber numberWithInt:1]], @"LTRIM didn't trim right number of members, sould be left with 1, got: %d", [[redis command:@"LLEN BASKET"] integerValue]); 
}

- (void)test_06_LINDEX {
	STAssertTrue([[redis command:@"LINDEX BASKET 0"] isKindOfClass:[NSString class]], @"LINDEX didn't return an NSString, got: %@", [[redis command:@"LINDEX BASKET 0"] class]);
	STAssertTrue([[redis command:@"LINDEX BASKET 0"] isEqualToString:@"PRUNE"], @"LINDEX didn't return right member, should be PRUNE, got: %@", [redis command:@"LINDEX BASKET 0"]); 
	STAssertTrue([[redis command:@"LINDEX BASKET 1"] isEqualToString:@"TOMATO"], @"LINDEX didn't return right member, should be TOMATO, got: %@", [redis command:@"LINDEX BASKET 0"]); 
	STAssertTrue([[redis command:@"LINDEX BASKET 2"] isEqualToString:@"ZUCHINI"], @"LINDEX didn't return right member, should be ZUCHINI, got: %@", [redis command:@"LINDEX BASKET 0"]); 
}

- (void)test_07_LSET {
	STAssertTrue([[redis command:@"LSET BASKET 3 GRAPES"] isKindOfClass:[NSString class]], @"LSET didn't return an NSString, got: %@", [[redis command:@"LSET BASKET 3 GRAPES"] class]);
	STAssertTrue([[redis command:@"LSET BASKET 2 CHERRY"] isEqualToString:@"OK"], @"LSET didn't respond properly, should have returned OK, got: %@", [redis command:@"LSET BASKET 2 CHERRY"]);
	STAssertTrue([[redis command:@"LLEN BASKET"] isEqualToNumber:[NSNumber numberWithInt:3]], @"LSET didn't set properly, list has wrong length, should be 3, got %d", [[redis command:@"LLEN BASKET"] integerValue]);
	STAssertTrue([[redis command:@"LINDEX BASKET 2"] isEqualToString:@"CHERRY"], @"LSET failed, member 2 should now be CHERRY, got: %@", [redis command:@"LINDEX BASKET 2"]);
}

- (void)test_09_RPOP {
	[redis command:@"RPUSH BASKET BANANA"];
	STAssertTrue([[redis command:@"RPOP BASKET"] isEqualToString:@"BANANA"], @"Couldn't RPOP, got %@", [redis command:@"RPOP BASKET"]);

}

@end
