import { useEffect, useState } from 'react';
import api from '../api/client';

type Summary = {
  income: number;
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

export default function FinancialReport() {
  const [summary, setSummary] = useState<Summary | null>(null);
  const [year, setYear] = useState(1404);
  const [monthly, setMonthly] = useState<MonthRow[]>([]);

  useEffect(() => {
    api.get('/financial/daily').then((res) => setSummary(res.data));
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

