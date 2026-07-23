import { useEffect, useState } from 'react';
import api from '../api/client';

type Summary = {
  income: number;
  salesIncome?: number;
  flourSaleIncome?: number;
  expenses: number;
  salaries: number;
  profit: number;
};

type MonthRow = {
  month: string;
  income: number;
  cash: number;
  card: number;
  expenses: number;
  productionCost: number;
  profit: number;
};

type BalanceSheet = {
  assets: {
    cash: number;
    flourInventoryValue: number;
    sellerReceivable: number;
    employeeReceivable: number;
    total: number;
  };
  liabilities: {
    unpaidExpenses: number;
    unpaidFlourPurchases: number;
    unpaidSalaries: number;
    total: number;
  };
  equity: number;
  note: string;
};

export default function FinancialReport() {
  const [summary, setSummary] = useState<Summary | null>(null);
  const [year, setYear] = useState(1404);
  const [monthly, setMonthly] = useState<MonthRow[]>([]);
  const [balance, setBalance] = useState<BalanceSheet | null>(null);

  useEffect(() => {
    api.get('/financial/daily').then((res) => setSummary(res.data));
    api.get('/financial-report/balance-sheet').then((res) => setBalance(res.data));
  }, []);

  function loadMonthly() {
    api
      .get('/financial-report/monthly', { params: { year } })
      .then((res) => setMonthly(res.data.months || []));
  }

  useEffect(() => {
    loadMonthly();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div>
      <h2>درآمد و هزینه (گزارش مالی کامل)</h2>

      {summary && (
        <div className="stat-grid" style={{ marginBottom: 24 }}>
          <div className="stat-card">
            <div className="label">درآمد کل</div>
            <div className="value">{summary.income.toLocaleString('fa-IR')}</div>
          </div>
          <div className="stat-card">
            <div className="label">درآمد فروش آرد</div>
            <div className="value">{(summary.flourSaleIncome || 0).toLocaleString('fa-IR')}</div>
          </div>
          <div className="stat-card">
            <div className="label">هزینه‌ها</div>
            <div className="value">{summary.expenses.toLocaleString('fa-IR')}</div>
          </div>
          <div className="stat-card">
            <div className="label">حقوق پرداختی</div>
            <div className="value">{summary.salaries.toLocaleString('fa-IR')}</div>
          </div>
          <div className="stat-card">
            <div className="label">سود خالص</div>
            <div className="value" style={{ color: summary.profit >= 0 ? 'var(--success)' : 'var(--danger)' }}>
              {summary.profit.toLocaleString('fa-IR')}
            </div>
          </div>
        </div>
      )}

      {balance && (
        <div style={{ marginBottom: 24 }}>
          <h3 style={{ fontSize: 15, marginBottom: 12 }}>ترازنامه (دارایی و بدهی)</h3>
          <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap' }}>
            <div className="card" style={{ flex: 1, minWidth: 260 }}>
              <div className="card-title" style={{ color: 'var(--success, #22c55e)' }}>دارایی‌ها</div>
              <table>
                <tbody>
                  <tr><td>نقد در صندوق</td><td>{balance.assets.cash.toLocaleString('fa-IR')}</td></tr>
                  <tr><td>ارزش موجودی آرد</td><td>{balance.assets.flourInventoryValue.toLocaleString('fa-IR')}</td></tr>
                  <tr><td>مطالبات از فروشندگان</td><td>{balance.assets.sellerReceivable.toLocaleString('fa-IR')}</td></tr>
                  <tr><td>مطالبات از کارکنان</td><td>{balance.assets.employeeReceivable.toLocaleString('fa-IR')}</td></tr>
                  <tr style={{ fontWeight: 700 }}><td>جمع دارایی‌ها</td><td>{balance.assets.total.toLocaleString('fa-IR')}</td></tr>
                </tbody>
              </table>
            </div>

            <div className="card" style={{ flex: 1, minWidth: 260 }}>
              <div className="card-title" style={{ color: 'var(--danger)' }}>بدهی‌ها</div>
              <table>
                <tbody>
                  <tr><td>هزینه‌های پرداخت‌نشده</td><td>{balance.liabilities.unpaidExpenses.toLocaleString('fa-IR')}</td></tr>
                  <tr><td>خرید آرد پرداخت‌نشده</td><td>{balance.liabilities.unpaidFlourPurchases.toLocaleString('fa-IR')}</td></tr>
                  <tr><td>حقوق پرداخت‌نشده</td><td>{balance.liabilities.unpaidSalaries.toLocaleString('fa-IR')}</td></tr>
                  <tr style={{ fontWeight: 700 }}><td>جمع بدهی‌ها</td><td>{balance.liabilities.total.toLocaleString('fa-IR')}</td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <div className="card" style={{ marginTop: 16 }}>
            <div className="card-title">سرمایه خالص (دارایی - بدهی)</div>
            <div className="value" style={{ color: balance.equity >= 0 ? 'var(--success, #22c55e)' : 'var(--danger)' }}>
              {balance.equity.toLocaleString('fa-IR')}
            </div>
            <div style={{ fontSize: 12, color: 'var(--text-dim)', marginTop: 10 }}>{balance.note}</div>
          </div>
        </div>
      )}

      <h3 style={{ fontSize: 15, marginBottom: 12 }}>گزارش ماهانه</h3>
      <div className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, alignItems: 'center' }}>
        <span style={{ fontSize: 13, color: 'var(--text-dim)' }}>سال شمسی:</span>
        <input
          type="number"
          value={year}
          onChange={(e) => setYear(Number(e.target.value))}
          style={{ width: 100 }}
        />
        <button className="btn-ghost" onClick={loadMonthly} type="button">نمایش گزارش ماهانه</button>
      </div>

      {monthly.length > 0 && (
        <table>
          <thead>
            <tr>
              <th>ماه</th>
              <th>درآمد</th>
              <th>هزینه</th>
              <th>هزینه‌ی تولید</th>
              <th>سود</th>
            </tr>
          </thead>
          <tbody>
            {monthly.map((row) => (
              <tr key={row.month}>
                <td>{row.month}</td>
                <td>{row.income.toLocaleString('fa-IR')}</td>
                <td>{row.expenses.toLocaleString('fa-IR')}</td>
                <td>{row.productionCost.toLocaleString('fa-IR')}</td>
                <td style={{ color: row.profit >= 0 ? 'var(--success)' : 'var(--danger)' }}>
                  {row.profit.toLocaleString('fa-IR')}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

