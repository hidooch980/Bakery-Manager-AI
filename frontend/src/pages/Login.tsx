import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';

export default function Login() {
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    try {
      await login(phone, password);
      navigate('/');
    } catch {
      setError('شماره موبایل یا رمز اشتباه است');
    }
  }

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh' }}>
      <form onSubmit={submit} className="card" style={{ width: 320 }}>
        <h2 style={{ textAlign: 'center' }}>🍞 ورود</h2>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: 20 }}>
          <input placeholder="شماره موبایل" value={phone} onChange={(e) => setPhone(e.target.value)} />
          <input placeholder="رمز عبور" type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
          {error && <div style={{ color: 'var(--danger)' }}>{error}</div>}
          <button className="btn-primary" type="submit">ورود</button>
        </div>
      </form>
    </div>
  );
}
