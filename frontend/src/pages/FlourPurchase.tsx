import { useEffect, useState } from 'react';
import api from '../api/client';

type FlourPurchase = {
  id: string;
  purchaseNo: string;
  supplier: string;
  bags: number;
  weight: number;
  price: number;
  transportCost: number;
  totalCost: number;
  paid: boolean;
  note?: string | null;
  createdAt: string;
};

export default function FlourPurchase() {
  const [items, setItems] = useState<FlourPurchase[]>([]);
  const [supplier, setSupplier] = useState('');
  const [bags, setBags] = useState('');
  const [weight, setWeight] = useState('');
  const [price, setPrice] = useState('');
  const [transportCost, setTransportCost] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/flour-purchase').then((res) => setItems(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!supplier || !bags || !weight || !price) {
      setError('تأمین‌کننده، تعداد کیسه، وزن و قیمت الزامی هستند');
      return;
    }
    try {
      await api.post('/flour-purchase', {
        supplierName: supplier,
        bags: Number(bags),
        bagWeight: Number(weight),
        pricePerBag: Number(price),
        transportCost: Number(transportCost) || 0,
      });
      setSupplier('');
      setBags('');
      setWeight('');
      setPrice('');
      setTransportCost('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد. توجه: باید یک قلم کالا با نام دقیق «آرد» در صفحه‌ی انبار تعریف شده باشد.');
    }
  }

  return (
    <div>
      <h2>ثبت خرید آرد</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="تأمین‌کننده" value={supplier} onChange={(e) => setSupplier(e.target.value)} />
        <input placeholder="تعداد کیسه" type="number" value={bags} onChange={(e) => setBags(e.target.value)} />
        <input placeholder="وزن هر کیسه (کیلوگرم)" type="number" value={weight} onChange={(e) => setWeight(e.target.value)} />
        <input placeholder="قیمت هر کیسه" type="number" value={price} onChange={(e) => setPrice(e.target.value)} />
        <input placeholder="هزینه حمل (اختیاری)" type="number" value={transportCost} onChange={(e) => setTransportCost(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت خرید</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>شماره خرید</th>
            <th>تأمین‌کننده</th>
            <th>کیسه</th>
            <th>وزن</th>
            <th>هزینه کل</th>
            <th>پرداخت</th>
            <th>تاریخ</th>
          </tr>
        </thead>
        <tbody>
          {items.map((f) => (
            <tr key={f.id}>
              <td>{f.purchaseNo}</td>
              <td>{f.supplier}</td>
              <td>{f.bags}</td>
              <td>{f.weight}</td>
              <td>{f.totalCost.toLocaleString('fa-IR')}</td>
              <td>{f.paid ? 'پرداخت‌شده' : 'پرداخت‌نشده'}</td>
              <td>{new Date(f.createdAt).toLocaleDateString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
