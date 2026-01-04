# Flutter Web Inventory Stock Management System

A professional, offline-capable inventory management system built with Flutter Web. Designed for small to medium businesses, this system provides a robust solution for tracking products, sales, purchases, and suppliers with a one-time license model.

## 🚀 Features

- **Dashboard Overview**: Real-time business KPIs (Sales, Profit, Low Stock) and recent activity.
- **Product Management**: SKU tracking, category grouping, and low-stock thresholds.
- **Category Management**: Organize products with deletion protection.
- **Supplier Management**: Track vendor contact information and history.
- **Purchase Management (Stock In)**: Multi-product entry with automatic stock level updates.
- **Sales Management (Stock Out)**: POS-like interface with real-time stock validation and profit calculation.
- **Inventory Adjustments**: Manual stock overrides with reason logging.
- **Reports & Exports**: Generate PDF and Excel reports for Inventory, Sales, and Purchases.
- **Settings**: Business profile configuration and Light/Dark mode support.
- **Offline First**: Powered by Isar Database (IndexedDB) for fast, reliable offline usage.
- **License Management**: Built-in trial mode and license activation system.

## 🛠️ Tech Stack

- **Framework**: [Flutter Web](https://flutter.dev/multi-platform/web)
- **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
- **Local Database**: [Isar](https://isar.dev/)
- **UI Design**: Material 3
- **Reporting**: [pdf](https://pub.dev/packages/pdf), [excel](https://pub.dev/packages/excel), [printing](https://pub.dev/packages/printing)

## 📦 Getting Started

### Prerequisites

- Flutter SDK (Latest stable version)
- Chrome or any modern web browser

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd inventory
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate database code**:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application**:
    ```bash
    flutter run -d chrome
    ```

## 🔑 Default Credentials

- **Username**: `admin`
- **Password**: `admin123`

## 📄 License

This project is intended for use under a one-time license model. See the license activation screen for more details.
