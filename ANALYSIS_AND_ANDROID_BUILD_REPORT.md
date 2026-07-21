# گزارش تحلیل و اصلاح پروژه Bakery Manager AI

## نتیجه کلی
پروژه شامل سه بخش است:

- `backend`: بک‌اند NestJS + Prisma
- `frontend`: پنل وب React/Vite
- `mobile`: اپلیکیشن Flutter برای Android/iOS/Web/Desktop

تمرکز اصلی روی آماده‌سازی نسخه اندروید و رفع خطاهای مانع اجرا/ساخت بود.

## مشکلات مهم شناسایی‌شده و اصلاح‌شده

### موبایل / Flutter
1. **منوی اصلی فقط متن placeholder نشان می‌داد**
   - تب‌ها به صفحات واقعی `DashboardScreen`، `SellerScreen`، `ProductionScreen`، `ReportScreen` و `SettingsScreen` وصل شد.

2. **ثبت فروش بدون Authorization ارسال می‌شد**
   - `SalesService` اصلاح شد تا برای endpoint فروش از متد authenticated استفاده کند.

3. **ناسازگاری نقش‌ها بین موبایل و بک‌اند**
   - بک‌اند نقش‌ها را با حروف بزرگ مثل `MANAGER` و `SELLER` برمی‌گرداند، ولی موبایل با lowercase چک می‌کرد.
   - `PermissionService` اصلاح شد و نقش‌های `MANAGER`، `ADMIN`، `SELLER`، `DOUGH_MAKER`، `DOUGH_DIVIDER` را پشتیبانی می‌کند.

4. **داشبورد با ساختار خروجی بک‌اند ناسازگار بود**
   - بک‌اند داده‌ها را داخل `today` و `inventory` برمی‌گرداند، ولی موبایل دنبال کلیدهای flat بود.
   - `DashboardScreen` اصلاح شد.

5. **سیستم آپدیت APK لینک اشتباه به دانلودر می‌داد**
   - به‌جای URL فایل APK، tag/version ارسال می‌شد.
   - `UpdateManager` و `UpdateCard` اصلاح شدند تا URL واقعی APK از GitHub Release استخراج و استفاده شود.

6. **مجوز نصب APK دانلودشده وجود نداشت**
   - `REQUEST_INSTALL_PACKAGES` به Manifest اضافه شد.

7. **دو MainActivity با package متفاوت وجود داشت**
   - فایل تکراری `com/example/mobile/MainActivity.kt` حذف شد تا namespace/package اشتباه ایجاد نکند.

8. **آدرس API در موبایل hard-code بود**
   - `ApiService` حالا از `--dart-define=API_BASE_URL=...` پشتیبانی می‌کند و مقدار پیش‌فرض همان IP فعلی پروژه است.

### بک‌اند / NestJS
1. **`crypto.randomUUID()` بدون import قابل‌اعتماد استفاده شده بود**
   - با import صحیح `randomUUID` از `crypto` اصلاح شد.

2. **Global guard و CORS چند بار تکرار شده بود**
   - موارد تکراری حذف شد.

3. **RolesGuard عملاً کاربر JWT را از درخواست نمی‌خواند**
   - Guard اصلاح شد تا Bearer JWT را verify کند و `request.user` را تنظیم کند.

4. **کاربر seed با نقش `ADMIN` ساخته می‌شد ولی بسیاری از کنترلرها `MANAGER` می‌خواستند**
   - seed به نقش `MANAGER` تغییر کرد.

5. **workflow اندروید از مسیر اشتباه اجرا می‌شد**
   - workflow جدید `.github/workflows/android-build-fixed.yml` اضافه شد که دستورات را در پوشه `mobile` اجرا می‌کند.

## وضعیت خروجی اندروید
در این محیط sandbox، Flutter و Dart نصب نیستند:

```text
flutter: command not found
dart: command not found
```

بنابراین امکان تولید مستقیم فایل APK داخل همین محیط وجود نداشت. با این حال پروژه اصلاح‌شده آماده ساخت APK است و workflow مخصوص ساخت اندروید نیز داخل ZIP قرار داده شده است.

## دستور ساخت APK روی سیستم دارای Flutter

```bash
cd mobile
flutter pub get
flutter analyze
flutter build apk --release --dart-define=API_BASE_URL=http://185.97.118.255:3000
```

خروجی APK:

```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```

## دستور ساخت با GitHub Actions
1. ZIP اصلاح‌شده را در repository قرار دهید یا تغییرات را push کنید.
2. در GitHub به تب **Actions** بروید.
3. workflow با نام **Android APK Build Fixed** را اجرا کنید.
4. APK از بخش Artifacts قابل دانلود خواهد بود.

## نکات انتشار نهایی
- برای انتشار رسمی، `applicationId` را از `com.example.bakery_manager_ai` به شناسه اختصاصی تغییر دهید.
- signing release هنوز debug است؛ برای انتشار باید keystore اختصاصی تنظیم شود.
- API فعلاً HTTP است و `usesCleartextTraffic=true` فعال است؛ برای تولید بهتر است HTTPS فعال شود.
- چند سرویس/صفحه هنوز حالت نیمه‌کامل یا placeholder دارند و برای نسخه تجاری باید تکمیل شوند.
