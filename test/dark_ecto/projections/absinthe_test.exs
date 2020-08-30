defmodule DarkEcto.Projections.AbsintheTest do
  @moduledoc """
  Test for `DarkEcto.Projections.Absinthe`
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Projections.Absinthe
  alias DarkEcto.Reflections.EctoSchemaFields

  describe ".cast/1" do
    test "with ExampleEctoSchema" do
      schema = ExampleEctoSchema

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   id: "non_null(:id)",
                   date: ":date",
                   decimal: ":decimal",
                   float: ":float",
                   integer: ":integer",
                   naive_datetime: ":naive_datetime",
                   naive_datetime_usec: ":naive_datetime",
                   string: ":string",
                   time: ":time",
                   time_usec: ":time",
                   utc_datetime: ":datetime",
                   utc_datetime_usec: ":datetime",
                   example_ecto_schema_has_one: ":example_ecto_schema_has_one",
                   example_ecto_schema_has_many:
                     "list_of(non_null(:example_ecto_schema_has_many))"
                 ]
               })
    end

    test "with Ecto.Integration.Post" do
      schema = Ecto.Integration.Post

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:author_id, ":id"},
                   {:bid, ":uuid4"},
                   {:counter, ":id"},
                   {:uuid, ":uuid4"},
                   {:blob, ":string"},
                   {:cost, ":decimal"},
                   {:intensities, ":json"},
                   {:intensity, ":float"},
                   {:links, ":json"},
                   {:meta, ":json"},
                   {:posted, ":date"},
                   {:public, ":boolean"},
                   {:title, ":string"},
                   {:visits, ":integer"},
                   {:wrapped_visits, ":wrapped_integer"},
                   {:inserted_at, ":naive_datetime"},
                   {:updated_at, ":naive_datetime"},
                   {:author, ":user"},
                   {:permalink, ":permalink"},
                   {:post_user_composite_pk, ":post_user_composite_pk"},
                   {:update_permalink, ":permalink"},
                   {:comments, "list_of(non_null(:comment))"},
                   {:comments_authors, "list_of(non_null(:user))"},
                   #  {:comments_authors_permalinks, "list_of(non_null(:permalink))"},
                   {:constraint_users, "list_of(non_null(:user))"},
                   {:unique_users, "list_of(non_null(:user))"},
                   {:users, "list_of(non_null(:user))"},
                   {:users_comments, "list_of(non_null(:comment))"}
                 ]
               })
    end

    test "with Ecto.Integration.Comment" do
      schema = Ecto.Integration.Comment

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   id: "non_null(:id)",
                   author_id: ":id",
                   post_id: ":id",
                   lock_version: ":integer",
                   text: ":string",
                   author: ":user",
                   post: ":post",
                   post_permalink: ":permalink"
                 ]
               })
    end

    test "with Ecto.Integration.Permalink" do
      schema = Ecto.Integration.Permalink

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   id: "non_null(:id)",
                   post_id: ":id",
                   user_id: ":id",
                   title: ":string",
                   url: ":string",
                   post: ":post",
                   update_post: ":post",
                   user: ":user"
                   #  post_comments_authors: "[join_table :: struct()]"
                 ]
               })
    end

    test "with Ecto.Integration.PostUser" do
      schema = Ecto.Integration.PostUser

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:post_id, ":id"},
                   {:user_id, ":id"},
                   {:inserted_at, ":naive_datetime"},
                   {:updated_at, ":naive_datetime"},
                   {:post, ":post"},
                   {:user, ":user"}
                 ]
               })
    end

    test "with Ecto.Integration.User" do
      schema = Ecto.Integration.User

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:custom_id, ":uuid4"},
                   {:name, ":string"},
                   {:inserted_at, ":datetime"},
                   {:updated_at, ":datetime"},
                   {:custom, ":custom"},
                   {:permalink, ":permalink"},
                   {:comments, "list_of(non_null(:comment))"},
                   {:posts, "list_of(non_null(:post))"},
                   {:schema_posts, "list_of(non_null(:post))"},
                   {:unique_posts, "list_of(non_null(:post))"}
                 ]
               })
    end

    test "with Ecto.Integration.Custom" do
      schema = Ecto.Integration.Custom

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:bid, "non_null(:uuid4)"},
                   {:uuid, ":uuid4"},
                   customs: "list_of(non_null(:custom))"
                 ]
               })
    end

    test "with Ecto.Integration.Barebone" do
      schema = Ecto.Integration.Barebone

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [{:num, ":integer"}]
               })
    end

    test "with Ecto.Integration.Tag" do
      schema = Ecto.Integration.Tag

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:ints, "list_of(non_null(:integer))"},
                   {:uuids, "list_of(non_null(:uuid4))"}
                 ]
               })
    end

    test "with Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:uuid4)"},
                   {:price, ":integer"},
                   {:reference, ":prefixed_string"},
                   {:valid_at, ":date"}
                 ]
               })
    end

    test "with Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [id: "non_null(:uuid4)", name: ":string"]
               })
    end

    test "with Ecto.Integration.Order" do
      schema = Ecto.Integration.Order

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:permalink_id, ":id"},
                   {:meta, ":json"},
                   {:permalink, ":permalink"}
                 ]
               })
    end

    test "with Ecto.Integration.CompositePk" do
      schema = Ecto.Integration.CompositePk

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   a: "non_null(:integer)",
                   b: "non_null(:integer)",
                   name: ":string"
                 ]
               })
    end

    test "with Ecto.Integration.CorruptedPk" do
      schema = Ecto.Integration.CorruptedPk

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [a: "non_null(:string)"]
               })
    end

    test "with Ecto.Integration.PostUserCompositePk" do
      schema = Ecto.Integration.PostUserCompositePk

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:post_id, "non_null(:id)"},
                   {:user_id, "non_null(:id)"},
                   {:inserted_at, ":naive_datetime"},
                   {:updated_at, ":naive_datetime"},
                   {:post, ":post"},
                   {:user, ":user"}
                 ]
               })
    end

    test "with Ecto.Integration.Usec" do
      schema = Ecto.Integration.Usec

      assert Absinthe.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 absinthe_type: [
                   {:id, "non_null(:id)"},
                   {:naive_datetime_usec, ":naive_datetime"},
                   {:utc_datetime_usec, ":datetime"}
                 ]
               })
    end
  end
end
