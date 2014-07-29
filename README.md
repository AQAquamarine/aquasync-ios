Aquasync-iOS
====================

SIMPLE.

```objc
[[AQSyncManager sharedInstance] sync];
```

to perform synchronization.
Errors and retries are automatically handled.

Requirements
---

- Object model should satisfy Aquasync Model specification. (https://github.com/AQAquamarine/aquasync-protocol/blob/master/aquasync-model.md). 


- Models should be managed by a manager class which implements following protocol. (An example implementation is provided in this implementation.)

```objc
//AQModelManagerProtocol.h

+ (NSArray *)aq_extractDeltas;
+ (void)aq_receiveDeltas:(NSArray *)deltas;
+ (void)aq_undirtyRecordsFromDeltas:(NSArray *)deltas;
```

- Then just simply `[[AQSyncManager sharedInstance] sync];`
