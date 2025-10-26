# Clean database between tests
# Note: Using truncate instead of transactions because:
# - JWT authentication requires users to persist across requests
# - Transactional specs rollback users before API requests complete
Spec.before_each do
  AppDatabase.truncate
end
