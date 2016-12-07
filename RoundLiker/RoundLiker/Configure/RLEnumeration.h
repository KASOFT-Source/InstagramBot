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

typedef NS_ENUM(NSInteger, RLPackageType) {
    RLPackageTypeFree = 0,
    RLPackageType1,
    RLPackageType2,
    RLPackageType3,
    RLPackageType4
};

#define kCheckoutKeyIdenfitier @"RLItemIdenfitier"
#define kCheckoutKeyName @"RLItemName"
#define kCheckoutKeyDescription @"RLItemTypeDescription"
#define kCheckoutDateKey @"RLItemTypeBuyingDate"

#define ITEMS_ARRAY (@[@"studio.kensai.pro10",@"studio.kensai.pro1"])
