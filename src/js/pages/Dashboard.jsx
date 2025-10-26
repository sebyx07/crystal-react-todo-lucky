import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

export default function Dashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();

  const handleSignOut = async () => {
    await signOut();
    navigate('/sign-in');
  };

  return (
    <div className="container-fluid">
      <nav className="navbar navbar-expand-lg navbar-light bg-light border-bottom">
        <div className="container-fluid">
          <span className="navbar-brand">Todo App</span>
          <div className="d-flex align-items-center">
            <span className="me-3">Welcome, {user?.email}</span>
            <button onClick={handleSignOut} className="btn btn-outline-secondary btn-sm">
              Sign Out
            </button>
          </div>
        </div>
      </nav>
      <main className="container py-4">
        <h2 className="mb-4">Todo List</h2>
        <p className="text-muted">Todo list functionality coming soon...</p>
      </main>
    </div>
  );
}
