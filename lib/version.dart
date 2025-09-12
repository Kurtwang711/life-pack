// Version information for Lifepack
class AppVersion {
  static const String version = '1.4.5';
  static const int buildNumber = 5;
  static const String releaseDate = '2025-01-12';
  static const String codeName = 'Asset Management Beta';

  // Known issues in this version
  static const List<String> knownIssues = [
    'Asset creation causes app crash after confirmation',
    'State management conflict in asset dialog',
    'Data persistence not implemented',
  ];

  // Features added in this version
  static const List<String> newFeatures = [
    '18 types of asset clue cards',
    'Professional prompts for each asset type',
    'Legal guidance and explanations',
    'Unified asset card interface',
    'Asset detail preview functionality',
    'Editable notes for assets',
    'Legal disclaimer notices',
  ];

  // Bug fixes in this version
  static const List<String> bugFixes = [
    'Improved dialog state management',
    'Optimized data passing mechanism',
    'Enhanced controller lifecycle management',
  ];

  static String get fullVersion => '$version+$buildNumber';

  static String get versionInfo =>
      '''
Lifepack $version ($codeName)
Build: $buildNumber
Release Date: $releaseDate

⚠️  Known Issues: ${knownIssues.length}
✅ New Features: ${newFeatures.length}  
🔧 Bug Fixes: ${bugFixes.length}
''';
}
