import React, { useState, useEffect } from 'react';
import { apiService } from '../services/ApiService';
import TodoItem from './TodoItem';
import TodoForm from './TodoForm';

export default function TodoList() {
  const [todos, setTodos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState(null);

  const fetchTodos = async (pageNum = 1) => {
    try {
      setLoading(true);
      const data = await apiService.getTodos(pageNum);
      setTodos(data.todos);
      setPagination(data.pagination);
      setPage(pageNum);
      setError('');
    } catch (err) {
      setError(err.message || 'Failed to load todos');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  const handleCreate = async (title) => {
    try {
      const newTodo = await apiService.createTodo(title);
      setTodos([newTodo, ...todos]);
      setError('');
    } catch (err) {
      setError(err.message || 'Failed to create todo');
      throw err;
    }
  };

  const handleToggle = async (id, completed) => {
    try {
      const todo = todos.find(t => t.id === id);
      const updated = await apiService.updateTodo(id, todo.title, !completed);
      setTodos(todos.map(t => t.id === id ? updated : t));
      setError('');
    } catch (err) {
      setError(err.message || 'Failed to update todo');
    }
  };

  const handleUpdate = async (id, title) => {
    try {
      const todo = todos.find(t => t.id === id);
      const updated = await apiService.updateTodo(id, title, todo.completed);
      setTodos(todos.map(t => t.id === id ? updated : t));
      setError('');
    } catch (err) {
      setError(err.message || 'Failed to update todo');
      throw err;
    }
  };

  const handleDelete = async (id) => {
    if (!confirm('Are you sure you want to delete this todo?')) return;

    try {
      await apiService.deleteTodo(id);
      setTodos(todos.filter(t => t.id !== id));
      setError('');
    } catch (err) {
      setError(err.message || 'Failed to delete todo');
    }
  };

  if (loading && todos.length === 0) {
    return (
      <div className="text-center py-5">
        <div className="spinner-border" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <div>
      {error && <div className="alert alert-danger alert-dismissible fade show" role="alert">
        {error}
        <button type="button" className="btn-close" onClick={() => setError('')}></button>
      </div>}

      <TodoForm onSubmit={handleCreate} />

      {todos.length === 0 ? (
        <div className="alert alert-info mt-4">
          No todos yet. Create one to get started!
        </div>
      ) : (
        <>
          <div className="list-group mt-4">
            {todos.map(todo => (
              <TodoItem
                key={todo.id}
                todo={todo}
                onToggle={handleToggle}
                onUpdate={handleUpdate}
                onDelete={handleDelete}
              />
            ))}
          </div>

          {pagination && pagination.total_pages > 1 && (
            <nav className="mt-4">
              <ul className="pagination justify-content-center">
                <li className={`page-item ${!pagination.previous_page ? 'disabled' : ''}`}>
                  <button
                    className="page-link"
                    onClick={() => fetchTodos(page - 1)}
                    disabled={!pagination.previous_page}
                  >
                    Previous
                  </button>
                </li>
                <li className="page-item disabled">
                  <span className="page-link">
                    Page {page} of {pagination.total_pages}
                  </span>
                </li>
                <li className={`page-item ${!pagination.next_page ? 'disabled' : ''}`}>
                  <button
                    className="page-link"
                    onClick={() => fetchTodos(page + 1)}
                    disabled={!pagination.next_page}
                  >
                    Next
                  </button>
                </li>
              </ul>
            </nav>
          )}
        </>
      )}
    </div>
  );
}
