// Version information for Lifepack
class AppVersion {
  static const String version = '1.4.7';
  static const int buildNumber = 7;
  static const String releaseDate = '2025-01-13';
  static const String codeName = 'Asset Management Fixed';

  // Known issues in this version
  static const List<String> knownIssues = [
    // All known issues have been resolved
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
    'Fixed Flutter framework assertion error (_dependents.isEmpty)',
    'Resolved widget lifecycle management issues',
    'Fixed TextEditingController disposal problems',
    'Created independent AssetClueDialog component',
    'Improved error handling and user feedback',
    'Added loading states to prevent duplicate submissions',
    'Optimized state management for dialogs',
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
