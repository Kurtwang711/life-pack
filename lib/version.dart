// Version information for Lifepack
class AppVersion {
  static const String version = '1.4.6';
  static const int buildNumber = 6;
  static const String releaseDate = '2025-01-13';
  static const String codeName = 'Asset Management Stable';

  // Known issues in this version
  static const List<String> knownIssues = [
    // All major issues have been fixed
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
    'Fixed asset creation crash issue',
    'Resolved state management conflicts in dialogs',
    'Implemented data persistence with SharedPreferences',
    'Fixed controller lifecycle management',
    'Added automatic data loading on app start',
    'Ensured data saving after all operations',
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
