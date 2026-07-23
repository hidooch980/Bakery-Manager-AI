# راه‌اندازی سریع پروژه (لوکال با Docker)

## پیش‌نیاز
- Docker Desktop روی ویندوز

## اجرا
در ریشه پروژه:

```bash
docker compose up --build
```

- Backend: http://localhost:3000
- Frontend: http://localhost:5173
- Postgres: localhost:5432

## کاربر مدیر (Seed)
با اجرای اولیه، یک کاربر مدیر ساخته می‌شود:
- phone: `09000000000`
- password: `Admin@123`

## نکته برای موبایل
اگر روی Emulator اندروید هستی، آدرس API معمولاً:
- `http://10.0.2.2:3000`

روی گوشی واقعی:
- `http://IP-کامپیوتر-تو-شبکه:3000`

