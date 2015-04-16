//
//  MMViewControllerTests.m
//  MarsMetro
//

#import <XCTest/XCTest.h>
#import "MMViewController.h"
@interface MMViewControllerTests : XCTestCase

@end

@implementation MMViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStoryboardShouldBeInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XCTAssertNotNil(storyboard, @"Storyboard should not be nil");
}

- (void)testViewControllerShouldBeInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XCTAssertNotNil(storyboard, @"Storyboard should not be nil");
    MMViewController *viewController = [storyboard instantiateInitialViewController];
    XCTAssertNotNil(viewController, @"View Controller should not be nil");


}

- (void)testStartButtonIsInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  MMViewController *viewController = [storyboard instantiateInitialViewController];
    [viewController view];
    XCTAssertNotNil(viewController.selectStartButton, @"Start Button should not be nil");

}

- (void)testEndButtonIsInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MMViewController *viewController = [storyboard instantiateInitialViewController];
    [viewController view];
    XCTAssertNotNil(viewController.selectEndButton, @"End Button should not be nil");
    
}

- (void)testTextFieldsAreInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MMViewController *viewController = [storyboard instantiateInitialViewController];
    [viewController view];
    XCTAssertNotNil(viewController.startTextField, @"startTextField should not be nil");
    XCTAssertNotNil(viewController.endTextField, @"endTextField should not be nil");

}



@end
