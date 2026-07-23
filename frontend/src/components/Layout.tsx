import { NavLink, useLocation, useNavigate } from "react-router-dom";
import {
  LayoutDashboard,
  Wallet,
  Wheat,
  Receipt,
  ShoppingBasket,
  Users,
  UserCog,
  LineChart,
  ClipboardList,
  LogOut,
} from "lucide-react";
import { useAuth } from "../auth/AuthContext";

const navItems = [
  { to: "/dashboard", label: "داشبورد", icon: LayoutDashboard },
  { to: "/sales", label: "فروش", icon: Wallet },
  { to: "/production", label: "تولید", icon: Wheat },
  { to: "/expenses", label: "هزینه‌ها", icon: Receipt },
  { to: "/products", label: "محصولات", icon: ShoppingBasket },
  { to: "/employees", label: "کارکنان", icon: Users },
  { to: "/users", label: "کاربران", icon: UserCog },
  { to: "/analytics", label: "تحلیل و سود", icon: LineChart },
  { to: "/report", label: "گزارش روزانه", icon: ClipboardList },
];

const pageTitles: Record<string, string> = {
  "/dashboard": "داشبورد مدیریت",
  "/sales": "فروش",
  "/production": "تولید",
  "/expenses": "هزینه‌ها",
  "/products": "محصولات",
  "/employees": "کارکنان",
  "/users": "کاربران",
  "/analytics": "تحلیل و سود",
  "/report": "گزارش روزانه",
};

export default function Layout({ children }: { children: React.ReactNode }) {
  const { user, logout } = useAuth();
  const nav = useNavigate();
  const location = useLocation();

  async function handleLogout() {
    await logout();
    nav("/login");
  }

  const currentTitle = pageTitles[location.pathname] || "مدیریت نانوایی";
  const initials = user?.name ? user.name.trim().charAt(0) : "؟";

  return (
    <div dir="rtl" className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <span className="sidebar-brand-icon">🥖</span>
          مدیریت نانوایی
        </div>

        <nav className="sidebar-nav">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  "sidebar-link" + (isActive ? " active" : "")
                }
              >
                <Icon />
                {item.label}
              </NavLink>
            );
          })}
        </nav>

        <div className="sidebar-footer">
          <div className="sidebar-user">
            <span className="avatar">{initials}</span>
            {user ? `${user.name} · ${user.role}` : ""}
          </div>
          <button className="btn-logout" onClick={handleLogout}>
            <LogOut size={16} />
            خروج
          </button>
        </div>
      </aside>

      <div className="app-main">
        <header className="topbar">
          <div className="topbar-title">{currentTitle}</div>
          <div className="user-chip">
            <span className="avatar">{initials}</span>
            {user ? user.name : ""}
          </div>
        </header>
        <main className="app-content">{children}</main>
      </div>
    </div>
  );
}
