//
//  XMLTestDemoTests.m
//  XMLTestDemoTests
//
//  Created by Kaustubh on 22/06/15.
//  Copyright (c) 2015 Kaustubh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GeneralParser.h"
#import "ParserHelperProtocol.h"

@interface XMLTestDemoTests : XCTestCase

@property (nonatomic) NSData *dataToParse;
@property (nonatomic) NSString *invalidXmlFile;
@property (nonatomic) NSString *validXmlFile;

@end

@implementation XMLTestDemoTests

- (void)setUp {
    [super setUp];
    _invalidXmlFile=[[NSBundle mainBundle] pathForResource:@"inValidXml" ofType:@"xml"];
    _validXmlFile=[[NSBundle mainBundle] pathForResource:@"validXml" ofType:@"xml"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidXml {
    XCTestExpectation *expectation= [self expectationWithDescription:@"XML Parser"];
    _dataToParse=[NSData dataWithContentsOfFile:_validXmlFile];
    id<ParserHelperProtocol>xmlParser=[GeneralParser getParserOfType:ParserTypeXML];
    [xmlParser parseData:_dataToParse completionBlock:^(id dictionary, NSError *error)
    {
        if (error!=nil)
        {
            XCTFail(@"Error in parsing a valid XML file");
        }
        else if ([xmlParser.returnDictionary isKindOfClass:[NSDictionary class]] || [xmlParser.returnDictionary isKindOfClass:[NSArray class]])
        {
            //NSLog(@"%@", [[[xmlParser.returnDictionary objectForKey:@"catalog"] objectForKey:@"product"] objectForKey:@"catalog_item"]);
            XCTAssert(YES, @"Passed");
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0f handler:^(NSError *error)
    {
        if (error) {
            NSLog(@"Timeout Occured: %@", error);
        }
    }];
    
    
}

-(void)testInvalidXml
{
    XCTestExpectation *expectation= [self expectationWithDescription:@"XML Parser"];
    _dataToParse=[NSData dataWithContentsOfFile:_invalidXmlFile];
    id<ParserHelperProtocol>xmlParser=[GeneralParser getParserOfType:ParserTypeXML];
    
    [xmlParser parseData:_dataToParse completionBlock:^(id dictionary, NSError *error)
     {
         if(error)
         {
             XCTAssert(YES, @"Pass");
         }
         else
         {
             XCTFail(@"An invalid XML is getting parsed successfully");
         }
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:2.0f handler:^(NSError *error)
     {
         if (error) {
             NSLog(@"Timeout Occured: %@", error);
         }
     }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here
        id<ParserHelperProtocol>xmlParser=[GeneralParser getParserOfType:ParserTypeXML];
        [xmlParser parseData:_dataToParse completionBlock:^(id dictionary, NSError *error)
         {
             
         }];
        
    }];
}

@end
