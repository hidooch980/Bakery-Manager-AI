import { useEffect, useState } from 'react';
import api from '../api/client';

type FlourSaleRow = {
  id: string;
  date: string;
  unit: 'KILO' | 'BAG';
  quantity: number;
  unitPrice: number;
  totalAmount: number;
  note?: string | null;
};

export default function FlourSale() {
  const [rows, setRows] = useState<FlourSaleRow[]>([]);
  const [unit, setUnit] = useState<'KILO' | 'BAG'>('KILO');
  const [quantity, setQuantity] = useState('');
  const [unitPrice, setUnitPrice] = useState('');
  const [note, setNote] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/flour-sale').then((res) => setRows(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  const total = (Number(quantity) || 0) * (Number(unitPrice) || 0);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!quantity || !unitPrice) {
      setError('مقدار و قیمت واحد الزامی است');
      return;
    }
    try {
      await api.post('/flour-sale', {
        unit,
        quantity: Number(quantity),
        unitPrice: Number(unitPrice),
        note,
      });
      setQuantity('');
      setUnitPrice('');
      setNote('');
      load();
    } catch (e: any) {
      setError(e?.response?.data?.message || 'ثبت با خطا مواجه شد');
    }
  }

  const sumTotal = rows.reduce((s, r) => s + r.totalAmount, 0);

  return (
    <div>
      <h2>فروش خرده آرد (کیلویی / کیسه‌ای)</h2>

      <div className="stat-grid" style={{ marginBottom: 20 }}>
        <div className="stat-card">
          <div className="label">مجموع درآمد فروش آرد</div>
          <div className="value">{sumTotal.toLocaleString('fa-IR')}</div>
        </div>
      </div>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <select value={unit} onChange={(e) => setUnit(e.target.value as 'KILO' | 'BAG')}>
          <option value="KILO">فروش کیلویی</option>
          <option value="BAG">فروش کیسه‌ای</option>
        </select>
        <input
          placeholder={unit === 'KILO' ? 'مقدار (کیلوگرم)' : 'تعداد کیسه'}
          type="number"
          value={quantity}
          onChange={(e) => setQuantity(e.target.value)}
        />
        <input
          placeholder={unit === 'KILO' ? 'قیمت هر کیلو' : 'قیمت هر کیسه'}
          type="number"
          value={unitPrice}
          onChange={(e) => setUnitPrice(e.target.value)}
        />
        <input placeholder="توضیح (اختیاری)" value={note} onChange={(e) => setNote(e.target.value)} />
        <div style={{ fontSize: 13, color: 'var(--text-dim)' }}>
          جمع: {total.toLocaleString('fa-IR')}
        </div>
        <button className="btn-primary" type="submit">ثبت فروش</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>تاریخ</th>
            <th>نوع</th>
            <th>مقدار</th>
            <th>قیمت واحد</th>
            <th>جمع</th>
            <th>توضیح</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{new Date(r.date).toLocaleDateString('fa-IR')}</td>
              <td>{r.unit === 'KILO' ? 'کیلویی' : 'کیسه‌ای'}</td>
              <td>{r.quantity}</td>
              <td>{r.unitPrice.toLocaleString('fa-IR')}</td>
              <td>{r.totalAmount.toLocaleString('fa-IR')}</td>
              <td>{r.note ?? '-'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
