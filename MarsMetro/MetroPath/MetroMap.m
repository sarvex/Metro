//
//  MetroMap.m
//  MarsMetro
//

#import "MetroMap.h"
#import "MetroRouteStep.h"
@implementation MetroMap
@synthesize stations;
@synthesize closedStationDict;
- (id)init
{
    self = [super init];
    
    if (self) {
        
        stationTracks = [[NSMutableDictionary alloc] init];
        stations = [[NSMutableDictionary alloc] init];
        closedStationDict = [[NSMutableDictionary alloc]init];

    }
    
    return self;
}

- (MetroStation *)stationWithUID:(NSString *)uniqueID {
    
    return [stations objectForKey:uniqueID];
    
}

- (NSInteger)stationTrackCount
{
    NSInteger stationTrackCount = 0;
    
    for (NSString *trackIdentifier in stationTracks) {
        
        stationTrackCount += [(NSDictionary *)[stationTracks objectForKey:trackIdentifier] count];
    }
    
    return stationTrackCount;
}
- (void)addStation:(MetroStation *)station {
    
    [stations setObject:station forKey:station.stationID];
}

- (void)addTrack:(MetroTrack *)trackObject fromStation:(MetroStation *)fromStation toStation:(MetroStation *)toStation{
    
    [stations setObject:fromStation forKey:fromStation.stationID];
    [stations setObject:toStation forKey:toStation.stationID];
    
    // If we don't have any tracks leaving from the station
    // create a new record in the node dictionary, else add it to the existing one
    
    if (![stationTracks objectForKey:fromStation.stationID]) {
        
        [stationTracks setObject:[NSMutableDictionary dictionaryWithObject:trackObject
                                                                    forKey:toStation.stationID]
                          forKey:fromStation.stationID];
        
    } else {
        
        [(NSMutableDictionary *)[stationTracks objectForKey:fromStation.stationID] setObject:trackObject
                                                                                      forKey:toStation.stationID];
    }
}


- (void)createBiDirectionalTrack:(MetroTrack *)trackObject fromStation:(MetroStation *)fromStation toStation:(MetroStation *)toStation {
    
    
    trackObject.trackEndStationID = toStation.stationID;
    trackObject.trackStartStationID = fromStation.stationID;
    [self addTrack:trackObject fromStation:fromStation toStation:toStation];
    
    MetroTrack *oppositeTrack = [[MetroTrack alloc]init];
    oppositeTrack.trackEndStationID = fromStation.stationID;
    oppositeTrack.trackStartStationID = toStation.stationID;
    
    oppositeTrack.lineColor = trackObject.lineColor;
    oppositeTrack.trackName = trackObject.trackName;
    oppositeTrack.weight = trackObject.weight;
    [self addTrack:oppositeTrack fromStation:toStation toStation:fromStation];
}


-(void)calculateLineEndPoints {
    
    for (NSString *key in [stationTracks allKeys]) {
        
        NSDictionary *stationDict = [stationTracks objectForKey:key];
        
        for (NSString *trackKey in [stationDict allKeys]) {
            MetroTrack *trackObject = [stationDict objectForKey:trackKey];
            
            [self setEndpointsOfTrack:trackObject];
            
            
        }
    }
}





-(void)setEndpointsOfTrack:(MetroTrack*)track {
    NSSet *neighbours;
    NSString *endStationID = track.trackEndStationID;
    NSString *endPoint = @"";
    NSString *startStationID = track.trackStartStationID;
    do {
        neighbours = [self neighborSetOfStationWithID:endStationID];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationID!=%@ &&(lineColor==%@ || isSwitch==%@)",startStationID,track.lineColor,[NSNumber numberWithBool:YES]];
        NSSet *filteredSet = [neighbours filteredSetUsingPredicate:predicate];
        
        if(filteredSet.count==1) {
            
            MetroStation *station = [[filteredSet allObjects]objectAtIndex:0];
            startStationID = endStationID;
            endStationID = station.stationID;
        }
        
        else {
            endPoint = endStationID;
            break;
        }
        
    }  while (neighbours.count>1);
    
    track.lineEndPoint = endPoint;
    NSLog(@"END POINT OF %@ is %@",track.trackName,endPoint);
    
}



- (NSNumber *)weightFromStation:(MetroStation *)sourceStation toNeighborStation:(MetroStation *)destinationStation
{
    MetroTrack *track = [self trackFromStation:sourceStation toNeighborStation:destinationStation];
    
    return (track) ? track.weight : nil;
}


