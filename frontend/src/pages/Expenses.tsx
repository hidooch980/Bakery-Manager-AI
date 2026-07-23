import { useEffect, useState } from 'react';
import api from '../api/client';

export default function Expenses() {
  const [expenses, setExpenses] = useState<any[]>([]);
  const [title, setTitle] = useState('');
  const [amount, setAmount] = useState('');

  function load() {
    api.get('/expenses').then((res) => setExpenses(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await api.post('/expenses', { title, amount: Number(amount) });
    setTitle('');
    setAmount('');
    load();
  }

  return (
    <div>
      <h2>هزینه‌ها</h2>
      <form onSubmit={submit} className="card" style={{ marginBottom: 20 }}>
        <input placeholder="عنوان" value={title} onChange={(e) => setTitle(e.target.value)} />
        <input placeholder="مبلغ" value={amount} onChange={(e) => setAmount(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>عنوان</th>
            <th>مبلغ</th>
          </tr>
        </thead>
        <tbody>
          {expenses.map((e) => (
            <tr key={e.id}>
              <td>{e.title}</td>
              <td>{e.amount?.toLocaleString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
