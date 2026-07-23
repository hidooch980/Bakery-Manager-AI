# Bakery Manager AI — Mobile

اپلیکیشن موبایل مدیریت نانوایی با **Flutter** — فروش، تولید، گزارش‌ها، حالت آفلاین و ارسال گزارش به پیام‌رسان بله.

## اجرا

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

> روی گوشی واقعی به‌جای `10.0.2.2` از IP کامپیوتر در شبکه استفاده کنید.

## ساخت APK

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://YOUR-DOMAIN
```

خروجی: `build/app/outputs/flutter-apk/app-release.apk`

## ورود آفلاین پیش‌فرض

- شماره موبایل: `09000000000`
- رمز عبور: `Admin@123`

## نکات انتشار

- برای release واقعی keystore اختصاصی بسازید.
- برای انتشار عمومی HTTPS فعال و `usesCleartextTraffic` حذف شود.
