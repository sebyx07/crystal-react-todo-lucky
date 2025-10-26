import React from 'react';
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import TodoItem from './TodoItem';

describe('TodoItem', () => {
  const mockTodo = {
    id: 1,
    title: 'Test Todo',
    completed: false,
  };

  it('renders todo title and actions', () => {
    render(
      <TodoItem
        todo={mockTodo}
        onToggle={vi.fn()}
        onUpdate={vi.fn()}
        onDelete={vi.fn()}
      />
    );

    expect(screen.getByText('Test Todo')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Edit' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Delete' })).toBeInTheDocument();
  });

  it('shows checkbox checked for completed todo', () => {
    const completedTodo = { ...mockTodo, completed: true };

    render(
      <TodoItem
        todo={completedTodo}
        onToggle={vi.fn()}
        onUpdate={vi.fn()}
        onDelete={vi.fn()}
      />
    );

    const checkbox = screen.getByRole('checkbox');
    expect(checkbox).toBeChecked();
  });

  it('calls onToggle when checkbox is clicked', async () => {
    const handleToggle = vi.fn();
    const user = userEvent.setup();

    render(
      <TodoItem
        todo={mockTodo}
        onToggle={handleToggle}
        onUpdate={vi.fn()}
        onDelete={vi.fn()}
      />
    );

    await user.click(screen.getByRole('checkbox'));
    expect(handleToggle).toHaveBeenCalledWith(1, false);
  });

  it('enters edit mode when Edit button clicked', async () => {
    const user = userEvent.setup();

    render(
      <TodoItem
        todo={mockTodo}
        onToggle={vi.fn()}
        onUpdate={vi.fn()}
        onDelete={vi.fn()}
      />
    );

    await user.click(screen.getByRole('button', { name: 'Edit' }));

    expect(screen.getByDisplayValue('Test Todo')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Save' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Cancel' })).toBeInTheDocument();
  });

  it('calls onUpdate when save button clicked', async () => {
    const handleUpdate = vi.fn().mockResolvedValue(undefined);
    const user = userEvent.setup();

    render(
      <TodoItem
        todo={mockTodo}
        onToggle={vi.fn()}
        onUpdate={handleUpdate}
        onDelete={vi.fn()}
      />
    );

    await user.click(screen.getByRole('button', { name: 'Edit' }));

    const input = screen.getByDisplayValue('Test Todo');
    await user.clear(input);
    await user.type(input, 'Updated Todo');
    await user.click(screen.getByRole('button', { name: 'Save' }));

    expect(handleUpdate).toHaveBeenCalledWith(1, 'Updated Todo');
  });

  it('cancels edit mode without saving', async () => {
    const handleUpdate = vi.fn();
    const user = userEvent.setup();

    render(
      <TodoItem
        todo={mockTodo}
        onToggle={vi.fn()}
        onUpdate={handleUpdate}
        onDelete={vi.fn()}
      />
    );

    await user.click(screen.getByRole('button', { name: 'Edit' }));
    await user.type(screen.getByDisplayValue('Test Todo'), ' Modified');
    await user.click(screen.getByRole('button', { name: 'Cancel' }));

    expect(handleUpdate).not.toHaveBeenCalled();
    expect(screen.getByText('Test Todo')).toBeInTheDocument();
  });
});
