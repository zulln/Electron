#import "../base_lockdown_task.h"

@interface ScreenCaptureDisabler : NSObject <NSMetadataQueryDelegate> {
@private
	NSMetadataQuery *query;
}

@property (nonatomic, copy) NSArray *queryResults;

- (void)runTask;
- (void)stopTask;
//- (void)onUpdate;

@end
