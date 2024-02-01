# GitHub Repository Explorer

GitHub Repository Explorer is a Flutter application that allows you to explore GitHub repositories. It utilizes the Provider package for state management, makes HTTP requests to the GitHub API for fetching repository data, and supports offline browsing with local caching.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Screenshots](#screenshots)
- [Futurescope](#futurescope)


## Overview

GitHub Repository Explorer is a mobile app built with Flutter, a UI toolkit from Google for building natively compiled applications for mobile, web, and desktop from a single codebase. It allows users to search for GitHub repositories, view details, and provides offline browsing capabilities.

## Features

- **Search Repositories:** Search GitHub repositories by keyword(Here only showing result for the Keyword 'Android').
- **Sort Repositories:** Sort search results based on criteria such as "best match," "stars," or "updated."
- **Offline Browsing:** Utilizes local caching to enable browsing repositories offline.

## Installation

To run GitHub Repository Explorer on your local machine, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/github-repository-explorer.git
2. Navigate to the project directory

   ```bash
   cd github-repository-explorer

3. Install dependencies
   ```bash
   flutter pub get

4. Run the application:
    ```bash
   flutter run

## Dependencies

The project uses the following dependencies:

- **google_fonts** (version ^6.1.0)
- **http** (version ^1.2.0)
- **intl** (version ^0.19.0)
- **provider** (version ^6.1.1)
- **shared_preferences** (version ^2.2.2)
- **connectivity_plus** (version ^5.0.2)

## Screenshots
<p align="center">
    <img src="https://github.com/rasel3413/GitHub-Repository-Explorer/blob/main/Screenshots_Vid/WhatsApp%20Image3.jpeg" width="200">
   <img src="https://github.com/rasel3413/GitHub-Repository-Explorer/blob/main/Screenshots_Vid/WhatsApp%20Image2.jpeg" alt="Image 2" width="200">
  <img src="https://github.com/rasel3413/GitHub-Repository-Explorer/blob/main/Screenshots_Vid/WhatsApp4.jpeg" alt="Image 1" width="200">

  <img src="https://github.com/rasel3413/GitHub-Repository-Explorer/blob/main/Screenshots_Vid/WhatsApp5.jpeg" alt="Image 3" width="200">

</p>



https://github.com/rasel3413/GitHub-Repository-Explorer/assets/50762184/06eae23c-4461-4afa-a7aa-d95d535f2c4f



## Futurescope

The GitHub Repository Explorer project has a solid foundation, and there are several potential enhancements and features that could be explored in the future. Some of the potential areas for future development include:

1. **User Authentication:** Implement user authentication to allow users to access personalized features such as saving favorite repositories or managing their search history.

2. **Advanced Sorting Options:** Introduce more sorting options based on different criteria, providing users with greater flexibility in organizing search results.

3. **Detailed Repository Information:** Enhance the repository details page to display additional information such as contributors, issues, and pull requests.

4. **User Feedback and Analytics:** Implement a system for collecting user feedback and analytics to gain insights into user behavior and preferences, enabling continuous improvement.


These are just a few ideas, and the project can evolve based on user feedback and emerging trends in mobile app development.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
