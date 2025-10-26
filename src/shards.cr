# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")
# Load environment-specific .env file (e.g., .env.development.local)
LuckyEnv.load?(".env.#{LuckyEnv.environment}.local")

# Require your shards here
require "lucky"
require "avram/lucky"
require "carbon"
require "authentic"
require "jwt"
