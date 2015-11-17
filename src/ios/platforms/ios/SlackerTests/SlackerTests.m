//
//  SlackerTests.m
//  SlackerTests
//
//  Created by Manoj Shenoy on 11/14/15.
//
//

#import <XCTest/XCTest.h>
#import "immCommonFunctions.h"


@interface SlackerTests : XCTestCase

@end

@implementation SlackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testgetClientID {
    
    XCTAssertNotNil([immCommonFunctions getClientID], @"Client ID is present");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
