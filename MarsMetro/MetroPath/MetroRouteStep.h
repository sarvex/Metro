//
//  MetroRouteStep.h
//  MarsMetro
//

#import <Foundation/Foundation.h>
/**
 Class which describes the step in a route between two metro stations.
 Each object represents a station and an track which is connected to another station.  If this is the last station in the route, the track will be nil.
  */
@class MetroStation,MetroTrack;

@interface MetroRouteStep : NSObject
{
    
    /**
     Variable to check whether the step is first in the route.
     */
    BOOL isFirstStep;
    
    /**
     The station that this step is starting from     */
    MetroStation *station;
    
    /**
     The path from this node to the next node in the route, if one exists.
     Will be nil if the current step is the last step in the chain
     */
    MetroTrack *track;
    
    /**
     Variable to check if this is the ending step in the route     */
    BOOL isEndingStep;
    
   

}
@property (nonatomic, strong, readonly) MetroStation *station;
@property (nonatomic, strong, readonly) MetroTrack *track;
@property (nonatomic, readonly) BOOL isFirstStep;

@property (nonatomic, readonly) BOOL isEndingStep;


/**
 Returns an initialized step object with station and track
 @param aStation the station from which this step starts
 @param aTrack the track object describing the path from the station to the next station in the route. if this is nil, the step is treated as the last object in the route.
 @returns an object describing a step in the overall route
 */
- (id)initWithStation:(MetroStation *)aStation andTrack:(MetroTrack *)aTrack;

/**
 Returns an initialized step object with station and track,including a flag to check if its the first step in the route.
 @param aStation the station from which this step starts
 @param aTrack the track object describing the path from the station to the next station in the route. if this is nil, the step is treated as the last object in the route. @param isBeginning whether this step is the first step in the route
 @returns an object describing a single in the overall route
 */
- (id)initWithStation:(MetroStation *)aStation andTrack:(MetroTrack *)aTrack asBeginning:(BOOL)isBeginning;


@end
