import { useState } from 'react';

export default function TodoItem({ todo, onToggle, onUpdate, onDelete }) {
  const [isEditing, setIsEditing] = useState(false);
  const [editTitle, setEditTitle] = useState(todo.title);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!editTitle.trim()) return;

    try {
      setIsSubmitting(true);
      await onUpdate(todo.id, editTitle.trim());
      setIsEditing(false);
    } catch (_err) {
      // Error handled by parent
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCancel = () => {
    setEditTitle(todo.title);
    setIsEditing(false);
  };

  if (isEditing) {
    return (
      <div className="list-group-item">
        <form onSubmit={handleSubmit}>
          <div className="input-group">
            <input
              type="text"
              className="form-control"
              value={editTitle}
              onChange={(e) => setEditTitle(e.target.value)}
              disabled={isSubmitting}
              autoFocus
            />
            <button
              type="submit"
              className="btn btn-success"
              disabled={isSubmitting || !editTitle.trim()}
            >
              Save
            </button>
            <button
              type="button"
              className="btn btn-secondary"
              onClick={handleCancel}
              disabled={isSubmitting}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    );
  }

  return (
    <div className="list-group-item d-flex justify-content-between align-items-center">
      <div className="d-flex align-items-center flex-grow-1">
        <input
          type="checkbox"
          className="form-check-input me-3"
          checked={todo.completed}
          onChange={() => onToggle(todo.id, todo.completed)}
        />
        <span
          className={`flex-grow-1 ${todo.completed ? 'text-decoration-line-through text-muted' : ''}`}
          style={{ cursor: 'pointer' }}
          onClick={() => setIsEditing(true)}
        >
          {todo.title}
        </span>
      </div>
      <div className="btn-group">
        <button
          className="btn btn-sm btn-outline-primary"
          onClick={() => setIsEditing(true)}
        >
          Edit
        </button>
        <button
          className="btn btn-sm btn-outline-danger"
          onClick={() => onDelete(todo.id)}
        >
          Delete
        </button>
      </div>
    </div>
  );
}
