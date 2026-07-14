/// Identifiers for portfolio destinations opened from any device layout.
enum PortfolioLink {
  flod,
  curlText,
  contentFlipper,
  mindMap,
  slackClone,
  eChat,
  acta,
  collabix,
  sousVide,
  githubProfile,
  telegram,
  instagram,
  linkedIn,
}

extension PortfolioLinkX on PortfolioLink {
  /// Public URL, or `null` when the destination must not open externally.
  String? get url => switch (this) {
    PortfolioLink.flod => 'https://pub.dev/packages/flod',
    PortfolioLink.curlText => 'https://pub.dev/packages/curl_text',
    PortfolioLink.contentFlipper => 'https://pub.dev/packages/content_flipper',
    PortfolioLink.mindMap => 'https://github.com/leeerrrrmmm/MindMap',
    PortfolioLink.slackClone => 'https://github.com/leeerrrrmmm/Slack-Clone-',
    PortfolioLink.eChat => 'https://github.com/leeerrrrmmm/e-chat',
    PortfolioLink.acta =>
      'https://play.google.com/store/apps/details?id=com.acta.build.life',
    PortfolioLink.collabix => null,
    PortfolioLink.sousVide => null,
    PortfolioLink.githubProfile => 'https://github.com/leeerrrrmmm',
    PortfolioLink.telegram => 'https://t.me/leeerrmmm',
    PortfolioLink.instagram => 'https://www.instagram.com/leeerrrrmmmm/',
    PortfolioLink.linkedIn =>
      'https://www.linkedin.com/in/maksym-mychko-299663339/',
  };

  bool get isPrivateOrInProgress => url == null;

  static PortfolioLink fromProjectTitle(String title) {
    return switch (title) {
      'Collabix' => PortfolioLink.collabix,
      'Sous vide' => PortfolioLink.sousVide,
      'Slack' => PortfolioLink.slackClone,
      'E-CHAT' => PortfolioLink.eChat,
      'Mind Map' => PortfolioLink.mindMap,
      _ => PortfolioLink.collabix,
    };
  }

  static PortfolioLink fromLibraryIndex(int index) {
    return switch (index) {
      0 => PortfolioLink.contentFlipper,
      1 => PortfolioLink.flod,
      2 => PortfolioLink.curlText,
      _ => PortfolioLink.flod,
    };
  }

  static PortfolioLink fromLiveProjectIndex(int index) {
    return switch (index) {
      0 => PortfolioLink.acta,
      _ => PortfolioLink.sousVide,
    };
  }
}
