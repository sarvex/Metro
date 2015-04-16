//
//  MarsMetroTests.m
//  MarsMetroTests
//

#import <XCTest/XCTest.h>
#import "MetroMap.h"
#import "MetroRoute.h"
#import  "MetroStation.h"
#import "MetroTrack.h"
@interface MarsMetroTests : XCTestCase

@end

@implementation MarsMetroTests

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

// Basic test to make sure we can keep track of all nodes in the graph
- (void)testingStations
{
    MetroMap *map = [[MetroMap alloc] init];
    
    // Create four basic nodes, connect them, add them to the graph,
    // and make sure the graph contains them all.
    
    MetroStation *aStation = [MetroStation stationWithIdentifier:@"A" color:@"red"];
    MetroStation *bStation = [MetroStation stationWithIdentifier:@"B" color:@"red"];
    MetroStation *cStation = [MetroStation stationWithIdentifier:@"C" color:@"red"];
    MetroStation *dStation= [MetroStation stationWithIdentifier:@"D" color:@"red"];
    [map addTrack:[MetroTrack trackWithName:@"A-B" andWeight:[NSNumber numberWithInt:5]] fromStation:aStation toStation:bStation];
    [map addTrack:[MetroTrack trackWithName:@"B-C" andWeight:[NSNumber numberWithInt:5]] fromStation:bStation toStation:cStation];
    [map addTrack:[MetroTrack trackWithName:@"C-D" andWeight:[NSNumber numberWithInt:5]] fromStation:cStation toStation:dStation];
    [map addTrack:[MetroTrack trackWithName:@"A-C" andWeight:[NSNumber numberWithInt:5]] fromStation:cStation toStation:dStation];
    
    XCTAssertEqual([NSNumber numberWithInt:4], [NSNumber numberWithInt:(int)map.stations.count], @"Bad Amount, map should have 4 stations, not %lu", (unsigned long)map.stations.count);
    
}


- (void)testTrackDirection
{
    MetroMap *map = [[MetroMap alloc] init];
    
    MetroStation *aStation = [MetroStation stationWithIdentifier:@"A" color:@"red"];
    MetroStation *bStation = [MetroStation stationWithIdentifier:@"B" color:@"red"];
    MetroStation *cStation = [MetroStation stationWithIdentifier:@"C" color:@"red"];
    MetroStation *dStation= [MetroStation stationWithIdentifier:@"D" color:@"red"];
    MetroStation *eStation= [MetroStation stationWithIdentifier:@"E" color:@"red"];
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"A-B" andWeight:[NSNumber numberWithInt:5]] fromStation:aStation toStation:bStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"B-C" andWeight:[NSNumber numberWithInt:5]] fromStation:bStation toStation:cStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"C-D" andWeight:[NSNumber numberWithInt:2]] fromStation:cStation toStation:dStation];

    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"A-C" andWeight:[NSNumber numberWithInt:1]] fromStation:aStation toStation:cStation];

    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"D-E" andWeight:[NSNumber numberWithInt:5]] fromStation:dStation toStation:eStation];

    
    XCTAssertEqual([NSNumber numberWithInt:2], [map weightFromStation:cStation toNeighborStation:dStation], @"Wrong weight from c -> d, should be 2, not %@", [map weightFromStation:cStation toNeighborStation:dStation]);
    
    XCTAssertEqual([NSNumber numberWithInt:1], [map weightFromStation:aStation toNeighborStation:cStation], @"Wrong weight from a -> c, should be 1, not %@", [map weightFromStation:aStation toNeighborStation:cStation]);
    
    
    //  make sure they're showing weight in both directions
    XCTAssertEqual([map weightFromStation:dStation toNeighborStation:cStation], [map weightFromStation:dStation toNeighborStation:cStation], @"Invald weight from d -> c, should be 2, not %@", [map weightFromStation:cStation toNeighborStation:dStation]);
    
    XCTAssertNil([map weightFromStation:aStation toNeighborStation:eStation], @"Invald weight from a -> e, should be %@, not %@", nil, [map weightFromStation:aStation toNeighborStation:eStation]);
    
}

