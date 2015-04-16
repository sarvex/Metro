//
//  MetroTrack.m
//  MarsMetro
//

#import "MetroTrack.h"

@implementation MetroTrack
@synthesize trackName;
@synthesize weight;
@synthesize lineColor;
@synthesize trackEndStationID;
@synthesize trackStartStationID;
@synthesize lineEndPoint;
#pragma mark -
#pragma mark Class Methods

+ (MetroTrack *)trackWithName:(NSString *)name andWeight:(NSNumber *)weightValue {
    
    // Here we allocate and initialize a new object and assign the name and weight to it.

    MetroTrack *track = [[MetroTrack alloc] init];
    
    track.trackName = name;
    track.weight = weightValue;
    
    return track;
}

+ (MetroTrack *)trackWithName:(NSString *)name andWeight:(NSNumber *)weightValue lineColor:(NSString*)color{
    
    // Here we allocate and initialize a new object and assign the name and weight to it.
    
    MetroTrack *track = [[MetroTrack alloc] init];
    
    track.trackName = name;
    track.lineColor = color;
    track.weight = weightValue;
    
    return track;
}


#pragma mark Initializer Method

- (id)init
{
    self = [super init];
    
    if (self) {
        
        // We Set the default weight of the edge to be 1
        self.weight = [NSNumber numberWithInt:1];
    }
    
    return self;
}


@end
