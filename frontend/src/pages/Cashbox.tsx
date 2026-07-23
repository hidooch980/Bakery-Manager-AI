import { useEffect, useState } from 'react';
import api from '../api/client';

type CashboxEntry = {
  id: string;
  balance: number;
  createdAt: string;
};

export default function Cashbox() {
  const [entries, setEntries] = useState<CashboxEntry[]>([]);
  const [amount, setAmount] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/cashbox').then((res) => setEntries(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  const currentBalance = entries.length > 0 ? entries[0].balance : 0;

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!amount) {
      setError('مبلغ الزامی است');
      return;
    }
    try {
      await api.post('/cashbox', { balance: Number(amount) });
      setAmount('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  return (
    <div>
      <h2>صندوق</h2>

      <div className="stat-grid">
        <div className="stat-card">
          <div className="label">موجودی فعلی صندوق</div>
          <div className="value">{currentBalance.toLocaleString('fa-IR')}</div>
        </div>
      </div>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, alignItems: 'flex-end' }}>
        <input placeholder="موجودی جدید صندوق" type="number" value={amount} onChange={(e) => setAmount(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>موجودی</th>
            <th>تاریخ ثبت</th>
          </tr>
        </thead>
        <tbody>
          {entries.map((e) => (
            <tr key={e.id}>
              <td>{e.balance.toLocaleString('fa-IR')}</td>
              <td>{new Date(e.createdAt).toLocaleDateString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
