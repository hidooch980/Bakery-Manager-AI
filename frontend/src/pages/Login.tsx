import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';
import { Loader2, Lock, Phone } from 'lucide-react';

export default function Login() {
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setSubmitting(true);
    try {
      await login(phone, password);
      navigate('/dashboard');
    } catch (err: any) {
      if (!err?.response) {
        setError('اتصال به سرور برقرار نشد. مطمئن شوید بک‌اند در حال اجراست.');
      } else if (err.response.status === 401) {
        setError('شماره موبایل یا رمز اشتباه است');
      } else {
        setError('خطایی رخ داد. لطفاً دوباره تلاش کنید.');
      }
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="login-shell">
      <div className="login-card">
        <div className="login-brand">
          <span className="login-emoji" aria-hidden>🍞</span>
          <h1>مدیریت نانوایی</h1>
          <p>برای ادامه، وارد حساب کاربری خود شوید</p>
        </div>

        <form onSubmit={submit} className="login-form">
          <label className="field">
            <Phone size={16} />
            <input
              placeholder="شماره موبایل"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              autoComplete="username"
              inputMode="tel"
            />
          </label>

          <label className="field">
            <Lock size={16} />
            <input
              placeholder="رمز عبور"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
            />
          </label>

          {error && <div className="login-error">{error}</div>}

          <button className="btn-primary login-submit" type="submit" disabled={submitting}>
            {submitting ? <Loader2 size={16} className="spin" /> : 'ورود'}
          </button>
        </form>
      </div>
    </div>
  );
}
