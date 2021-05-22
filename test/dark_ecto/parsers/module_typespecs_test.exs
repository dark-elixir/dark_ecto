defmodule DarkEcto.Parsers.ModuleTypespecsTest do
  use ExUnit.Case, async: true
  doctest DarkEcto.Parsers.ModuleTypespecs
  alias DarkEcto.Parsers.ModuleTypespecs

  @test_modules [
    ExampleEctoSchemaEmbed,
    ExampleEctoSchemaHasOne,
    ExampleEctoSchemaHasMany,
    ExampleEctoSchema
  ]

  describe ".attributes/1" do
    test "given Plaid.Transactions.Transaction" do
      module = Plaid.Transactions.Transaction

      assert {:ok, grouping} = ModuleTypespecs.attributes(module)

      assert grouping == %{
               attributes: [
                 account_id: {:string, []},
                 account_owner: {:string, []},
                 amount: {:float, []},
                 date: {:string, []},
                 iso_currency_code: {:string, []},
                 name: {:string, []},
                 pending: {:boolean, []},
                 pending_transaction_id: {:string, []},
                 transaction_id: {:string, []},
                 transaction_type: {:string, []},
                 unofficial_currency_code: {:string, []}
               ],
               relationships: [
                 category: {:embeds_many, {:attribute, {:string, []}}},
                 location: {:has_one, {:ignore, Plaid.Transactions.Transaction.Location}, []},
                 payment_meta:
                   {:has_one, {:ignore, Plaid.Transactions.Transaction.PaymentMeta}, []}
               ]
             }
    end

    # for module <- @test_modules do
    #   test "given #{inspect(module)} it returns {:ok, _}" do
    #     assert {:ok, _grouping} = ModuleTypespecs.attributes(unquote(module))
    #   end
    # end
  end

  describe ".typespecs/1" do
    test "given Plaid.Transactions.Transaction" do
      module = Plaid.Transactions.Transaction

      assert {:ok, typespecs} = ModuleTypespecs.typespecs(module)

      assert typespecs == %{
               {Plaid.Transactions.Transaction, :t} =>
                 {:struct, Plaid.Transactions.Transaction,
                  %{
                    "account_id" => {:account_id, {{String, :t}, []}},
                    "account_owner" => {:account_owner, {{String, :t}, []}},
                    "amount" => {:amount, {:float, []}},
                    "category" => {:category, {:list, {{String, :t}, []}}},
                    "category_id" => {:category_id, {{String, :t}, []}},
                    "date" => {:date, {{String, :t}, []}},
                    "iso_currency_code" => {:iso_currency_code, {{String, :t}, []}},
                    "location" =>
                      {:location, {{Plaid.Transactions.Transaction.Location, :t}, []}},
                    "name" => {:name, {{String, :t}, []}},
                    "payment_meta" =>
                      {:payment_meta, {{Plaid.Transactions.Transaction.PaymentMeta, :t}, []}},
                    "pending" => {:pending, {:union, [atom: true, atom: false]}},
                    "pending_transaction_id" => {:pending_transaction_id, {{String, :t}, []}},
                    "transaction_id" => {:transaction_id, {{String, :t}, []}},
                    "transaction_type" => {:transaction_type, {{String, :t}, []}},
                    "unofficial_currency_code" => {:unofficial_currency_code, {{String, :t}, []}}
                  }}
             }
    end
  end

  describe ".field_typespecs/1" do
    for module <- @test_modules do
      test "given #{inspect(module)} it returns {:ok, _}" do
        assert {:ok, _field_typespecs} = ModuleTypespecs.field_typespecs(unquote(module))
      end
    end

    test "given Plaid.Accounts.Account" do
      module = Plaid.Accounts.Account
      assert {:ok, field_typespecs} = ModuleTypespecs.field_typespecs(module)

      assert field_typespecs == %{
               "account_id" => {:account_id, {{String, :t}, []}},
               "name" => {:name, {{String, :t}, []}},
               "balances" => {:balances, {{Plaid.Accounts.Account.Balance, :t}, []}},
               "mask" => {:mask, {{String, :t}, []}},
               "official_name" => {:official_name, {{String, :t}, []}},
               "owners" => {:owners, {:list, {{Plaid.Accounts.Account.Owner, :t}, []}}},
               "subtype" => {:subtype, {{String, :t}, []}},
               "type" => {:type, {{String, :t}, []}}
             }
    end
  end
end