-(void)testNeighbourStations {
    MetroMap *map = [[MetroMap alloc] init];
    
    MetroStation *aStation = [MetroStation stationWithIdentifier:@"A" color:@"red"];
    MetroStation *bStation = [MetroStation stationWithIdentifier:@"B" color:@"red"];
    MetroStation *cStation = [MetroStation stationWithIdentifier:@"C" color:@"red"];
    MetroStation *dStation= [MetroStation stationWithIdentifier:@"D" color:@"red"];
    MetroStation *eStation= [MetroStation stationWithIdentifier:@"E" color:@"red"];
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"A-B" andWeight:[NSNumber numberWithInt:5]] fromStation:aStation toStation:bStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"B-C" andWeight:[NSNumber numberWithInt:5]] fromStation:bStation toStation:cStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"C-D" andWeight:[NSNumber numberWithInt:2]] fromStation:cStation toStation:dStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"A-C" andWeight:[NSNumber numberWithInt:1]] fromStation:aStation toStation:cStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"D-E" andWeight:[NSNumber numberWithInt:5]] fromStation:dStation toStation:eStation];

    NSSet *neighbors = [map neighborsOfStation:aStation];

    XCTAssertFalse([neighbors containsObject:eStation], @"Incorrect Neighbors.  E should not be a neighbour of A");

    XCTAssertTrue([neighbors containsObject:bStation], @"Incorrect Neighbors.  B should be a neighbour of A");

}
-(void)testTrackColorEndPoints {
    MetroMap *map = [[MetroMap alloc] init];

    MetroStation *aStation = [MetroStation stationWithIdentifier:@"A" color:@"green"];
    MetroStation *bStation = [MetroStation stationWithIdentifier:@"B" color:@"green"];
    MetroStation *cStation = [MetroStation stationWithIdentifier:@"C" color:@"red"];
    MetroStation *dStation= [MetroStation stationWithIdentifier:@"D" color:@"red"];
    MetroStation *eStation= [MetroStation stationWithIdentifier:@"E" color:@"red"];
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"A-B" andWeight:[NSNumber numberWithInt:5] lineColor:@"green"] fromStation:aStation toStation:bStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"B-C" andWeight:[NSNumber numberWithInt:5] lineColor:@"green"] fromStation:bStation toStation:cStation];
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"C-D" andWeight:[NSNumber numberWithInt:2] lineColor:@"red"] fromStation:cStation toStation:dStation];
    
    
    [map createBiDirectionalTrack:[MetroTrack trackWithName:@"D-E" andWeight:[NSNumber numberWithInt:5] lineColor:@"red"] fromStation:dStation toStation:eStation];
    
    [map setEndpointsOfTrack:[map trackFromStation:cStation toNeighborStation:dStation]];
    
    [map setEndpointsOfTrack:[map trackFromStation:cStation toNeighborStation:bStation]];

    XCTAssertEqual(@"E", [map trackFromStation:cStation toNeighborStation:dStation].lineEndPoint, @"Incorrect endpoint from C -> D, should be E, not %@", [map trackFromStation:cStation toNeighborStation:dStation].lineEndPoint);
    
    XCTAssertEqual(@"A", [map trackFromStation:cStation toNeighborStation:bStation].lineEndPoint, @"Incorrect endpoint from C -> B, should be A, not %@", [map trackFromStation:cStation toNeighborStation:bStation].lineEndPoint);


    
}
-(void)testMapLayout {

    MetroPathEngine *engine =[[MetroPathEngine alloc]init];
    [engine createMetroMapLayout];
    
    XCTAssertEqual(38, [[[engine map] stations]count], @"Wrong station count 38, not %lu", (unsigned long)[[[engine map] stations]count]);

    //test line color of a station
    XCTAssertTrue([[engine.map stationWithUID:@"North Park"].lineColor isEqualToString:@"green"], @"Incorrect color of North Park should be green");
    
    XCTAssertTrue([[engine.map stationWithUID:@"Batman Street"].lineColor isEqualToString:@"black"], @"Incorrect color of Batman Street should be black");
    
    //test line color of a track
    XCTAssertTrue([[engine.map trackFromStation:[engine.map stationWithUID:@"Batman Street"] toNeighborStation:[engine.map stationWithUID:@"Joker Street"]].lineColor isEqualToString:@"black"], @"Incorrect color of track should be black");
    
    
//Assert nil for stations which are not connected
    XCTAssertNil([engine.map trackFromStation:[engine.map stationWithUID:@"Batman Street"] toNeighborStation:[engine.map stationWithUID:@"North Park"]], @"Track should be %@ not %@", nil, [engine.map trackFromStation:[engine.map stationWithUID:@"Batman Street"] toNeighborStation:[engine.map stationWithUID:@"North Park"]]);

    
    
    
}

-(void)testClosedStations {
    MetroPathEngine *engine =[[MetroPathEngine alloc]init];
    [engine createMetroMapLayout];
    
    for (NSString *stationName in engine.map.stations) {
        
        MetroStation *station = [engine.map.stations objectForKey:stationName];
        
        NSLog(@"station name: %@",station.stationID);
        NSLog(@"station closed: %d",station.isStationClosed);
        NSLog(@"station closed reason: %@",station.closedReason);

        
    }
    
}

-(void)testShortestRoute {
    MetroPathEngine *engine =[[MetroPathEngine alloc]init];
    [engine createMetroMapLayout];
    
    MetroRoute *routeA=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Greenland"]];
    NSLog(@"%@",[routeA getFullDescription]);

    //test route step count which does not involve switching a line
    XCTAssertEqual(3, [routeA count], @"Wrong route length %lu should be 3", [routeA count]);

    //test a route step count which involves switching one colored line
    MetroRoute *routeB=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Foot Stand"]];
    XCTAssertEqual(6, [routeB count], @"Wrong route length %lu should be 6", [routeB count]);
    
    //test a route step count which involves switching two colored lines
    MetroRoute *routeC=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Matrix Stand"]];
    XCTAssertEqual(12, [routeC count], @"Wrong route length %lu should be 12", [routeC count]);
    
    MetroRoute *routeD=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Neo Lane"]];
    XCTAssertEqual(12, [routeD count], @"Wrong route length %lu should be 12", [routeD count]);
    
    
    //make sure that the length of the route is 1 when the start and end station are the same
    MetroRoute *routeE=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"North Park"]];
    XCTAssertEqual(1, [routeE count], @"Wrong route length %lu should be 1", [routeE count]);

}

-(void)testFullDescription{
    MetroPathEngine *engine =[[MetroPathEngine alloc]init];
    [engine createMetroMapLayout];
    
    MetroRoute *routeA=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Greenland"]];
    NSLog(@"%@",[routeA getFullDescription]);

    XCTAssertTrue([@"Take green line at North Park going through Sheldon Street to reach Greenland" isEqualToString:[routeA getFullDescription]], @"wrong description");
    
    
  //  MetroRoute *routeB=[engine.map calculateShortestRouteFromStation:[engine.map stationWithUID:@"North Park"] toNode:[engine.map stationWithUID:@"Foot Stand"]];
    
   

}
@end
