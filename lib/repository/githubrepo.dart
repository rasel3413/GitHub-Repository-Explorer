class GitHubRepository {
  final String name;
  final int stars;
  final String ownerLogin;

  GitHubRepository({
    required this.name,
    required this.stars,
    required this.ownerLogin,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      name: json['name'] ?? '',
      stars: json['stargazers_count'] ?? 0,
      ownerLogin: (json['owner'] as Map<String, dynamic>)['login'] ?? '',
    );
  }
}
