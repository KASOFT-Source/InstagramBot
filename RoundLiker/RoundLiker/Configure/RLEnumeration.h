#pragma once

typedef NS_ENUM(NSInteger, RLPackageType) {
    RLPackageTypeFree = 0,
    RLPackageType1,
    RLPackageType2,
    RLPackageType3,
    RLPackageType4
};

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
