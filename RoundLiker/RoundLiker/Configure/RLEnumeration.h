#pragma once

typedef NS_ENUM(NSInteger, RLLikeStatus) {
    RLLikeStatusNone = 0,
    RLLikeStatusDone,
    RLLikeStatusFail
};

typedef NS_ENUM(NSInteger, RLRequestStatus) {
    RLRequestStatusSuccess = 0,
    RLRequestStatusFail,
    RLRequestStatusFailByLimited
};

#define kCheckoutKeyIdenfitier @"RLItemIdenfitier"
#define kCheckoutKeyName @"RLItemName"
#define kCheckoutKeyDescription @"RLItemTypeDescription"

#define kCheckoutDateKey @"RLItemTypeBuyingDate"
