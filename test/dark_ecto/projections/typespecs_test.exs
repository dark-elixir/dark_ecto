defmodule DarkEcto.Projections.TypespecsTest do
  @moduledoc """
  Test for `DarkEcto.Projections.Typespecs`
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Projections.Typespecs
  alias DarkEcto.Reflections.EctoSchemaFields

  describe ".cast/1" do
    test "with ExampleEctoSchema" do
      schema = ExampleEctoSchema

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   id: "SFX.primary_key()",
                   date: "Date.t()",
                   decimal: "Decimal.t()",
                   float: "float()",
                   integer: "integer()",
                   naive_datetime: "NaiveDateTime.t()",
                   naive_datetime_usec: "NaiveDateTime.t()",
                   string: "String.t()",
                   time: "Time.t()",
                   time_usec: "Time.t()",
                   utc_datetime: "DateTime.t()",
                   utc_datetime_usec: "DateTime.t()",
                   virtual_date: "virtual :: any()",
                   virtual_decimal: "virtual :: any()",
                   virtual_float: "virtual :: any()",
                   virtual_integer: "virtual :: any()",
                   virtual_naive_datetime: "virtual :: any()",
                   virtual_naive_datetime_usec: "virtual :: any()",
                   virtual_string: "virtual :: any()",
                   virtual_time: "virtual :: any()",
                   virtual_time_usec: "virtual :: any()",
                   virtual_utc_datetime: "virtual :: any()",
                   virtual_utc_datetime_usec: "virtual :: any()",
                   example_ecto_schema_has_one: "ExampleEctoSchemaHasOne.t()",
                   example_ecto_schema_has_many: "[ExampleEctoSchemaHasMany.t()]"
                 ]
               })
    end

    test "with Ecto.Integration.Post" do
      schema = Ecto.Integration.Post

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   id: "SFX.primary_key()",
                   author_id: "SFX.foreign_key() | nil",
                   bid: "Ecto.UUID.t()",
                   counter: "SFX.foreign_key() | nil",
                   uuid: "Ecto.UUID.t()",
                   blob: "String.t()",
                   cost: "Decimal.t()",
                   intensities: "%{optional(any()) => float()}",
                   intensity: "float()",
                   links: "%{optional(any()) => String.t()}",
                   meta: "map()",
                   posted: "Date.t()",
                   public: "boolean()",
                   title: "String.t()",
                   visits: "integer()",
                   wrapped_visits: "WrappedInteger.t()",
                   inserted_at: "NaiveDateTime.t()",
                   updated_at: "NaiveDateTime.t()",
                   temp: "virtual :: any()",
                   author: "User.t()",
                   permalink: "Permalink.t()",
                   post_user_composite_pk: "PostUserCompositePk.t()",
                   update_permalink: "Permalink.t()",
                   comments: "[Comment.t()]",
                   comments_authors: "[User.t()]",
                   comments_authors_permalinks: "[join_table :: struct()]",
                   constraint_users: "[User.t()]",
                   unique_users: "[User.t()]",
                   users: "[User.t()]",
                   users_comments: "[Comment.t()]"
                 ]
               })
    end

    test "with Ecto.Integration.Comment" do
      schema = Ecto.Integration.Comment

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   id: "SFX.primary_key()",
                   author_id: "SFX.foreign_key() | nil",
                   post_id: "SFX.foreign_key() | nil",
                   lock_version: "integer()",
                   text: "String.t()",
                   author: "User.t()",
                   post: "Post.t()",
                   post_permalink: "Permalink.t()"
                 ]
               })
    end

    test "with Ecto.Integration.Permalink" do
      schema = Ecto.Integration.Permalink

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   id: "SFX.primary_key()",
                   post_id: "SFX.foreign_key() | nil",
                   user_id: "SFX.foreign_key() | nil",
                   title: "String.t()",
                   url: "String.t()",
                   posted: "virtual :: any()",
                   post: "Post.t()",
                   update_post: "Post.t()",
                   user: "User.t()",
                   post_comments_authors: "[join_table :: struct()]"
                 ]
               })
    end

    test "with Ecto.Integration.PostUser" do
      schema = Ecto.Integration.PostUser

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "SFX.primary_key()"},
                   {:post_id, "SFX.foreign_key() | nil"},
                   {:user_id, "SFX.foreign_key() | nil"},
                   {:inserted_at, "NaiveDateTime.t()"},
                   {:updated_at, "NaiveDateTime.t()"},
                   {:post, "Post.t()"},
                   {:user, "User.t()"}
                 ]
               })
    end

    test "with Ecto.Integration.User" do
      schema = Ecto.Integration.User

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "SFX.primary_key()"},
                   {:custom_id, "Ecto.UUID.t()"},
                   {:name, "String.t()"},
                   {:inserted_at, "DateTime.t()"},
                   {:updated_at, "DateTime.t()"},
                   {:custom, "Custom.t()"},
                   {:permalink, "Permalink.t()"},
                   {:comments, "[Comment.t()]"},
                   {:posts, "[Post.t()]"},
                   {:schema_posts, "[Post.t()]"},
                   {:unique_posts, "[Post.t()]"}
                 ]
               })
    end

    test "with Ecto.Integration.Custom" do
      schema = Ecto.Integration.Custom

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:bid, "Ecto.UUID.t()"},
                   {:uuid, "Ecto.UUID.t()"},
                   customs: "[Custom.t()]"
                 ]
               })
    end

    test "with Ecto.Integration.Barebone" do
      schema = Ecto.Integration.Barebone

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [{:num, "integer()"}]
               })
    end

    test "with Ecto.Integration.Tag" do
      schema = Ecto.Integration.Tag

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "SFX.primary_key()"},
                   {:ints, "[integer()]"},
                   {:uuids, "[Ecto.UUID.t()]"}
                 ],
                 alias: :Tag,
                 assoc_imports: [],
                 embed_imports: [Ecto.Integration.Item],
                 embed_one_relations: [],
                 embed_many_relations: [items: Ecto.Integration.Item],
                 enums: [],
                 fk_fields: [],
                 human_plural: "Tags",
                 human_singular: "Tag",
                 import_aliases: [{Ecto.Integration.Item, :Item}],
                 imports: [Ecto.Integration.Item],
                 many_relations: [],
                 module: Ecto.Integration.Tag,
                 non_virtual_fields: [ints: {:array, :integer}, uuids: {:array, Ecto.UUID}],
                 one_relations: [],
                 pk_fields: [id: :id],
                 plural: :tags,
                 singular: :tag,
                 virtual_fields: []
               })
    end

    test "with Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "Ecto.UUID.t()"},
                   {:price, "integer()"},
                   {:reference, "PrefixedString.t()"},
                   {:valid_at, "Date.t()"}
                 ]
               })
    end

    test "with Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [{:id, "Ecto.UUID.t()"}, {:name, "String.t()"}]
               })
    end

    test "with Ecto.Integration.Order" do
      schema = Ecto.Integration.Order

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "SFX.primary_key()"},
                   {:permalink_id, "SFX.foreign_key() | nil"},
                   {:meta, "map()"},
                   {:permalink, "Permalink.t()"}
                 ]
               })
    end

    test "with Ecto.Integration.CompositePk" do
      schema = Ecto.Integration.CompositePk

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:a, "integer()"},
                   {:b, "integer()"},
                   {:name, "String.t()"}
                 ]
               })
    end

    test "with Ecto.Integration.CorruptedPk" do
      schema = Ecto.Integration.CorruptedPk

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [{:a, "String.t()"}]
               })
    end

    test "with Ecto.Integration.PostUserCompositePk" do
      schema = Ecto.Integration.PostUserCompositePk

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:post_id, "SFX.foreign_key()"},
                   {:user_id, "SFX.foreign_key()"},
                   {:inserted_at, "NaiveDateTime.t()"},
                   {:updated_at, "NaiveDateTime.t()"},
                   {:post, "Post.t()"},
                   {:user, "User.t()"}
                 ]
               })
    end

    test "with Ecto.Integration.Usec" do
      schema = Ecto.Integration.Usec

      assert Typespecs.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 typespec: [
                   {:id, "SFX.primary_key()"},
                   {:naive_datetime_usec, "NaiveDateTime.t()"},
                   {:utc_datetime_usec, "DateTime.t()"}
                 ]
               })
    end
  end
end
