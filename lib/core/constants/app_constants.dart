class AppConstants {
  // Supabase configuration - Gunakan URL dan key dari project Supabase yang sudah dibuat
  static const String supabaseUrl = 'https://vwepxxxsvosecbzxekcb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3ZXB4eHhzdm9zZWNienhla2NiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY1NjcyMzUsImV4cCI6MjAzMjE0MzIzNX0.gbTvrQOGPaKxFTN8UQ0CEWr-r_finNVX9a3eLw0qV0Q';
  
  // App settings
  static const String appName = 'Eskulku';
  static const int maxExtracurricularsPerStudent = 3;
  
  // Database table names
  static const String schoolsTable = 'schools';
  static const String studentsTable = 'students';
  static const String extracurricularsTable = 'extracurriculars';
  static const String registrationsTable = 'registrations';
  
  // Extracurricular categories
  static const List<String> eskulsCategories = [
    'Olahraga',
    'Seni',
    'Akademik',
    'Keagamaan',
    'Organisasi',
    'Lainnya',
  ];
  
  // Schedule days
  static const List<String> scheduleDays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
} 