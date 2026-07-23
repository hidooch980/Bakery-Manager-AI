# گزارش اصلاح پروژه و لینک کردن API

تاریخ: 2026-07-23

## خلاصه
کل زنجیرهٔ اتصال API در سه بخش پروژه (Backend / Frontend / Mobile) بررسی و اصلاح شد.

---

## ✅ Frontend (React + Vite)

### 1. `frontend/vite.config.ts`
- **مشکل:** آدرس پراکسی به‌صورت ثابت `http://backend:3000` بود و فقط داخل Docker کار می‌کرد.
- **اصلاح:** حالا از متغیر محیطی `VITE_API_TARGET` خوانده می‌شود (در docker-compose ست شده) و در حالت توسعهٔ محلی به `http://localhost:3000` برمی‌گردد. یعنی هم داخل Docker و هم خارج از آن کار می‌کند.

### 2. `frontend/src/api/client.ts`
- **اصلاح:** `baseURL` از `VITE_API_URL` قابل تنظیم شد (پیش‌فرض `/api` برای پراکسی dev).
- **افزوده شد:** مدیریت متمرکز خطای 401 — در صورت انقضای توکن، کل سشن پاک و کاربر به صفحهٔ ورود هدایت می‌شود.

### 3. `frontend/src/auth/AuthContext.tsx`
- **مشکل مهم:** تابع `login` کاملاً فیک (Fake) بود — بدون تماس با سرور، هر کاربری را ADMIN می‌کرد!
- **اصلاح:** حالا واقعاً `POST /auth/login` را صدا می‌زند، توکن و اطلاعات کاربر واقعی را ذخیره می‌کند. تایپ‌های TypeScript هم دقیق شدند.

### 4. `frontend/src/pages/Login.tsx`
- **اصلاح:** به جای تماس مستقیم با axios، از `useAuth().login` استفاده می‌کند (یکپارچگی منطق ورود). ورود با کلید Enter هم اضافه شد.

### 5. `frontend/src/pages/RouteGuard.tsx`
- **مشکل:** به مسیر `/` ریدایرکت می‌کرد که وجود نداشت.
- **اصلاح:** ریدایرکت به `/login` + پشتیبانی از لیست نقش‌های مجاز (`roles`).

### 6. `frontend/src/App.tsx`
- مسیر `*` به ریدایرکت تمیز به `/login` تبدیل شد و صفحهٔ `Dashboard` (گزارش ساده) که بلااستفاده بود، روی مسیر `/report` متصل شد.

---

## ✅ Backend (NestJS)

### `backend/src/main.ts`
- پورت از متغیر محیطی `PORT` خوانده می‌شود (مطابق `.env.example`) و لاگ راه‌اندازی اضافه شد.
- مسیرهای استفاده‌شده در فرانت و موبایل بررسی و تأیید شدند:
  - `POST /auth/login` و `POST /auth/register` ✅
  - `GET /daily-report` ✅
  - `GET /bread-type` ✅
  - `GET /dashboard/daily` ✅
  - `GET /production-standards` ✅

---

## ✅ Mobile (Flutter)

### 1. فایل جدید: `mobile/lib/config/api_config.dart`
- **مشکل:** آدرس سرور (`http://185.97.118.255:3000`) در سه فایل مختلف هاردکد شده بود.
- **اصلاح:** آدرس API فقط در یک فایل مرکزی تعریف می‌شود و هنگام build قابل تغییر است:
  ```
  flutter build apk --dart-define=API_BASE_URL=http://YOUR_SERVER:3000
  ```

### 2. `mobile/lib/services/api_service.dart`
- از `ApiConfig.baseUrl` استفاده می‌کند.
- متد `patchData` (با هدر احراز هویت) اضافه شد.

### 3. `mobile/lib/services/report_service.dart`
- **مشکل:** درخواست مستقیم بدون توکن می‌فرستاد ← همیشه خطای 401 می‌گرفت.
- **اصلاح:** از `ApiService` مرکزی با توکن و مدیریت خطا استفاده می‌کند.

### 4. `mobile/lib/services/production_standard_service.dart`
- همان مشکل و همان اصلاح: اتصال از طریق `ApiService` با توکن و مدیریت پاسخ‌های نامعتبر.

---

## 🔗 معماری اتصال API پس از اصلاح

```
Frontend (Vite dev) ── /api ─→ Vite Proxy ─→ VITE_API_TARGET (Docker: http://backend:3000 ، محلی: http://localhost:3000)
Mobile (Flutter)   ── ApiConfig.baseUrl ─→ سرور (قابل تغییر با --dart-define)
Backend (NestJS)   ── پورت از PORT یا 3000 ، CORS فعال ، JWT Guard سراسری
```

## ▶️ راه‌اندازی

```bash
# با Docker (پیشنهادی)
docker compose up --build
# Frontend: http://localhost:5173  —  Backend: http://localhost:3000

# ورود پیش‌فرض (seed):
# موبایل: 09000000000  رمز: Admin@123
```