- (NSSet *)neighborsOfStation:(MetroStation *)station
{
    NSDictionary *tracksFromStation = [stationTracks objectForKey:station.stationID];
    
    // If we don't have any record of the given node in the collection, determined by its identifier,
    // return nil
    if (tracksFromStation == nil) {
        
        return nil;
        
    } else {
        
        NSMutableSet *neighborStations = [NSMutableSet set];
        
        // Otherwise, iterate over all the keys (identifiers) of nodes receiving edges
        // from the given node, retreive their coresponding node object, add it to the
        // set, and return the completed set
        for (NSString *neighboringIdentifier in tracksFromStation) {
            
            [neighborStations addObject:[stations objectForKey:neighboringIdentifier]];
        }
        
        return neighborStations;
    }
}

- (NSSet *)neighborSetOfStationWithID:(NSString *)stationID
{
    MetroStation *station = [stations objectForKey:stationID];
    
    return (station == nil) ? nil : [self neighborsOfStation:station];
}



- (MetroTrack *)trackFromStation:(MetroStation *)sourceStation toNeighborStation:(MetroStation *)destinationStation
{
    // First check to make sure a node with the identifier of the given source node exists in the graph
    if ( ! [stationTracks objectForKey:sourceStation.stationID]) {
        
        return nil;
        
    } else {
        
        // Next, make sure that there is an edge from the from the given node to the destination node.  If
        // so, return it.  Otherwise, fall back on the returned nil
        return [[stationTracks objectForKey:sourceStation.stationID] objectForKey:destinationStation.stationID];
    }
}

