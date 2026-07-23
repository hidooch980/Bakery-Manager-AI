import { Outlet, NavLink } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';
import {
  LayoutDashboard,
  ShoppingCart,
  Factory,
  Receipt,
  Package,
  Users,
  BarChart3,
  LogOut,
} from 'lucide-react';

const navItems = [
  { to: '/', label: 'داشبورد', icon: LayoutDashboard },
  { to: '/sales', label: 'فروش', icon: ShoppingCart },
  { to: '/production', label: 'تولید', icon: Factory },
  { to: '/expenses', label: 'هزینه‌ها', icon: Receipt },
  { to: '/products', label: 'محصولات', icon: Package },
  { to: '/employees', label: 'کارکنان', icon: Users },
  { to: '/analytics', label: 'تحلیل و سود', icon: BarChart3 },
];

export function Layout() {
  const { user, logout } = useAuth();

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-brand">🍞 مدیریار نانوایی</div>
        <nav className="sidebar-nav">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) =>
                'sidebar-link' + (isActive ? ' active' : '')
              }
            >
              <item.icon size={18} />
              <span>{item.label}</span>
            </NavLink>
          ))}
        </nav>
      </aside>
      <div className="main-area">
        <header className="topbar">
          <div className="topbar-user">
            <span className="topbar-name">{user?.name}</span>
            <span className="topbar-role">{user?.role}</span>
          </div>
          <button className="btn-ghost" onClick={() => logout()}>
            <LogOut size={16} />
            خروج
          </button>
        </header>
        <main className="content-area">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
