# Bakery Manager AI - Fixed Package

این نسخه توسط Notion AI بررسی و چند خطای مهم آن اصلاح شد.

## تغییرات اصلی
- اصلاح سرویس API موبایل: مدیریت خطای بهتر، پشتیبانی از `Authorization`، متدهای `POST/PATCH` عمومی.
- اصلاح ثبت فروش در موبایل: ارسال توکن برای endpoint فروش.
- اصلاح کنترل دسترسی نقش‌ها: هماهنگ‌سازی نقش‌های uppercase بک‌اند با موبایل.
- اصلاح منوی اصلی موبایل: اتصال تب‌ها به صفحات واقعی به‌جای placeholder.
- اصلاح داشبورد موبایل: سازگاری با خروجی nested بک‌اند (`today`, `inventory`).
- اصلاح فرآیند آپدیت APK از GitHub: پاس دادن لینک APK به دانلودر، نه tag نسخه.
- اضافه شدن مجوز `REQUEST_INSTALL_PACKAGES` برای نصب APK دانلودشده.
- حذف MainActivity تکراری با package اشتباه.
- اصلاح بک‌اند: import صحیح `randomUUID`، حذف guard/CORS تکراری، اصلاح URL سرویس Bale.
- اصلاح RolesGuard بک‌اند: خواندن Bearer JWT و جلوگیری از رد شدن همه APIهای دارای نقش.
- اصلاح workflow ساخت APK: اجرای دستورات از پوشه `mobile`.
- اصلاح seed: ساخت کاربر اولیه با نقش `MANAGER` مطابق دسترسی کنترلرها.

## ساخت APK
محیط فعلی Flutter/Dart نصب ندارد؛ بنابراین APK داخل همین sandbox ساخته نشد. برای ساخت روی سیستم یا GitHub Actions:

```bash
cd mobile
flutter pub get
flutter analyze
flutter build apk --release --dart-define=API_BASE_URL=http://185.97.118.255:3000
```

خروجی در مسیر زیر قرار می‌گیرد:

```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```

## نکات مهم قبل از انتشار
- اگر برای انتشار عمومی است، `applicationId` را از `com.example.bakery_manager_ai` به شناسه اختصاصی تغییر دهید.
- برای release واقعی، keystore اختصاصی بسازید و از debug signing استفاده نکنید.
- API هنوز HTTP است؛ برای انتشار بهتر است HTTPS فعال شود و `usesCleartextTraffic` حذف گردد.


## بروزرسانی کامل v1.1.0 Stable
- نسخه موبایل آفلاین‌محور و پایدار اضافه شد.
- فروش نقدی/کارت/نسیه، تولید، آرد، هزینه، گزارش، خروجی CSV، AI و تنظیمات نانوایی اضافه شد.
- ورود آفلاین پیش‌فرض: `09000000000` / `Admin@123`.
- applicationId به `com.hidooch980.bakerymanagerai` تغییر کرد.
