# گزارش فاز D — ویرایش/دلتریم پیشرفته کارکنان + ویرایش/حذف محصول

تاریخ: 2026-07-23

فاز A: اصلاح و لینک API (`API_LINK_FIX_REPORT.md`)
فاز B: چرخه احراز هویت + فروش/تولید/هزینه (`PHASE_B_REPORT.md`)
فاز C: محصولات/کارکنان/تحلیل (`PHASE_C_REPORT.md`)
فاز D: این گزارش

---

## ✅ بک‌اند — ویرایش/حذف محصول (قبلاً وجود نداشت)

### `backend/src/products/products.controller.ts` + `products.service.ts`
- افزوده شد: `PATCH /products/:id` (ویرایش نام/قیمت/موجودی)
- افزوده شد: `DELETE /products/:id` (حذف محصول)

---

## ✅ فرانت‌اند — بهبود صفحات

### محصولات (`/products`)
- هر ردیف جدول دو دکمه دارد: ✉️ ویرایش (نام/قیمت/موجودی به‌صورت اینلاین) و 🧹 دکمه حذف (با تایید)

### کارکنان (`/employees`)
- برای هر کارمند دکمه‌ای باز می‌شود با سه تب: 💵حقوق، 💸مرسولی/پیش، 🧾بدهی
- ثبت حقوق: ماه + مبلغ → `POST /employees/salary`
- ثبت مرسولی/پیش حقوق: یادداشت + مبلغ → `POST /employees/advance`
- ثبت بدهی کارمند به نانوایی: یادداشت + مبلغ → `POST /employees/debt`

---

## 🔒 توضیح امنیت (HTTPS) برای انتشار واقعی

docker-compose فعلی فقط برای محیط dev مناسب است (بدون HTTPS). برای انتشار واقعی روی یک دامنه:

1. یک رکورد-پروکسی (مثلاً **Caddy** یا **nginx + certbot**) روی پورت 443 قرار بدهید که درخواست‌ها را به سرویس `frontend` (پورت 5173) و `backend` (پورت 3000) فوروارد کند.
2. ساده‌ترین راه: افزودن سرویس Caddy به docker-compose:
   ```yaml
   caddy:
     image: caddy:2
     ports: ["80:80", "443:443"]
     volumes:
       - ./Caddyfile:/etc/caddy/Caddyfile
       - caddy_data:/data
   ```
   و یک `Caddyfile` با محتوای:
   ```
   yourdomain.com {
     reverse_proxy /api/* backend:3000
     reverse_proxy frontend:5173
   }
   ```
   Caddy به‌صورت خودکار گواهی Let's Encrypt می‌گیرد (نیاز به دامنه واقعی و پورت‌های باز 80/443 دارد).
3. برای موبایل (Flutter): `API_BASE_URL` باید `https://yourdomain.com` شود.
4. `JWT_SECRET` و رمز دیتابیس در محیط production باید توسط متفیرهای محیطی قوی تر جایگزین شوند (مقدار فعلی `change_me_in_production` امن نیست).

> این بخش فقط راهنما است؛ چون راه‌اندازی امن واقعی نیازمند دامنه واقعی و گواهی SSL است، در محیط sandbox این قسمت پیاده‌سازی نشد.

---

## ▶️ تست سریع

```bash
docker compose up --build
# http://localhost:5173 — ورود: 09000000000 / Admin@123
```

## 📌 پیشنهاد فاز E
- مدیریت دسته‌بندی محصولات و شعب (branch)
- گزارش‌گیری PDF/اکسل از گزارش‌های روزانه/ماهانه
- اتصال برنامه موبایل (Flutter) به همین endpointهای جدید
