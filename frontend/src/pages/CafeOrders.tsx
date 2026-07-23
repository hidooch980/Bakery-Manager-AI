import { useEffect, useState } from 'react';
import api from '../api/client';

type DiningTable = {
  id: string;
  name: string;
  capacity: number;
  active: boolean;
  busy: boolean;
};

type MenuItem = {
  id: string;
  name: string;
  price: number;
  available: boolean;
};

type OrderItem = {
  id: string;
  quantity: number;
  unitPrice: number;
  menuItem?: { name: string };
};

type CafeOrder = {
  id: string;
  orderNo: number;
  type: string;
  status: string;
  totalAmount: number;
  discount: number;
  paymentMethod?: string | null;
  customerName?: string | null;
  createdAt: string;
  table?: { name: string } | null;
  items: OrderItem[];
};

type Summary = {
  revenue: number;
  paidCount: number;
  discountTotal: number;
  openCount: number;
  canceledCount: number;
};

type CartLine = {
  menuItemId: string;
  name: string;
  price: number;
  quantity: number;
};

const typeLabels: Record<string, string> = {
  DINE_IN: 'داخل سالن',
  TAKEAWAY: 'بیرون‌بر',
  DELIVERY: 'ارسال',
};

const statusLabels: Record<string, string> = {
  OPEN: 'باز',
  PREPARING: 'آماده‌سازی',
  SERVED: 'سرو شد',
  PAID: 'تسویه شد',
  CANCELED: 'لغو شد',
};

