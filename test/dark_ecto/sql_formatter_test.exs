defmodule DarkEcto.SQLFormatterTest do
  @moduledoc """
  Test for DarkEcto.SQLFormatterTest
  """

  use ExUnit.Case, async: true

  alias DarkEcto.SQLFormatter

  describe ".format/1" do
    test "given valid :sql" do
      sql =
        "SELECT b0.\"id\", b0.\"stream_uuid\", b0.\"status\", b0.\"business_name\", b0.\"inserted_at\", b0.\"updated_at\" FROM \"broker_orgs\" AS b0 INNER JOIN \"broker_org_users\" AS b1 ON b1.\"broker_org_id\" = b0.\"id\" INNER JOIN \"users\" AS u2 ON u2.\"id\" = b1.\"user_id\""

      assert SQLFormatter.format(sql) == """
             SELECT b0."id",
                 b0."stream_uuid",
                 b0."status",
                 b0."business_name",
                 b0."inserted_at",
                 b0."updated_at"
             FROM "broker_orgs" AS b0
             INNER JOIN "broker_org_users" AS b1
               ON b1."broker_org_id" = b0."id"
             INNER JOIN "users" AS u2
               ON u2."id" = b1."user_id"
             """
    end

    test "given an empty string" do
      sql = ""
      assert SQLFormatter.format(sql) == "\n"
    end
  end
end
