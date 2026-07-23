import { useEffect, useState } from 'react';
import api from '../api/client';

const CATEGORIES = [
  { value: 'SALT', label: 'نمک' },
  { value: 'DOUGH', label: 'خمیر/خمیرمایه' },
  { value: 'DIESEL', label: 'گازوئیل' },
  { value: 'GAS', label: 'گاز' },
  { value: 'MISC', label: 'متفرقه' },
];

function categoryLabel(value?: string | null) {
  return CATEGORIES.find((c) => c.value === value)?.label || value || '-';
}

export default function Expenses() {
  const [expenses, setExpenses] = useState<any[]>([]);
  const [title, setTitle] = useState('');
  const [amount, setAmount] = useState('');
  const [category, setCategory] = useState('MISC');
  const [error, setError] = useState('');

  function load() {
    api.get('/expenses').then((res) => setExpenses(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!title || !amount) {
      setError('عنوان و مبلغ الزامی است');
      return;
    }
    try {
      await api.post('/expenses', { title, amount: Number(amount), category });
      setTitle('');
      setAmount('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  const totalsByCategory = CATEGORIES.map((c) => ({
    ...c,
    total: expenses
      .filter((e) => e.category === c.value)
      .reduce((s, e) => s + (e.amount || 0), 0),
  }));

  return (
    <div>
      <h2>هزینه‌ها</h2>

      <div className="stat-grid" style={{ marginBottom: 20 }}>
        {totalsByCategory.map((c) => (
          <div className="stat-card" key={c.value}>
            <div className="label">{c.label}</div>
            <div className="value">{c.total.toLocaleString('fa-IR')}</div>
          </div>
        ))}
      </div>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="عنوان هزینه" value={title} onChange={(e) => setTitle(e.target.value)} />
        <input placeholder="مبلغ" type="number" value={amount} onChange={(e) => setAmount(e.target.value)} />
        <select value={category} onChange={(e) => setCategory(e.target.value)}>
          {CATEGORIES.map((c) => (
            <option key={c.value} value={c.value}>{c.label}</option>
          ))}
        </select>
        <button className="btn-primary" type="submit">ثبت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>عنوان</th>
            <th>دسته‌بندی</th>
            <th>مبلغ</th>
          </tr>
        </thead>
        <tbody>
          {expenses.map((e) => (
            <tr key={e.id}>
              <td>{e.title}</td>
              <td>{categoryLabel(e.category)}</td>
              <td>{e.amount?.toLocaleString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
