//
//  MetroMap.h
//  MarsMetro
//

#import <Foundation/Foundation.h>
#import "MetroStation.h"
#import "MetroTrack.h"
#import "MetroRoute.h"
/**
 Class that represents the station points and the tracks(edges) between them. Uses the Djikstra's shortest path algorithm to calculate the shortest points.
 */
@interface MetroMap : NSObject {

    /**
     Dictionary responsible for keeping the list of the stations. Key of the dictionary will be the station unique name identifier.
     */

   // @private
      NSMutableDictionary *stations;
    /**
     Dictionary responsible for keeping the list of the tracks connecting all the stations. Key of the dictionary will be the track unique name identifier.
     */

      NSMutableDictionary *stationTracks;
}
@property (nonatomic, strong) NSMutableDictionary *stations;


/**
 Maintain the list of closed stations for the route which is to be calculated
 */
@property(nonatomic,strong)NSMutableDictionary *closedStationDict;
/**
 Return the count of all the tracks in the map. Note that as all the tracks are bi-directional, the count of each track/edge will be taken 2 times.
 */
- (NSInteger)stationTrackCount;


/**
 Returns a station in the map as per the unique identifier, or nil.
 @param uniqueID a string identifier of th station
 @returns either nil or the actual station object of MetroStation class
 */
- (MetroStation *)stationWithUID:(NSString *)uniqueID;


/**
 Adds a MetroTrack Station object in the stations list of the map
  @param station the station which needs to be added to the map
 */

- (void)addStation:(MetroStation *)station;



/**
Returns an track object from the given station to the destination station.  
 @param source the node to check the weight from
@param destination the node to check the weight to
@returns either nil, or the required track object 
*/
- (MetroTrack *)trackFromStation:(MetroStation *)source toNeighborStation:(MetroStation *)destination;



/**
 Creates a one-directional, weighted track between two station points in the map.  
 @param trackObject the track describing the connection between the two stations
 @param fromStation the station from where the track starts
 @param anotherNode the station from where the track ends
 */

- (void)addTrack:(MetroTrack *)trackObject fromStation:(MetroStation *)fromStation toStation:(MetroStation *)toStation;


/**
 Creates a weighted tracks that travels in both directions from the two given nodes in the graph.  If any
 provided stations are not in the map they're added to the list
 @param trackObject the track describing the connection between the two stations
 @param fromStation one of the two stations on one side of the track
 @param toStation the other of the two stations on the other side of the track

 */
- (void)createBiDirectionalTrack:(MetroTrack *)trackObject fromStation:(MetroStation *)fromStation toStation:(MetroStation *)toStation;

/**
 Method to calculate the neighbouring stations for a specified station
 */
- (NSSet *)neighborsOfStation:(MetroStation *)station;

/** 
 Method which is responsible for calculating the end point of each line with respect to the color. Needs to be called explicitly when all the stations and tracks have been added to the map.
 */
-(void)calculateLineEndPoints;

/**
 Method to calculate the endpoint of the specified track. The endpoint refers to the station where the line ends with respect to the color. 
 */
-(void)setEndpointsOfTrack:(MetroTrack*)track;

/**
 Returns the weight from one station to another station.  If any station is not
 found or there is no track, nil is returned
 nil is retuned.  
 @param sourceStation the start station point
 @param destinationStation the ending station point
 @returns either nil, or a number object describing the weight
 */
- (NSNumber *)weightFromStation:(MetroStation *)sourceStation toNeighborStation:(MetroStation *)destinationStation;

/**
 Returns a metro route object that has information about the quickest path between the two given station points.  
 @param startStation a node in the graph to begin calculating a path from
 @param endStation a node in graph to calculate a route to
 @returns it can be either a MetroRoute object or nil, if no route is possible
 */
- (MetroRoute *)calculateShortestRouteFromStation:(MetroStation *)startStation toNode:(MetroStation *)endStation;


@end
