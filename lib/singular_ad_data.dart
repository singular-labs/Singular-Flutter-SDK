import 'dart:collection';

const ADMON_IS_ADMON_REVENUE = 'is_admon_revenue';
const ADMON_AD_PLATFORM = 'ad_platform';
const ADMON_CURRENCY = 'ad_currency';
const ADMON_REVENUE = 'ad_revenue';
const ADMON_NETWORK_NAME = 'ad_mediation_platform';
const ADMON_AD_TYPE = 'ad_type';
const ADMON_AD_GROUP_TYPE = 'ad_group_type';
const ADMON_IMPRESSION_ID = 'ad_impression_id';
const ADMON_AD_PLACEMENT_NAME = 'ad_placement_name';
const ADMON_AD_UNIT_ID = 'ad_unit_id';
const ADMON_AD_UNIT_NAME = 'ad_unit_name';
const ADMON_AD_GROUP_ID = 'ad_group_id';
const ADMON_AD_GROUP_NAME = 'ad_group_name';
const ADMON_AD_GROUP_PRIORITY = 'ad_group_priority';
const ADMON_PRECISION = 'ad_precision';
const ADMON_PLACEMENT_ID = 'ad_placement_id';
const IS_REVENUE_EVENT_KEY = 'is_revenue_event';
const REVENUE_AMOUNT_KEY = 'r';
const REVENUE_CURRENCY_KEY = 'pcc';

class SingularAdData extends MapBase<String, dynamic> {
  Map<String, dynamic> _map = {};

  final requiredParams = [ADMON_AD_PLATFORM, ADMON_CURRENCY, ADMON_REVENUE];

  SingularAdData(adPlatform, currency, revenue) {
    this[ADMON_AD_PLATFORM] = adPlatform;
    this[ADMON_REVENUE] = revenue;
    this[ADMON_CURRENCY] = currency;
    this[REVENUE_AMOUNT_KEY] = revenue;
    this[REVENUE_CURRENCY_KEY] = currency;
    this[ADMON_IS_ADMON_REVENUE] = true;
    this[IS_REVENUE_EVENT_KEY] = true;

    this[ADMON_NETWORK_NAME] = adPlatform;
  }

  withNetworkName(String networkName) {
    this[ADMON_NETWORK_NAME] = networkName;
    return this;
  }

  withAdType(String adType) {
    this[ADMON_AD_TYPE] = adType;
    return this;
  }

  withAdGroupType(String adGroupType) {
    this[ADMON_AD_GROUP_TYPE] = adGroupType;
    return this;
  }

  withImpressionId(String impressionId) {
    this[ADMON_IMPRESSION_ID] = impressionId;
    return this;
  }

  withAdPlacementName(String adPlacementName) {
    this[ADMON_AD_PLACEMENT_NAME] = adPlacementName;
    return this;
  }

  withAdUnitId(String adUnitId) {
    this[ADMON_AD_UNIT_ID] = adUnitId;
    return this;
  }

  withAdUnitName(String adUnitName) {
    this[ADMON_AD_UNIT_NAME] = adUnitName;
    return this;
  }

  withAdGroupId(String adGroupId) {
    this[ADMON_AD_GROUP_ID] = adGroupId;
    return this;
  }

  withAdGroupName(String adGroupName) {
    this[ADMON_AD_GROUP_NAME] = adGroupName;
    return this;
  }

  withAdGroupPriority(String adGroupPriority) {
    this[ADMON_AD_GROUP_PRIORITY] = adGroupPriority;
    return this;
  }

  withPrecision(String precision) {
    this[ADMON_PRECISION] = precision;
    return this;
  }

  withPlacementId(String placementId) {
    this[ADMON_PLACEMENT_ID] = placementId;
    return this;
  }

  bool hasRequiredParams() {
    for (var key in requiredParams) {
      if (this.containsKey(key) == false ||
          this[key] == null ||
          this[key].toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  remove(Object? key) => _map.remove(key);
}
