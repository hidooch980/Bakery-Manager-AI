# 🥖 Bakery Manager AI

سیستم جامع مدیریت نانوایی — شامل پنل وب، سرور API و اپلیکیشن موبایل

## امکانات

- 📊 داشبورد مدیریتی و گزارش درآمد و هزینه
- 🛒 ثبت فروش، شیفت فروش و مدیریت بدهی فروشنده‌ها
- 🍞 مدیریت نوع نان، تولید و کنترل وزن چانه
- 🌾 خرید آرد، مدیریت انبار و مواد اولیه
- 💰 صندوق، حقوق و دستمزد و تحلیل هزینه
- 👥 مدیریت کارکنان، کاربران و نقش‌ها
- 🤖 هوش مصنوعی: پیش‌بینی تقاضا، تحلیل تولید و چت‌بات مدیریتی فارسی
- 📱 اپ موبایل Flutter با حالت آفلاین و ارسال گزارش به پیام‌رسان بله

## ساختار پروژه

| پوشه | توضیح |
|---|---|
| `frontend/` | پنل وب — React + TypeScript + Vite |
| `backend/` | سرور API — NestJS + Prisma + PostgreSQL |
| `mobile/` | اپلیکیشن موبایل — Flutter |

## اجرای سریع (Docker)

پیش‌نیاز: Docker Desktop

```bash
docker compose up --build
```

- Backend: http://localhost:3000
- Frontend: http://localhost:5173
- Postgres: `localhost:5432`

### کاربر مدیر پیش‌فرض (Seed)

- شماره موبایل: `09000000000`
- رمز عبور: `Admin@123`

## ساخت APK موبایل

```bash
cd mobile
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://YOUR-DOMAIN
```

خروجی: `mobile/build/app/outputs/flutter-apk/app-release.apk`

> روی Emulator اندروید آدرس API معمولاً `http://10.0.2.2:3000` است و روی گوشی واقعی، IP کامپیوتر در شبکه.

## نکات انتشار

- برای انتشار عمومی حتماً HTTPS فعال شود.
- برای نسخه release موبایل، keystore اختصاصی بسازید و از debug signing استفاده نکنید.
