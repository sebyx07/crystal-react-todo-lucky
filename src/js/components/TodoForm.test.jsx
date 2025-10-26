import React from 'react';
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import TodoForm from './TodoForm';

describe('TodoForm', () => {
  it('renders input and button', () => {
    render(<TodoForm onSubmit={vi.fn()} />);

    expect(screen.getByPlaceholderText('Add a new todo...')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Add Todo' })).toBeInTheDocument();
  });

  it('calls onSubmit with trimmed title', async () => {
    const handleSubmit = vi.fn();
    const user = userEvent.setup();

    render(<TodoForm onSubmit={handleSubmit} />);

    const input = screen.getByPlaceholderText('Add a new todo...');
    const button = screen.getByRole('button', { name: 'Add Todo' });

    await user.type(input, '  Test Todo  ');
    await user.click(button);

    expect(handleSubmit).toHaveBeenCalledWith('Test Todo');
  });

  it('clears input after successful submission', async () => {
    const handleSubmit = vi.fn().mockResolvedValue(undefined);
    const user = userEvent.setup();

    render(<TodoForm onSubmit={handleSubmit} />);

    const input = screen.getByPlaceholderText('Add a new todo...');

    await user.type(input, 'Test Todo');
    await user.click(screen.getByRole('button', { name: 'Add Todo' }));

    // Wait for async operation
    await vi.waitFor(() => {
      expect(input).toHaveValue('');
    });
  });

  it('does not submit empty or whitespace-only title', async () => {
    const handleSubmit = vi.fn();
    const user = userEvent.setup();

    render(<TodoForm onSubmit={handleSubmit} />);

    const button = screen.getByRole('button', { name: 'Add Todo' });

    // Try submitting empty
    await user.click(button);
    expect(handleSubmit).not.toHaveBeenCalled();

    // Try submitting whitespace
    const input = screen.getByPlaceholderText('Add a new todo...');
    await user.type(input, '   ');
    await user.click(button);
    expect(handleSubmit).not.toHaveBeenCalled();
  });

  it('disables button while submitting', async () => {
    const handleSubmit = vi.fn(() => new Promise(resolve => setTimeout(resolve, 100)));
    const user = userEvent.setup();

    render(<TodoForm onSubmit={handleSubmit} />);

    const input = screen.getByPlaceholderText('Add a new todo...');
    const button = screen.getByRole('button', { name: 'Add Todo' });

    await user.type(input, 'Test');
    await user.click(button);

    expect(button).toBeDisabled();
    expect(button).toHaveTextContent('Adding...');
  });
});