- (MetroRoute *)calculateShortestRouteFromStation:(MetroStation *)startStation toNode:(MetroStation *)endStation {
    
    
    NSMutableDictionary *unexaminedNodes = [NSMutableDictionary dictionaryWithDictionary:self.stations];
    
    // The shortest yet found distance to the origin for each node in the graph.  If we haven't
    // yet found a path back to the origin from a node, or if there isn't one, mark with -1
    // (which is used equivlently to how infinity is used in some Dijkstra implementations)
    NSMutableDictionary *distancesFromSource = [NSMutableDictionary dictionaryWithCapacity:[unexaminedNodes count]];
    
    // A collection that stores the previous node in the quickest path back to the origin for each
    // examined node in the graph (so you can retrace the fastest path from any examined node back
    // looking up the value that coresponds to any node identifier.  That value will be the previous
    // node in the path
    NSMutableDictionary *previousNodeInOptimalPath = [NSMutableDictionary dictionaryWithCapacity:[unexaminedNodes count]];
    
    // Since NSNumber doesn't have a state for infinitiy, but since we know that all weights have to be
    // positive, we can treat -1 as infinity
    NSNumber *infinity = [NSNumber numberWithInt:-1];
    
    // Set every node to be infinitely far from the origin (ie no path back has been found yet).
    for (NSString *nodeIdentifier in unexaminedNodes) {
        
        [distancesFromSource setValue:infinity
                               forKey:nodeIdentifier];
    }
    
    // Set the distance from the source to itself to be zero
    [distancesFromSource setValue:[NSNumber numberWithInt:0]
                           forKey:startStation.stationID];
    
    NSString *currentlyExaminedIdentifier = nil;
    
    [closedStationDict removeAllObjects];
    
    MetroStation *closedStation;
    
    while ([unexaminedNodes count] > 0) {
        
        // Find the node, of all the unexamined nodes, that we know has the closest path back to the origin
        NSString *identifierOfSmallestDist = [self keyOfSmallestValue:distancesFromSource withInKeys:[unexaminedNodes allKeys]];
        
        // If we failed to find any remaining nodes in the graph that are reachable from the source,
        // stop processing
        if (identifierOfSmallestDist == nil) {
            
            break;
            
        } else {
            
            MetroStation *nodeMostRecentlyExamined = [self stationWithUID:identifierOfSmallestDist];
            
            // If the next closest node to the origin is the target node, we don't need to consider any more
            // possibilities, we've already hit the shortest distance!  So, we can remove all other
            // options from consideration.
            if ([identifierOfSmallestDist isEqualToString:endStation.stationID]) {
                
                currentlyExaminedIdentifier = endStation.stationID;
                break;
                
            } else {
                
                // Otherwise, remove the node thats the closest to the source and continue the search by looking
                // for the next closest item to the orgin.
                [unexaminedNodes removeObjectForKey:identifierOfSmallestDist];
                
                // Now, iterate over all the nodes that touch the one closest to the graph
                for (MetroStation *neighbouringStation in [self neighborSetOfStationWithID:identifierOfSmallestDist]) {
                    
                    // Calculate the distance to the origin, from the neighboring node, through the most recently
                    // examined node.  If its less than the shortest path we've found from the neighboring node
                    // to the origin so far, save / store the new shortest path amount for the node, and set
                    // the currently being examined node to be the optimal path home
                    // The distance of going from the neighbor node to the origin, going through the node we're about to eliminate
                    NSNumber *alt = [NSNumber numberWithFloat:
                                     [[distancesFromSource objectForKey:identifierOfSmallestDist] floatValue] +
                                     [[self weightFromStation:nodeMostRecentlyExamined toNeighborStation:neighbouringStation] floatValue]];
                    
                    NSNumber *distanceFromNeighborToOrigin = [distancesFromSource objectForKey:neighbouringStation.stationID];
                    
                    if(neighbouringStation.isStationClosed){
                        closedStation = neighbouringStation;
                        [closedStationDict setObject:neighbouringStation forKey:neighbouringStation.stationID];
                    }
                    
                    // If its quicker to get to the neighboring node going through the node we're about the remove
                    // than through any other path, record that the node we're about to remove is the current fastes
                    if (([distanceFromNeighborToOrigin isEqualToNumber:infinity] || [alt compare:distanceFromNeighborToOrigin] == NSOrderedAscending) &&!neighbouringStation.isStationClosed ) {
                        
                        [distancesFromSource setValue:alt forKey:neighbouringStation.stationID];
                        [previousNodeInOptimalPath setValue:nodeMostRecentlyExamined forKey:neighbouringStation.stationID];
                    }
                }
            }
        }
    }
    
    // There are two situations that cause the above loop to exit,
    // 1. We've found a path between the origin and the destination node, or
    // 2. there are no more possible routes to consider to the destination, in which case no possible
    // solution / route exists.
    //
    // If the key of the destination node is equal to the node we most recently found to be in the shortest path
    // between the origin and the destination, we're in situation 2.  Otherwise, we're in situation 1 and we
    // should just return nil and be done with it
    if ( currentlyExaminedIdentifier == nil || ! [currentlyExaminedIdentifier isEqualToString:endStation.stationID]) {
        MetroRoute *route = [[MetroRoute alloc] init];
        
            
        MetroRouteStep *step = [[MetroRouteStep alloc] initWithStation:closedStation andTrack:nil asBeginning:NO];

        [route.routeList addObject:step];
        route.isRouteClosed = YES;
        return route;
        }
        
     else {
        
        // If we did successfully find a path, create and populate a route object, describing each step
        // of the path.
        MetroRoute *route = [[MetroRoute alloc] init];
        
        // We do this by first building the route backwards, so the below array with have the last step
        // in the route (the destination) in the 0th position, and the origin in the last position
        NSMutableArray *nodesInRouteInReverseOrder = [NSMutableArray array];
        
        [nodesInRouteInReverseOrder addObject:endStation];
        
        MetroStation *lastStepNode = endStation;
        MetroStation *previousNode;
        
        while ((previousNode = [previousNodeInOptimalPath objectForKey:lastStepNode.stationID])) {
            
            [nodesInRouteInReverseOrder addObject:previousNode];
            lastStepNode = previousNode;
        }
        
        // Now, finally, at this point, we can reverse the array and build the complete route object, by stepping through
        // the nodes and piecing them togheter with their routes
        NSUInteger numNodesInPath = [nodesInRouteInReverseOrder count];
        for (int i = (int)numNodesInPath - 1; i >= 0; i--) {
            
            MetroStation *currentGraphNode = [nodesInRouteInReverseOrder objectAtIndex:i];
            MetroStation *nextGraphNode = (i - 1 < 0) ? nil : [nodesInRouteInReverseOrder objectAtIndex:(i - 1)];
            [route addStepFromStation:currentGraphNode withTrack:[self trackFromStation:currentGraphNode toNeighborStation:nextGraphNode]];
        }
        
        return route;
    }
}

- (id)keyOfSmallestValue:(NSDictionary *)aDictionary withInKeys:(NSArray *)anArray
{
    id keyForSmallestValue = nil;
    NSNumber *smallestValue = nil;
    
    NSNumber *infinity = [NSNumber numberWithInt:-1];
    
    for (id key in anArray) {
        
        // Check to see if we have or proxie for infinity here.  If so, ignore this value
        NSNumber *currentTestValue = [aDictionary objectForKey:key];
        
        if ( ! [currentTestValue isEqualToNumber:infinity]) {
            
            if (smallestValue == nil || [smallestValue compare:currentTestValue] == NSOrderedDescending) {
                
                keyForSmallestValue = key;
                smallestValue = currentTestValue;
            }
        }
    }
    
    return keyForSmallestValue;
}




@end
