import { useEffect, useState } from 'react';
import api from '../api/client';

type Employee = {
  id: string;
  name: string;
  role: string;
  salaries: { id: string; month: string; amount: number; paid: boolean }[];
  advances: { id: string; amount: number; note?: string }[];
  debts: { id: string; amount: number; note?: string; paid: boolean }[];
};

export default function Payroll() {
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [selectedId, setSelectedId] = useState('');
  const [type, setType] = useState<'salary' | 'advance' | 'debt'>('salary');
  const [amount, setAmount] = useState('');
  const [month, setMonth] = useState('');
  const [note, setNote] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/employees').then((res) => setEmployees(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!selectedId || !amount) {
      setError('انتخاب کارمند و مبلغ الزامی است');
      return;
    }
    try {
      if (type === 'salary') {
        await api.post('/employees/salary', {
          employeeId: selectedId,
          amount: Number(amount),
          month: month || new Date().toLocaleDateString('fa-IR', { year: 'numeric', month: 'long' }),
        });
      } else if (type === 'advance') {
        await api.post('/employees/advance', {
          employeeId: selectedId,
          amount: Number(amount),
          note,
        });
      } else {
        await api.post('/employees/debt', {
          employeeId: selectedId,
          amount: Number(amount),
          note,
        });
      }
      setAmount('');
      setMonth('');
      setNote('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  const selected = employees.find((e) => e.id === selectedId);

  return (
    <div>
      <h2>حقوق و دستمزد</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <select value={selectedId} onChange={(e) => setSelectedId(e.target.value)}>
          <option value="">انتخاب کارمند</option>
          {employees.map((emp) => (
            <option key={emp.id} value={emp.id}>{emp.name}</option>
          ))}
        </select>

        <select value={type} onChange={(e) => setType(e.target.value as any)}>
          <option value="salary">حقوق</option>
          <option value="advance">مساعده</option>
          <option value="debt">بدهی</option>
        </select>

        <input placeholder="مبلغ" type="number" value={amount} onChange={(e) => setAmount(e.target.value)} />

        {type === 'salary' && (
          <input placeholder="ماه (مثلاً مهر ۱۴۰۴)" value={month} onChange={(e) => setMonth(e.target.value)} />
        )}
        {type !== 'salary' && (
          <input placeholder="توضیح (اختیاری)" value={note} onChange={(e) => setNote(e.target.value)} />
        )}

        <button className="btn-primary" type="submit">ثبت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table style={{ marginBottom: 24 }}>
        <thead>
          <tr>
            <th>نام</th>
            <th>نقش</th>
            <th>مجموع حقوق</th>
            <th>مجموع مساعده</th>
            <th>مجموع بدهی</th>
          </tr>
        </thead>
        <tbody>
          {employees.map((emp) => (
            <tr
              key={emp.id}
              onClick={() => setSelectedId(emp.id)}
              style={{ cursor: 'pointer', background: emp.id === selectedId ? 'var(--surface-2)' : undefined }}
            >
              <td>{emp.name}</td>
              <td>{emp.role}</td>
              <td>{emp.salaries.reduce((s, x) => s + x.amount, 0).toLocaleString('fa-IR')}</td>
              <td>{emp.advances.reduce((s, x) => s + x.amount, 0).toLocaleString('fa-IR')}</td>
              <td>{emp.debts.reduce((s, x) => s + x.amount, 0).toLocaleString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>

      {selected && (
        <div className="card">
          <div className="label" style={{ marginBottom: 10 }}>جزئیات {selected.name}</div>

          <div style={{ marginBottom: 12 }}>
            <strong style={{ fontSize: 13 }}>حقوق‌ها</strong>
            {selected.salaries.length === 0 && <div style={{ fontSize: 13, color: 'var(--text-dim)' }}>موردی ثبت نشده</div>}
            {selected.salaries.map((s) => (
              <div key={s.id} style={{ fontSize: 13, color: 'var(--text-dim)' }}>
                {s.month}: {s.amount.toLocaleString('fa-IR')} — {s.paid ? 'پرداخت‌شده' : 'پرداخت‌نشده'}
              </div>
            ))}
          </div>

          <div style={{ marginBottom: 12 }}>
            <strong style={{ fontSize: 13 }}>مساعده‌ها</strong>
            {selected.advances.length === 0 && <div style={{ fontSize: 13, color: 'var(--text-dim)' }}>موردی ثبت نشده</div>}
            {selected.advances.map((a) => (
              <div key={a.id} style={{ fontSize: 13, color: 'var(--text-dim)' }}>
                {a.amount.toLocaleString('fa-IR')} {a.note ? `— ${a.note}` : ''}
              </div>
            ))}
          </div>

          <div>
            <strong style={{ fontSize: 13 }}>بدهی‌ها</strong>
            {selected.debts.length === 0 && <div style={{ fontSize: 13, color: 'var(--text-dim)' }}>موردی ثبت نشده</div>}
            {selected.debts.map((d) => (
              <div key={d.id} style={{ fontSize: 13, color: 'var(--text-dim)' }}>
                {d.amount.toLocaleString('fa-IR')} — {d.paid ? 'تسویه‌شده' : 'تسویه‌نشده'} {d.note ? `— ${d.note}` : ''}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
