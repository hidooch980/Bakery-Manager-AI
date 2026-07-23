# Bakery Manager AI — Backend

سرور API مدیریت نانوایی، ساخته‌شده با **NestJS + Prisma + PostgreSQL**.

## اجرا (لوکال)

```bash
npm install
npx prisma migrate dev
npm run start:dev
```

متغیرهای محیطی (مثل `DATABASE_URL`) را در فایل `.env` تنظیم کنید.

> ساده‌ترین راه اجرا: از ریشه پروژه `docker compose up --build` (دیتابیس، بک‌اند و فرانت با هم بالا می‌آیند).

## دستورات

| دستور | توضیح |
|---|---|
| `npm run start:dev` | اجرای محیط توسعه (watch) |
| `npm run build` | ساخت نسخه production |
| `npm run start:prod` | اجرای نسخه production |
| `npm run test` | تست‌های unit |
| `npm run test:e2e` | تست‌های e2e |
| `npm run lint` | بررسی و اصلاح کد |

## ماژول‌های اصلی

احراز هویت و نقش‌ها، فروش و شیفت فروش، تولید و کنترل وزن چانه، نوع نان، خرید آرد و انبار، صندوق، حقوق و دستمزد، گزارش مالی، مدیریت شعب، اعلان‌ها و ماژول‌های هوش مصنوعی (پیش‌بینی، تحلیل تولید و مشاور).
