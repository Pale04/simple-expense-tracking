# Simple Expense Tracking App

This Android app offers a simple and easy manner of track your expenses and incomes. An internet connection is not necesary because all the data is stored locally. So you can add an expense or income at any time, for example, on the bus, in a supermarket or even in a forest.

This app is recommended for students, housewives and people who has an accelerated life and want to manage and track their money.

## Table of Contents

- [Features](#features)
    - [Available features](#avaialable-features)
    - [Upcoming features](#upcoming-features)
- [Installation](#installation)
- [Usage](#usage)
- [Development process](#development-process)
    - [Design](#design)
    - [Coding](#coding)
    - [Testing](#testing)
- [License](#license)

## Features

### Avaialable features
*First set of features in development.*

### Upcoming features
- Add, Delete and update expenses
- Add, delete and update incomes
- View statistics about the expenses and incomes through the time.
- Categorize expenses and incomes
- Search and filter transactions
- Add recurring transactions
- Implement dark mode
- Cloud backup support
- Export data to PDF

## Installation

1. Get dependencies
    ```bash
    flutter pub get 
    ```
2. Build and run the app on the configured android device
    ```bash
    flutter run -d <device name>
    ```

## Usage

*Available after releasing the first version*.

## Development process
This section contains relevant information about the analysis, design decisions, key elements and practices in codification and testing planning.

### Design
#### Architecture
This app is based on MVVM architecture with a layered structure. The project follows the next folders structure:

```
lib
├─┬─ ui
│ ├─┬─ core
│ │ ├─┬─ shared
│ │ │ └─── <shared widgets>
│ │ └─── theme
│ └─┬─ <FEATURE NAME>
│   ├─── <view_model class>.dart
│   └─── <feature name>_screen.dart
├─┬─ domain_models
│ └─── <model name>.dart
├─┬─ data
│ ├─┬─ repositories
│ │ └─── <repository class>.dart
│ └─── local_db.dart
├─── config
├─┬─ utils
│ └─── constants.dart
├─── routing
└─── main.dart

test
├─── data
└─── ui
```

### Coding
This project is implemented with flutter and follows MVVM architecture.

#### Libraries
- **sqflite** - Data persistence with SQLite
- **path** - Manipule paths.
- **provider** - Dependency injection
- **go_router** - Manage UI navigation
- **intl** - Format data

### Testing
*Testing plan upcoming*

## License
This project is licensed under the MIT License.