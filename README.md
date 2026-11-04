<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 16 33 PM" src="https://github.com/user-attachments/assets/b6cfcba4-881a-4177-987e-f1eecfd49ec1" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 26 39 PM" src="https://github.com/user-attachments/assets/137f18ab-0127-4d94-8d85-a3a40a55bb4d" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 17 09 PM" src="https://github.com/user-attachments/assets/156b24e3-861c-472b-bbf1-552542911dcd" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 17 14 PM" src="https://github.com/user-attachments/assets/8e834aac-2456-4c29-b16a-11e38b76bede" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 19 PM" src="https://github.com/user-attachments/assets/294dc9f5-245f-4a90-863d-2516572ad524" />

<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 24 PM" src="https://github.com/user-attachments/assets/2ddd3773-4da0-4706-895c-c5faf158f5b4" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 29 PM" src="https://github.com/user-attachments/assets/30da291f-cf7a-4b0a-9e0a-a68970347d6c" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 20 12 PM" src="https://github.com/user-attachments/assets/a8facf8b-3dc6-42a5-924b-b16481b7bcc5" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 41 PM" src="https://github.com/user-attachments/assets/126508d8-e615-4310-b56e-66938e9a6abe" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 46 PM" src="https://github.com/user-attachments/assets/d6589ffc-00dc-4e49-8598-967c1c2e870a" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 18 53 PM" src="https://github.com/user-attachments/assets/23cc9b5a-8b5d-4f30-85c2-edb905a3237b" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 19 02 PM" src="https://github.com/user-attachments/assets/7e11d867-76ba-4feb-bc63-c536c9e9b366" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 19 53 PM" src="https://github.com/user-attachments/assets/6262ce12-fbb5-4b80-9b92-8464a06f284b" />
<img width="1320" height="2868" alt="Screenshot iPhone 17 Pro Max 04-11-2026 at 6 20 02 PM" src="https://github.com/user-attachments/assets/3d2dd466-c043-450c-bee6-1166f66023d7" />



# Shopping App

Shopping App is a Flutter shopping app for Android and iOS, built with the DummyJSON API. You can sign in, browse products, search or filter by category, and save items to a cart that stays available between sessions. Home, Cart, and Profile are accessible from the bottom navigation bar.

Once products are cached, you can browse them and edit your cart offline. Checkout is a simulation; it does not charge money.

## Getting started

### Prerequisites

- Flutter with Dart 3.9.2 or newer within Dart 3, as specified in `pubspec.yaml`.
- Android SDK and a compatible JDK for Android development.
- macOS, Xcode, and CocoaPods for iOS development. The minimum iOS version is 15.0.
- An Android emulator, iOS simulator, or connected device.
- An internet connection for setup, your first sign-in, new products, and checkout.

From the project root:

```bash
flutter doctor
flutter pub get
flutter devices
```


The app connects to `https://dummyjson.com`. The base URL is defined in `lib/core/helper/dio/end_points.dart`. You do not need an API key, `.env` file, Firebase setup, or a local backend.

For release builds:

```bash
flutter build apk
flutter build ios --no-codesign
```

Build iOS on macOS. To install the app on a physical iPhone, configure signing for your development team in Xcode.

## Test credentials

Use the public demo account published in the [DummyJSON authentication documentation](https://dummyjson.com/docs/auth):

| Field | Value |
| --- | --- |
| Username | `emilys` |
| Password | `emilyspass` |

You can find other demo accounts in [DummyJSON users](https://dummyjson.com/users). These are public accounts, so use them only for the demo. Passwords are never saved. The app requests a 60-minute access token at login and asks you to sign in again when it expires.

## Architecture

Code is grouped by feature, with shared networking, storage, and UI under `core`. Each feature keeps its widgets separate from its business logic and data access. Dependencies are passed through constructors.

Widgets read data from Cubits. Cubits call repositories, which decide whether to use the API or local storage. API services handle requests and JSON parsing, while repositories return domain entities.

```text
lib/
├── main.dart                 # Storage initialization and startup retry
├── app.dart                  # Dependency wiring, auth gate, route setup
├── core/
│   ├── helper/api/           # Shared request handling
│   ├── helper/dio/           # HTTP transport, endpoints, failure mapping
│   ├── navigation/           # Home, Cart, and Profile tab shell
│   ├── pricing/              # Quantity validation and integer-cent totals
│   ├── result/               # Either and repository result helpers
│   ├── storage/              # SQLite, secure session, layout preference
│   └── widgets/              # Shared UI and ScreenUtil configuration
└── features/
    ├── auth/
    ├── products_home/        # Catalog and product details
    ├── cart/
    ├── profile/
    └── splash/
```

Auth, products, and cart organize code under `data/{data_source,models,repo_imp}`, `domain/{entities,repo}`, `controller/`, and `widgets/`, with entry screens at the feature root.

State management uses `flutter_bloc`. Cubits keep entities, lists, and UI metadata on typed properties. Empty sealed state classes signal loading, success, or errors so widgets know when to rebuild. Repository operations return `Future<Either<ApiFailure, T>>`, with enough failure detail to handle network problems and expired sessions.

Dio handles HTTP requests, shared timeouts, and error mapping. Each feature's API service owns its requests and response parsing.

Authenticated Cubits and routes belong to the current session. Request and session checks prevent a late response from overwriting newer data or changing another user's cart.

The UI uses Material 3 and `flutter_screenutil`, with a 375×812 design size for phone and tablet layouts. Switching tabs keeps Home mounted, so your search and layout choice stay in place.


## Storage choices and offline behavior

| Storage | Stored data | Reason for the choice |
| --- | --- | --- |
| SQLite (`sqflite`), `dummy_shop.db` | Products keyed by ID, categories keyed by slug, cart snapshots keyed by `(user_id, product_id)` | Transactions keep cart updates together, and each account has its own saved cart. |
| `flutter_secure_storage` | Access token, refresh token, and profile together as a saved session | Keeps authentication data in platform-backed secure storage. Passwords are never saved. |
| `shared_preferences` | Catalog grid/list preference (`catalog.grid`) | A simple preference is enough for this non-sensitive setting. |
| `cached_network_image` | Product/profile image cache | Reuses downloaded images, with placeholders while loading or when an image is unavailable. Offline images depend on what is cached. |

The catalog tries the network first. If a request fails, it falls back to saved products and categories. Offline searches and filters only cover products you have already cached; the app does not download the whole catalog in advance. If saving a fresh response fails, the app still shows the downloaded products and displays a warning.

Saved cart items include product details, prices, discounts, and stock. Cart changes are written to storage before the app reports success. Signing out clears the secure session and data held in memory. Your cart stays in SQLite and returns when you sign in with the same account. Product and cart data in SQLite is not encrypted. Android backup is disabled because restoring encrypted session data without the original device keys can make it unreadable.

At startup, the app checks an unexpired saved session through `/auth/me`. If the network is unavailable, it can use the saved session as long as the token has a readable expiry, has not expired, and matches the saved user. Missing, expired, or rejected sessions require sign-in. A server error does not grant offline access.

The local token check reads the JWT identity and expiry without verifying its signature. Offline access therefore relies on the previously authenticated session remaining in secure storage.
