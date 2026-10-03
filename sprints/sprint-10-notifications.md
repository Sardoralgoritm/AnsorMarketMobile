# Sprint 10 — Push Notifications

## Goal
Implement push notifications so users are informed about order status updates, promotions, and other important events. Notifications must deep-link into the right screen in the app.

---

## Expected Backend Support

The backend will need to:
1. Store FCM/APNs device tokens per user (endpoint anticipated: `POST /api/customer/device-token`)
2. Send notifications on order status changes
3. Optionally send promotional push notifications

---

## Tech Stack

| Concern | Package |
|---------|---------|
| Push notifications | `firebase_messaging` |
| Local notifications (foreground display) | `flutter_local_notifications` |
| Firebase setup | `firebase_core` |

---

## Setup

### Firebase
1. Create Firebase project for AnsorMarket
2. Add Android app (`uz.ansormarket.ansor_market_mobile`) + `google-services.json`
3. Add iOS app + `GoogleService-Info.plist`
4. Enable Cloud Messaging in Firebase console

### Android
- Add `google-services.json` to `android/app/`
- Add Firebase BOM to `android/build.gradle`
- Request `POST_NOTIFICATIONS` permission (Android 13+)

### iOS
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Enable Push Notifications + Background Modes (remote notifications) in Xcode capabilities
- APNs key uploaded to Firebase

---

## Device Token Registration

On login success and on every app open (if token changed):

```dart
// In auth flow, after successful login:
final fcmToken = await FirebaseMessaging.instance.getToken();
if (fcmToken != null) {
  await customerRepository.registerDeviceToken(fcmToken);
}

// Listen for token refresh:
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  customerRepository.registerDeviceToken(newToken);
});
```

Expected API: `POST /api/customer/device-token` body: `{ token, platform: 'android'|'ios' }`

On logout: `DELETE /api/customer/device-token` to unregister.

---

## Notification Handling

### Foreground notifications
Firebase doesn't show a notification banner when the app is in the foreground. Use `flutter_local_notifications` to display it:

```dart
FirebaseMessaging.onMessage.listen((message) {
  if (message.notification != null) {
    localNotifications.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
});
```

### Background / terminated notifications
Firebase handles display automatically. Wire up tap handler:

```dart
// Notification tapped while app in background
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  _handleNotificationNavigation(message.data);
});

// App opened from terminated state via notification
final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
if (initialMessage != null) {
  _handleNotificationNavigation(initialMessage.data);
}
```

---

## Deep Link Navigation

```dart
void _handleNotificationNavigation(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  final id = data['id'] as String?;

  switch (type) {
    case 'order_update':
      router.push('${RouteNames.orders}/$id');
    case 'promotion':
      router.push('${RouteNames.productList}?promoId=$id');
    case 'new_product':
      router.push('${RouteNames.productDetail.replaceFirst(':id', id!)}');
    default:
      router.push(RouteNames.home);
  }
}
```

---

## Notification Types (anticipated)

| Type | Trigger | Data payload | Deep link |
|------|---------|-------------|-----------|
| `order_update` | Order status change | `{ type, id: orderId, status }` | Order Detail |
| `promotion` | Marketing push | `{ type, id: promoId, title }` | Product List (filtered) |
| `new_product` | New product added | `{ type, id: productId }` | Product Detail |
| `promo_code` | Personal promo code | `{ type, code }` | Checkout |

---

## Notification Permissions

Request on first app launch (after onboarding, not on splash):

```dart
await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

If denied: do not nag. Show a subtle in-app banner once offering to enable notifications → opens app settings.

---

## Notification Center (In-App)

A simple in-app notification list in the Profile section:

- Bell icon in Home AppBar with unread badge count
- Tapping → Notifications screen
- List of past notifications (store locally with Hive, last 50)
- Each item: icon (type-based), title, body, time ago, read/unread state
- Tap → deep link to relevant screen
- Swipe to dismiss individual notification
- "Mark all as read" action

```dart
@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  // State: List<NotificationItem> (from Hive)
  void markRead(String id) { ... }
  void markAllRead() { ... }
  void dismiss(String id) { ... }
}

@riverpod
int unreadNotificationCount(Ref ref) {
  return ref.watch(notificationsNotifierProvider)
      .where((n) => !n.isRead).length;
}
```

---

## Animations Checklist

- [ ] Notification badge on bell icon: scale pop-in when new notification arrives
- [ ] Notification list items: staggered fade-in
- [ ] Swipe to dismiss: slide out + height collapse
- [ ] Mark as read: background color fade transition
- [ ] Notification banner (foreground): slide down from top, auto-dismiss after 4s

---

## Acceptance Criteria

- [ ] FCM token registered on login for both Android and iOS
- [ ] Push notification received and displayed (all 3 app states: foreground, background, terminated)
- [ ] Tapping notification navigates to correct screen
- [ ] Token refreshed automatically
- [ ] Token deleted on logout
- [ ] In-app notification center shows history
- [ ] Unread badge count correct
- [ ] `flutter analyze` returns zero errors
