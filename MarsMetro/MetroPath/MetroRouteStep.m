//
//  MetroRouteStep.m
//  MarsMetro
//

#import "MetroRouteStep.h"

@implementation MetroRouteStep
@synthesize track, station, isFirstStep, isEndingStep;

#pragma mark -
#pragma mark Initializer

- (id)init
{
    self = [super init];
    
    if (self) {
        
        isFirstStep = NO;
        isEndingStep = NO;
    }
    
    return self;
}

- (id)initWithStation:(MetroStation *)aStation andTrack:(MetroTrack *)aTrack;
{
    self = [super init];
    
    if (self) {
        
        isFirstStep = NO;
        if(!aTrack)
        isEndingStep = YES;
        station = aStation;
        track = aTrack;
    }
    
    return self;
}

- (id)initWithStation:(MetroStation *)aStation andTrack:(MetroTrack *)aTrack asBeginning:(BOOL)isBeginning;
{
    self = [super init];
    
    if (self) {
        
        isFirstStep = isBeginning;
        if(!aTrack)
            isEndingStep = YES;
        station = aStation;
        track = aTrack;
    }
    
    return self;
}

#pragma mark -
#pragma mark Property Implementations
- (BOOL)isEndingStep
{
    if(!track)
    return YES;
    
    else return NO;
}


@end
