#import "../base_lockdown_task.h"

@interface ScreenCaptureDisabler : NSObject <NSMetadataQueryDelegate> {
@private
	NSMetadataQuery *query;
}

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

- (void)runTask;
- (void)stopTask;

@end
