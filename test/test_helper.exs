Code.require_file("support/test_repo.exs", __DIR__)
Code.require_file("support/fixture_schemas.exs", __DIR__)
Code.require_file("../deps/ecto/integration_test/support/schemas.exs", __DIR__)

ExUnit.configure(exclude: [:cli_not_implemented])
ExUnit.start()
