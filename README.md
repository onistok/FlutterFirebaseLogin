# Flutter Firebase Login

Flutter Tüm  Login İşlemleri ve Firebase

## Getting Started

Projeyi kendi dizininize çektikten sonra tüm proje kapsamında com.login.flutter yazan tüm dosyalardaki değeri tek seferde değiştirmek için. Android Studio ile projeyi açın.

Ardından Sol tarafta bulunan proje ağacının en tepesindeki flutterlogin dizinine sağ tıklayarak Replace in Path.. seçeneğine tıklayın. Açılan ekranda com.login.flutter yazan yerleri kendi proje bilgileriniz ile değiştirecek değerleri girin ve Replace All butonuna basın. ( bu kısım firebase entegrasyonu için önemlidir. )

Daha sonra Firebase ile bir proje oluşturun, https://console.firebase.google.com/

Projeyi oluştururken hem android hemde ios için işlem adımlarını tamamlanyın. Sizden biraz önce değiştirdiğiniz proje uzantısını isteyecektir. com.benim.projem gibi.

Firebase size hem android hem ios için 1 er dosya verecek. Bu dosyaları:
Android için android/app klasörünün altına
IOS için ios/Runner klasörünün altına kopyalayın.

Konsola:
flutter pub get

yazıp işlemini yaptıktan sonra. projeyi emülatörünüzde Run diyerek başlatabilirsiniz.

İlk Build işlemi paketler yükleneceği için biraz uzun sürebilir.

Projeyi IOS içinde çalışır hale getirmek için 1 defa Xcode ile projenize Run işlemi yapınız.
