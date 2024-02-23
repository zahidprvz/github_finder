# GitHub Finder

GitHub Finder is a cross-platform mobile application built using Flutter & Github API that enables users to search for GitHub users based on their location and access detailed user information.

## Features

- **User Search**: Enter a location query to discover GitHub users residing in that area.
- **Detailed User Profile**: View comprehensive user profiles, including profile picture, name, email, company, location, blog URL, followers count, following count, and number of public repositories.
- **Loading Indicator**: Visual feedback indicates when data is being fetched from the GitHub API, ensuring a smooth user experience.
- **Minimalistic Design**: Intuitive user interface designed for simplicity and ease of use.

## Screenshots

<div align="center">
  <img src="/p1.jpeg" alt="Splash Screen" width="200" hspace="20"/>
  <img src="/p2.jpeg" alt="Search Screen" width="200" hspace="20"/>
  <img src="/p3.jpeg" alt="Loading Indicator" width="200" hspace="20"/>
</div>

<div align="center">
  <img src="/p4.jpeg" alt="Users List" width="200" hspace="20"/>
  <img src="/p5.jpeg" alt="User Details Screen" width="200" hspace="20"/>
</div>

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) and [Dart](https://dart.dev/get-dart) installed on your development machine.
- Android Studio or Visual Studio Code with Flutter extension installed.
- GitHub API Access Token: Obtain a personal access token from GitHub following [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

### Installation

1. Clone the repository to your local machine:

```bash
git clone https://github.com/zahidprvz/github_finder.git
```

2. Navigate to the project directory:

```bash
cd github_finder
```

3. Create a `.env` file in the root directory of the project and add your GitHub API access token:

```
GITHUB_ACCESS_TOKEN=your-access-token-here
```

4. Run the app:

```bash
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs, feature requests, or suggestions you may have.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
