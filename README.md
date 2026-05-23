# AppleMart 🛒

An e-commerce Flutter application that demonstrates a simple, clean marketplace UI, product browsing, cart and checkout flow, user authentication, and profile management.

---

## Contents 📌

- 📖 **Overview** — What the app does and key features.
- 📸 **Screenshots** — Visual preview with a quick-reference table.
- **Getting Started** — Prerequisites and step-by-step setup.
- **Project Structure** — Important files and where to find them.
- **Build & Release** — How to build for Android/iOS/web.
- **Contributing** — How to help or report issues.

---

## Overview 📖

AppleMart is a sample marketplace app built with Flutter. It showcases:

- Category browsing and product listing
- Product detail pages with images and descriptions
- Shopping cart with quantity controls and checkout flow
- User registration and login
- Favorites and user profile management

The app is intended as a starting point for learning Flutter app structure and for fast prototyping of mobile commerce features.

## Screenshots 📸

Add screenshots to `assets/screenshots/` (recommended size: 1080×1920 for phone), then commit them so GitHub can render them in this README.

| Splsh Screen | Registration | Login |
|---|---|---|
| <img width="380" height="782" alt="1" src="https://github.com/user-attachments/assets/36e27508-28ab-44d6-bf63-55b4de0ae0bb" /> | <img width="352" height="786" alt="registration" src="https://github.com/user-attachments/assets/86ba4bb4-42dc-4cc5-8922-99b2cba6135c" /> | <img width="355" height="785" alt="login" src="https://github.com/user-attachments/assets/8553971a-be96-4a9b-a01c-564b26c95727" /> |
| Home Screen | Category Screen | Product Screen |
| <img width="353" height="789" alt="3" src="https://github.com/user-attachments/assets/20dedc64-c8d2-4286-a65c-eb3fdbe92e72" /> | <img width="352" height="787" alt="5" src="https://github.com/user-attachments/assets/9a5b76b6-1191-4aec-9337-52c8f4e80d39" /> | <img width="353" height="785" alt="4" src="https://github.com/user-attachments/assets/17bb21a7-6757-4d55-a927-648b34092dc4" /> |
| Cart Screen | Checkout Screen | Settings Screen |
| <img width="352" height="787" alt="cart" src="https://github.com/user-attachments/assets/49423e41-bca5-4dfd-b4dd-590081ed4f6b" /> | <img width="352" height="787" alt="6" src="https://github.com/user-attachments/assets/0489ffab-7f80-4b9a-aea5-00602ec90d06" /> | <img width="355" height="786" alt="settings" src="https://github.com/user-attachments/assets/8b444a3a-6189-4952-b22f-b2a5484ac020" /> |

_If you don't yet have screenshots, you can replace the image paths above after adding your screenshots to `assets/screenshots/`._

## ⭐ Key Features

- Simple, responsive UI built with Flutter widgets
- Local state management (small-scale, suitable for extension)
- Placeholder services in `lib/services/` for API integration
- Clean separation of pages under `lib/` for easy navigation

## Prerequisites

- Flutter SDK (stable) — see https://docs.flutter.dev/get-started/install
- Android Studio / Xcode for device emulators (optional)
- Optional: a connected device or emulator

## Quick Start 🚀

1. Clone the repository:

```
git clone <your-repo-url>
cd apple_mart
```

2. Get dependencies:

```
flutter pub get
```

3. Run the app on an available device or emulator:

```
flutter run
```

4. To run on a specific platform (e.g., Android):

```
flutter run -d android
```

## Build & Release

- Android (release):

```
flutter build apk --release
```

- iOS (release, macOS host required):

```
flutter build ios --release
```

- Web:

```
flutter build web
```

## Project Structure

- [lib/main.dart](lib/main.dart) — App entry point
- [lib/main_home_page.dart](lib/main_home_page.dart) — Home navigation and tabs
- [lib/login_page.dart](lib/login_page.dart) — Authentication screens
- [lib/registration_page.dart](lib/registration_page.dart) — Signup flow
- [lib/product_detail_page.dart](lib/product_detail_page.dart) — Product details and add-to-cart
- [lib/cart_page.dart](lib/cart_page.dart) — Cart and checkout pages
- [lib/services/](lib/services/) — Placeholder services for networking and data
- [assets/](assets/) — Images, fonts, and other static assets

Explore these files to learn how pages are structured and how navigation is handled.

## Testing

Run unit/widget tests with:

```
flutter test
```

## How to Add Screenshots

1. Create the directory `assets/screenshots/`.
2. Add PNG images named as in the table above (`home.png`, `category.png`, `product.png`, `cart.png`, `profile.png`).
3. Commit and push them to GitHub. The images will render inside this README automatically.

Example commands:

```
mkdir -p assets/screenshots
# copy screenshots into assets/screenshots/
git add assets/screenshots/* README.md
git commit -m "Add screenshots and improved README"
git push
```

## Contributing

Contributions are welcome. Please open issues for bugs or feature requests, and submit pull requests for proposed changes.

Guidelines:

- Follow existing code style and file layout
- Add tests for new functionality when practical
- Keep changes focused and well-documented

## License 📄

This project is provided as-is. Add a license file (for example, `LICENSE`) if you plan to open-source this repository.

## Contact

For questions or help, open an issue in this repository or contact.

---

Happy hacking — enjoy building with Flutter!