export default function CafeOrders() {
  const [tables, setTables] = useState<DiningTable[]>([]);
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [orders, setOrders] = useState<CafeOrder[]>([]);
  const [summary, setSummary] = useState<Summary | null>(null);

  const [tableName, setTableName] = useState('');
  const [capacity, setCapacity] = useState('');

  const [type, setType] = useState('DINE_IN');
  const [tableId, setTableId] = useState('');
  const [customerName, setCustomerName] = useState('');
  const [discount, setDiscount] = useState('');
  const [selectedItem, setSelectedItem] = useState('');
  const [quantity, setQuantity] = useState('1');
  const [cart, setCart] = useState<CartLine[]>([]);
  const [error, setError] = useState('');

  function load() {
    api.get('/cafe/tables').then((res) => setTables(res.data));
    api.get('/cafe/menu-items').then((res) => setMenuItems(res.data));
    api.get('/cafe/orders').then((res) => setOrders(res.data));
    api.get('/cafe/summary').then((res) => setSummary(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function addTable(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!tableName) {
      setError('نام میز الزامی است');
      return;
    }
    try {
      await api.post('/cafe/tables', {
        name: tableName,
        capacity: Number(capacity) || 4,
      });
      setTableName('');
      setCapacity('');
      load();
    } catch {
      setError('ثبت میز با خطا مواجه شد');
    }
  }

  function addToCart() {
    setError('');
    const item = menuItems.find((m) => m.id === selectedItem);
    if (!item) {
      setError('ابتدا یک آیتم منو انتخاب کنید');
      return;
    }
    const qty = Number(quantity) || 1;
    setCart((prev) => {
      const existing = prev.find((l) => l.menuItemId === item.id);
      if (existing) {
        return prev.map((l) =>
          l.menuItemId === item.id ? { ...l, quantity: l.quantity + qty } : l,
        );
      }
      return [...prev, { menuItemId: item.id, name: item.name, price: item.price, quantity: qty }];
    });
    setSelectedItem('');
    setQuantity('1');
  }

  function removeFromCart(menuItemId: string) {
    setCart((prev) => prev.filter((l) => l.menuItemId !== menuItemId));
  }

  const cartTotal = cart.reduce((sum, l) => sum + l.price * l.quantity, 0);
  const payable = Math.max(cartTotal - (Number(discount) || 0), 0);

  async function submitOrder(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (cart.length === 0) {
      setError('حداقل یک آیتم به سفارش اضافه کنید');
      return;
    }
    if (type === 'DINE_IN' && !tableId) {
      setError('برای سفارش داخل سالن انتخاب میز الزامی است');
      return;
    }
    try {
      await api.post('/cafe/orders', {
        type,
        tableId: type === 'DINE_IN' ? tableId : undefined,
        customerName: customerName || undefined,
        discount: Number(discount) || 0,
        items: cart.map((l) => ({ menuItemId: l.menuItemId, quantity: l.quantity })),
      });
      setCart([]);
      setCustomerName('');
      setDiscount('');
      setTableId('');
      load();
    } catch {
      setError('ثبت سفارش با خطا مواجه شد');
    }
  }

  async function setStatus(order: CafeOrder, status: string) {
    await api.patch(`/cafe/orders/${order.id}/status`, { status });
    load();
  }

  async function pay(order: CafeOrder, paymentMethod: string) {
    await api.patch(`/cafe/orders/${order.id}/pay`, { paymentMethod });
    load();
  }

  const isOpen = (s: string) => s === 'OPEN' || s === 'PREPARING' || s === 'SERVED';

  return (
    <div>
      <h2>سفارش کافه و رستوران</h2>

      {summary && (
        <div className="card" style={{ marginBottom: 20, display: 'flex', gap: 24, flexWrap: 'wrap' }}>
          <div>فروش امروز: <b>{summary.revenue.toLocaleString('fa-IR')}</b> تومان</div>
          <div>سفارش تسویه‌شده: <b>{summary.paidCount.toLocaleString('fa-IR')}</b></div>
          <div>سفارش باز: <b>{summary.openCount.toLocaleString('fa-IR')}</b></div>
          <div>جمع تخفیف: <b>{summary.discountTotal.toLocaleString('fa-IR')}</b> تومان</div>
          <div>لغوشده امروز: <b>{summary.canceledCount.toLocaleString('fa-IR')}</b></div>
        </div>
      )}

      <form onSubmit={addTable} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="نام میز (مثلاً میز ۱)" value={tableName} onChange={(e) => setTableName(e.target.value)} />
        <input placeholder="ظرفیت (نفر)" type="number" value={capacity} onChange={(e) => setCapacity(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن میز</button>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {tables.map((t) => (
            <span key={t.id} className="card" style={{ padding: '4px 10px' }}>
              {t.name} · {t.busy ? '🔴 مشغول' : '🟢 آزاد'}
            </span>
          ))}
        </div>
      </form>

      <form onSubmit={submitOrder} className="card" style={{ marginBottom: 20 }}>
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end', marginBottom: 12 }}>
          <select value={type} onChange={(e) => setType(e.target.value)}>
            <option value="DINE_IN">داخل سالن</option>
            <option value="TAKEAWAY">بیرون‌بر</option>
            <option value="DELIVERY">ارسال</option>
          </select>
          {type === 'DINE_IN' && (
            <select value={tableId} onChange={(e) => setTableId(e.target.value)}>
              <option value="">انتخاب میز</option>
              {tables.filter((t) => t.active).map((t) => (
                <option key={t.id} value={t.id}>
                  {t.name}{t.busy ? ' (مشغول)' : ''}
                </option>
              ))}
            </select>
          )}
          <input placeholder="نام مشتری (اختیاری)" value={customerName} onChange={(e) => setCustomerName(e.target.value)} />
          <input placeholder="تخفیف (تومان)" type="number" value={discount} onChange={(e) => setDiscount(e.target.value)} />
        </div>

        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end', marginBottom: 12 }}>
          <select value={selectedItem} onChange={(e) => setSelectedItem(e.target.value)}>
            <option value="">انتخاب آیتم منو</option>
            {menuItems.filter((m) => m.available).map((m) => (
              <option key={m.id} value={m.id}>
                {m.name} — {m.price.toLocaleString('fa-IR')}
              </option>
            ))}
          </select>
          <input placeholder="تعداد" type="number" min={1} value={quantity} onChange={(e) => setQuantity(e.target.value)} style={{ width: 80 }} />
          <button className="btn-ghost" type="button" onClick={addToCart}>افزودن به سفارش</button>
        </div>

        {cart.length > 0 && (
          <table style={{ marginBottom: 12 }}>
            <thead>
              <tr>
                <th>آیتم</th>
                <th>تعداد</th>
                <th>قیمت واحد</th>
                <th>جمع</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {cart.map((l) => (
                <tr key={l.menuItemId}>
                  <td>{l.name}</td>
                  <td>{l.quantity.toLocaleString('fa-IR')}</td>
                  <td>{l.price.toLocaleString('fa-IR')}</td>
                  <td>{(l.price * l.quantity).toLocaleString('fa-IR')}</td>
                  <td>
                    <button className="btn-ghost" type="button" onClick={() => removeFromCart(l.menuItemId)}>حذف</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        <div style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
          <div>جمع: <b>{cartTotal.toLocaleString('fa-IR')}</b> تومان</div>
          <div>قابل پرداخت: <b>{payable.toLocaleString('fa-IR')}</b> تومان</div>
          <button className="btn-primary" type="submit">ثبت سفارش</button>
        </div>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <h3>سفارش‌ها</h3>
      <table>
        <thead>
          <tr>
            <th>شماره</th>
            <th>نوع</th>
            <th>میز / مشتری</th>
            <th>اقلام</th>
            <th>مبلغ</th>
            <th>وضعیت</th>
            <th>عملیات</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((o) => (
            <tr key={o.id}>
              <td>{o.orderNo.toLocaleString('fa-IR')}</td>
              <td>{typeLabels[o.type] || o.type}</td>
              <td>{o.table?.name || o.customerName || '-'}</td>
              <td>
                {o.items.map((i) => `${i.menuItem?.name || ''} ×${i.quantity}`).join('، ')}
              </td>
              <td>{o.totalAmount.toLocaleString('fa-IR')}</td>
              <td>
                {statusLabels[o.status] || o.status}
                {o.status === 'PAID' && o.paymentMethod ? (o.paymentMethod === 'CASH' ? ' (نقدی)' : ' (کارتی)') : ''}
              </td>
              <td>
                {isOpen(o.status) && (
                  <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                    {o.status === 'OPEN' && (
                      <button className="btn-ghost" type="button" onClick={() => setStatus(o, 'PREPARING')}>آماده‌سازی</button>
                    )}
                    {o.status !== 'SERVED' && (
                      <button className="btn-ghost" type="button" onClick={() => setStatus(o, 'SERVED')}>سرو شد</button>
                    )}
                    <button className="btn-ghost" type="button" onClick={() => pay(o, 'CASH')}>تسویه نقدی</button>
                    <button className="btn-ghost" type="button" onClick={() => pay(o, 'CARD')}>تسویه کارتی</button>
                    <button className="btn-ghost" type="button" onClick={() => setStatus(o, 'CANCELED')}>لغو</button>
                  </div>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
