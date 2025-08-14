# HotelsDemo

*A clean-architecture iOS app showcasing hotel search, filtering with modern Swift.*

> [!NOTE]
> This project was created as a personal learning exercise to practice building applications using the VIP (View–Interactor–Presenter) architecture. The focus is on clean separation of concerns, modularity, and testability rather than on complete product features or UI polish. It is intended for demonstration in a portfolio to showcase architectural decision-making, code organization, and implementation skills.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Screenshots](#screenshots)
- [Technical Stack](#technical-stack)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Quality Assurance](#quality-assurance)
- [Roadmap](#roadmap)
- [License](#license)

## Overview

HotelsDemo demonstrates how to build a modern iOS application using **Clean Swift (VIP)** architecture.  
It includes a fully functional hotels search, and filtering flow — all backed by a clean, testable design.

## Architecture

The project follows the **Clean Swift (VIP)** pattern, ensuring separation of concerns and testability.

### Physical Structure

The folders in the project are organized as follows:
- **Features** – Main functionality modules organized by domain (e.g., Hotels Search)
- **Shared** – Common utilities and base components
- **Shared UI** – Reusable UI components
- **Helpers** – Utility functions and extensions

## Features

- **Hotel Search Criteria** (destination, dates, room guests)
  - Choose destination (country, city, area)
  - Pick check-in and check-out date range
  - Specify number of rooms and guests (adults, children, children’s ages)
  - Store selected search criteria between app launches
  - Validate search criteria before performing a search
- **Hotel Search**
  - Fetch hotels matching the selected search criteria
- **Hotel Filters** (price, rating, review score)
  - Apply filters to hotel search results locally on the device
- **Image Prefetching / Loading / Caching**
  - Prefetch hotel images before they appear on screen
  - Load images efficiently to reduce flicker
  - Cache images to avoid repeated network requests

## Screenshots

<p align="center">
	<img src="Screenshots/screenshot1.png" width="400">
	<img src="Screenshots/screenshot2.png" width="400">
</p>

<p align="center">
	<img src="Screenshots/screenshot3.png" width="400">
	<img src="Screenshots/screenshot4.png" width="400">
</p>

## Technical Stack

- **Swift**
- **UIKit**
- **XCTest** for unit testing
- **SwiftLint** for code style enforcement
- **GitHub Actions** for CI/CD

## Requirements

- iOS **18.0+**
- Xcode **16.0+**
- Swift **6.0+**

## Getting Started

1. **Clone the repository**

```bash
git clone https://github.com/denyskt-hub/HotelsDemo.git
```

2. **Open the project in Xcode**

```bash
open HotelsDemo.xcodeproj
```

3. Copy `Config/Secrets.Template.xcconfig` to:
   - `Config/Secrets.Debug.xcconfig`
   - `Config/Secrets.Release.xcconfig`

4. Replace the placeholder values with your actual keys.

```
API_KEY – your RapidAPI key  
API_HOST – the API host from RapidAPI  
BASE_URL – the API base URL (often `https://<API_HOST>`)  
```

**Note**: Without a valid API_KEY and API_HOST, API requests will fail.

⚠️ Never commit the real `Secrets.Debug.xcconfig` or `Secrets.Release.xcconfig`.
They are in `.gitignore` by default.

5. **Select the `HotelsDemo` scheme**

6. **Build & Run** on your desired simulator or device

## Quality Assurance

- ✅ Unit tests covering business logic, data mapping, and edge cases
- ✅ Automated builds & tests via GitHub Actions
- ✅ SwiftLint style checks in CI

## Roadmap

- [ ] Sort hotels on search screen
- [ ] Add cache eviction policy
- [ ] Add localization
- [ ] Display filters metadata on filters screen
- [ ] Hotels search criteria editing on search screen

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
