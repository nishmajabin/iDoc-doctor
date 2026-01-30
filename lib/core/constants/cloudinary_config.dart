class CloudinaryConfig {
  // Replace these with your actual Cloudinary credentials
  static const String cloudName = 'dwykvyw5l';
  static const String apiKey = '589414838311383';
  static const String apiSecret = 'CK9K0ly22wnp3ZSIqw0ZYmWZq_w';
  static const String uploadPreset = 'doctor_files_presets'; // Optional: for unsigned uploads
  
  // Cloudinary URLs
  static const String baseUrl = 'https://api.cloudinary.com/v1_1';
  static String get uploadUrl => '$baseUrl/$cloudName/auto/upload';
  
  // Folders for organization
  static const String licensesFolder = 'doctor_licenses';
  static const String profilesFolder = 'doctor_profiles';
}