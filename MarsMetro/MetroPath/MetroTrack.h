//
//  MetroTrack.h
//  MarsMetro
//

#import <Foundation/Foundation.h>
/**
Class represents the track which will be responsible for interconnecting two stations. 
 */

@interface MetroTrack : NSObject
{
    /**
    Weight corresponds to the duration it takes to travel the track from the start to the end point.
     */
    NSNumber *weight;
    
    /**
     The unique name of the track in order to identify the route.
     */
    NSString *trackName;
    
    /**
     The line color of the track
     */
    NSString *lineColor;

}
/**
 Class Method initializer that allows for setting the track's name and weight
 @param name a description of the information
 @param weightValue the weight to assign to this track
 @returns an initialized edge
 */
+ (MetroTrack *)trackWithName:(NSString *)name andWeight:(NSNumber *)weightValue;


/**
 Class Method initializer that allows for setting the track's name and weight and line color
 @param name a description of the information
 @param weightValue the weight to assign to this track
 @param color the line color to assign to this track

 @returns an initialized edge
 */
+ (MetroTrack *)trackWithName:(NSString *)name andWeight:(NSNumber *)weightValue lineColor:(NSString*)color;
@property (nonatomic, strong) NSNumber *weight;

@property (nonatomic, strong)  NSString *lineColor;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *trackEndStationID;
@property (nonatomic, strong) NSString *trackStartStationID;
@property (nonatomic, strong) NSString *lineEndPoint;

@end
