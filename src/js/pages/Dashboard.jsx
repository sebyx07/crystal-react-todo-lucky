import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import TodoList from '../components/TodoList';

export default function Dashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();

  const handleSignOut = async () => {
    await signOut();
    navigate('/sign-in');
  };

  return (
    <div className="container-fluid">
      <nav className="navbar navbar-expand-lg navbar-light bg-light border-bottom shadow-sm">
        <div className="container-fluid">
          <span className="navbar-brand mb-0 h1">
            <i className="bi bi-check2-square"></i> Todo App
          </span>
          <div className="d-flex align-items-center">
            <span className="me-3 text-muted">{user?.email}</span>
            <button onClick={handleSignOut} className="btn btn-outline-secondary btn-sm" flow-id="sign-out-button">
              Sign Out
            </button>
          </div>
        </div>
      </nav>
      <main className="container py-4" style={{maxWidth: '800px'}}>
        <h2 className="mb-4">Dashboard</h2>
        <TodoList />
      </main>
    </div>
  );
}
