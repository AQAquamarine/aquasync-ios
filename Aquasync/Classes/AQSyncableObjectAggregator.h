//
//  AQSyncableObjectAggregator.h
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQRequestAuthenticationSpecification;
@class AQDeltaPack;

/**
 *  A protocol that developers should implement for gathering / storing Aquasync-able objects.
 *  
 *  It has responsibility to gather objects that needs synchronization & store the DeltaPack.
 */
@protocol AQSyncableObjectAggregator <NSObject>

# pragma mark - Working with Pull Sync
/** @name Working with Pull Sync */

/**
 *  This method should store a new data and update existing data from DeltaPack.
 *  The method to merge a DeltaPack is described at https://github.com/AQAquamarine/aquasync-protocol#pullsync
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#pullsync for detailed description.
 *
 *  ### 日本語
 *
 *  このメソッドでは PullSync を行って得られた DeltaPack をデータベースに格納してください。
 *  DeltaPack をデータベースにマージする方法は、 https://github.com/AQAquamarine/aquasync-protocol#pullsync にて解説されています。
 *
 *  #### 各モデルの全ての Delta にて、次を行います。
 *  
 *  - Delta の `aq_gid` と同じ `aq_gid` を持つレコードが無いか調べます
 *  
 *  ##### 存在しない場合
 *
 *  - Delta のデータを用いて、レコードを作成します。このとき、Delta のキーはプロパティの keyPath に相当し、値はプロパティの値に相当します。 (`AQDelta` は `NSDictionary` なので、通常 `+ objectFromDictionary:` 等のメソッドでこれが行われます。)
 *     **注意: 通常行われるべき aq_dirty や aq_localTimestamp の更新を、この操作では行わないようにしてください。 **
 *
 *  ##### 存在する場合、
 *  
 *  以下を行います。
 *
 *  - Delta の `aq_localTimestamp` が該当レコードの `aq_localTimestamp` **以上**の場合、Delta を用いてレコードを更新します。このとき、Delta のキーはプロパティの keyPath に相当し、値はプロパティの値に相当します。（`AQDelta` は `NSDictionary` なので、通常 `- updateObjectFromDictionary:` 等のメソッドでこれが行われます。）
 *   **注意: 通常行われるべき aq_dirty や aq_localTimestamp の更新を行わないようにしてください。**
 *  - でないならば、該当レコードの方がユーザの最新の操作によって変更されたものと見なされるので、更新は行いません。
 *
 *  @param deltaPack A DeltaPack to merge.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pullsync
 */
- (void)updateRecordsUsingDeltaPack:(AQDeltaPack *)deltaPack;

# pragma mark - Working with Push Sync
/** @name Working with Push Sync */

/**
 *  This method should return a number of object which needs synchronization.
 *  For do this, simply query `aq_isDirty == YES`.
 *
 *  このメソッドでは同期が必要なレコードの数を返してください。
 *  最も単純な実装では、`aq_isDirty == YES` のクエリでこれを行うことが出来ます。
 *
 *  @return A number of object that needs synchronization.
 */
- (NSUInteger)countObjectsNeedingSynchronization;

/**
 *  This method should return a DeltaPack for Push sync.
 *  The method to gather a DeltaPack is described at https://github.com/AQAquamarine/aquasync-protocol#pushsync
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#pushsync for detailed description.
 *
 *  このメソッドでは、PushSync 同期のための DeltaPack をビルドし、返してください。
 *  PushSync 同期のために DeltaPack をビルドする方法は https://github.com/AQAquamarine/aquasync-protocol#pushsync で解説されています。
 *
 *  1. `aq_isDirty == YES` のレコードを全て集めてください
 *  2. `AQDeltaPack` に、それぞれのレコードを `NSDictionary`(`AQDelta`) で表現したものを入れます。
 *
 *  @return A DeltaPack to push sync.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pushsync
 */
- (AQDeltaPack *)deltaPackForSynchronization;

/**
 *  This method should mark the objects contained in given DeltaPack as pushed. (It means you should set `aq_isDirty` as `NO`).
 *  Make sure you should NOT mark as read if the object's `localTimestamp` is newer than the object extracted from the DeltaPack.
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#undirty for detailed description.
 *
 *  このメソッドでは、PushSync 同期に使った DeltaPack を用いて、レコードを Push 済みにマークしてください。
 *  マークの際は、`aq_localTimestamp` が変更されていないかを必ずチェックしてください。（つまり、レコードの `aq_localTimestamp` が Delta の `aq_localTimestamp` よりも大きい場合は更新をスキップしてください。）
 *
 *  より詳しい解説は https://github.com/AQAquamarine/aquasync-protocol#undirty を参照してください。
 *
 *  **この操作の最中は、通常行われるべき aq_isDirty, aq_localTimestamp の更新を行わないでください。**
 *
 *  @param deltaPack A DeltaPack that contains pushed objects.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#undirty
 */
- (void)markAsPushedUsingDeltaPack:(AQDeltaPack *)deltaPack;

# pragma mark - UST
/** @name UST */

/**
 *  最後に pullSync をした timestamp を保管します。
 *
 *  @warning このプロパティはアプリのアンインストールで消えても問題ありません。ですので、`NSUserDefaults` 等を使った実装で問題有りません。
 *
 *  @param UST
 */
- (void)setUST:(NSInteger)UST;

/**
 *  最後に pullSync をした timestamp を返します。
 *  `- setUST:` で保管した timestamp を返してください。
 *
 *  @return 最後に pullSync をした timestamp
 */
- (NSInteger)UST;

# pragma mark - Device Token
/** @name Device Token */

/**
 *  デバイスを識別するための識別子を返してください。
 *  `aq_deviceToken` のために用いるものと同じ識別子を返してください。
 *
 *  @warning この識別子は、アプリのアンインストールの際に変わらないようにしてください。そうすることで、アプリが再度インストールされたときに、前の状態の復元をすることが可能になります。
 *
 *  @return デバイスを識別するための識別子
 */
- (NSString *)deviceToken;

# pragma mark - Request Authentication
/** @name Request Authentication */

/**
 *  リクエストに認証を付与するための AQRequestAuthenticationSpecification を返してください。
 *
 *  @return リクエストに認証を付与するための AQRequestAuthenticationSpecification
 */
- (AQRequestAuthenticationSpecification *)requestAuthenticationSpecification;

@end