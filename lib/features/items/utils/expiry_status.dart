enum ExpiryStatus { ok, warning, expired, none }

ExpiryStatus getExpiryStatus(bool hasExpiry, String? expiryDate) {
  if (!hasExpiry || expiryDate == null) return ExpiryStatus.none;

  final expiry = DateTime.parse(expiryDate);
  final today = DateTime.now();
  final daysLeft = expiry.difference(DateTime(today.year, today.month, today.day)).inDays;

  if (daysLeft < 0) return ExpiryStatus.expired;
  if (daysLeft <= 7) return ExpiryStatus.warning;
  return ExpiryStatus.ok;
}