class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'WaitMate';
  static const String appSlogan = 'Daha az bekle, daha çok yaşa.';

  // Splash
  static const String splashLoading = 'Servisler yükleniyor...';

  // Onboarding
  static const String onboardingSkip = 'Atla';
  static const String onboardingNext = 'İleri';
  static const String onboardingStart = 'Başla';
  static const List<Map<String, String>> onboardingSlides = [
    {
      'title': 'Gerçek Zamanlı\nKuyruk Takibi',
      'desc':
          'Tahmin yürütme devri kapandı. Konumunu ve tahmini bekleme süresini anlık olarak gör.',
      'icon': '📍',
    },
    {
      'title': 'AI Asistan\nHer An Yanında',
      'desc':
          'Sorularını sor, randevuları yönet ve kuyruğu anında takip et – AI asistanın her zaman hazır.',
      'icon': '🤖',
    },
    {
      'title': 'Beklerken\nEğlen',
      'desc':
          'Mini oyunlarla vakti değerlendir, puan kazan ve sıra geldiğinde bildirim al.',
      'icon': '🎮',
    },
  ];

  // Auth
  static const String login = 'Giriş Yap';
  static const String register = 'Kayıt Ol';
  static const String email = 'E-posta Adresi';
  static const String password = 'Şifre';
  static const String confirmPassword = 'Şifre Tekrar';
  static const String fullName = 'Ad Soyad';
  static const String forgotPassword = 'Şifremi Unuttum';
  static const String welcomeBack = 'Tekrar Hoş Geldiniz';
  static const String loginSubtitle = 'Randevularınızı yönetmek için giriş yapın';
  static const String joinWaitmate = 'WaitMate\'e Katıl';
  static const String joinSubtitle =
      'Bekleme sürelerinizi verimli ve güvenli şekilde yönetmeye başlayın.';
  static const String createAccount = 'Hesap Oluştur';
  static const String continueWithGoogle = 'Google ile devam et';
  static const String noAccount = 'Hesabın yok mu?';
  static const String haveAccount = 'Zaten hesabın var mı?';
  static const String signUp = 'Kayıt Ol';
  static const String signIn = 'Giriş Yap';
  static const String compliantStorage = 'GÜVENLİ VERİ DEPOLAMA';
  static const String hipaaNote =
      'WaitMate, bilgilerinin güvende ve gizli kalmasını taahhüt eder. Tüm veriler şifrelenerek saklanır.';

  // Validation
  static const String fieldRequired = 'Bu alan zorunludur.';
  static const String invalidEmail = 'Geçerli bir e-posta adresi girin.';
  static const String passwordTooShort = 'Şifre en az 8 karakter olmalıdır.';
  static const String passwordMismatch = 'Şifreler eşleşmiyor.';
  static const String minChars = 'Min. 8 karakter';
  static const String repeatPassword = 'Şifreyi tekrar girin';

  // Home
  static const String nearbyFacilities = 'Yakınımdaki Tesisler';
  static const String filterTopRated = 'Top Puanlı';
  static const String filterOpenNow = 'Şu An Açık';
  static const String viewDepartments = 'Bölümleri Gör';
  static const String searchHint = 'İsim veya konum ara...';
  static const String openNow = 'AÇIK';
  static const String closed = 'KAPALI';
  static const String minutesWait = 'dk bekle';

  // Queue
  static const String joinQueue = 'Kuyruğa Katıl';
  static const String leaveQueue = 'Kuyruktan Ayrıl';
  static const String yourPosition = 'Sıranız';
  static const String estimatedWait = 'Tahmini Bekleme';
  static const String confirmJoin = 'Onayla ve Katıl';
  static const String cancel = 'İptal';
  static const String availableNow = 'UYGUN';
  static const String busyNow = 'MEŞGUL';

  // Notifications
  static const String notifications = 'Bildirimler';
  static const String clearAll = 'Tümünü Temizle';
  static const String allTab = 'Tümü';
  static const String unreadTab = 'Okunmamış';
  static const String updatesTab = 'Güncelleme';
  static const String appointmentsTab = 'Randevu';

  // Navigation
  static const String navHome = 'Tesisler';
  static const String navQueue = 'Kuyruk';
  static const String navGames = 'Oyunlar';
  static const String navProfile = 'Profil';

  // Admin
  static const String adminDashboard = 'Yönetici Paneli';
  static const String adminQueue = 'Kuyruk Yönetimi';
  static const String adminFacilities = 'Tesisler';
  static const String adminPersonnel = 'Personel';
  static const String adminReports = 'Raporlar';
  static const String dailyUsers = 'Günlük Kullanıcı';
  static const String activeQueues = 'Aktif Kuyruk';
  static const String avgWaitTime = 'Ort. Bekleme';
  static const String totalCompleted = 'Tamamlanan';
}
