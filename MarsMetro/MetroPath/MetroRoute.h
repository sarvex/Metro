//
//  MetroRoute.h
//  MarsMetro
//

#import <Foundation/Foundation.h>
/**
Class contains information about the route constructed between two stations. Note that the contents of this class are readonly.
 */
@class MetroStation,MetroTrack;
@interface MetroRoute : NSObject
{
    /**
     A collection of Route Step objects that describe a route
     between two stations. The first element in the array will be the starting point and the last element will be the destination station object.
     */
    NSMutableArray *routeList;
    
    
    
}

@property(nonatomic,assign) BOOL isRouteClosed;

@property (nonatomic, strong) NSMutableArray *routeList;
/** 
 Getter for calculating the fare cost of the ride from the starting station to the end station.
 */
@property(nonatomic,readonly) NSNumber *fareCost;

/**
 Returns the starting station object.
 @returns the station that the route starts from
 or returns nil if there is no starting station
 */
- (MetroStation *)startStation;

/**
 Returns the end station of the route
 @returns the node that the route starts from
 */
- (MetroStation *)endStation;

/**
 The total distance of the route, calculated by adding the weight between all the steps
 @returns a decimal description of the lenght of the entire route
 */
- (float)length;

/**
 Method add a new step to the route from a station.
 @param station a station along a route from starting and ending points.
 @param track the track from one station to another station, can be nil
 */
- (void)addStepFromStation:(MetroStation *)station withTrack:(MetroTrack*)track;

/**
 Method which returns the number of steps needed to finish the route.
 @returns a count of the number of steps described by the route
 */
- (NSUInteger)count;

/**
 Method which returns the full description of the route in a user readable text format.
 @returns a description of the number of steps in a user readable format

 */
- (NSString *)getFullDescription;



@end
