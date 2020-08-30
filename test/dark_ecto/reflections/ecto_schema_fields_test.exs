defmodule DarkEcto.Reflections.EctoSchemaFieldsTest do
  @moduledoc """
  Test for DarkEcto.Reflections.EctoSchemaFields
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Reflections.EctoSchemaFields

  describe ".cast/1" do
    test "with Ecto.Integration.Post" do
      schema = Ecto.Integration.Post

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Post,
               pk_fields: [{:id, :id}],
               fk_fields: [
                 {:author_id, :id},
                 {:bid, :binary_id},
                 {:counter, :id},
                 {:uuid, Ecto.UUID}
               ],
               assoc_imports: [
                 Ecto.Integration.Comment,
                 Ecto.Integration.Permalink,
                 Ecto.Integration.PostUserCompositePk,
                 Ecto.Integration.User
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Posts",
               human_singular: "Post",
               import_aliases: [
                 "Elixir.Ecto.Integration.Comment": :Comment,
                 "Elixir.Ecto.Integration.Permalink": :Permalink,
                 "Elixir.Ecto.Integration.PostUserCompositePk": :PostUserCompositePk,
                 "Elixir.Ecto.Integration.User": :User
               ],
               imports: [
                 Ecto.Integration.Comment,
                 Ecto.Integration.Permalink,
                 Ecto.Integration.PostUserCompositePk,
                 Ecto.Integration.User
               ],
               many_relations: [
                 comments: Ecto.Integration.Comment,
                 comments_authors: Ecto.Integration.User,
                 comments_authors_permalinks: :__ecto_join_table__,
                 #  comments_authors_permalinks: Ecto.Integration.Permalink,
                 constraint_users: Ecto.Integration.User,
                 unique_users: Ecto.Integration.User,
                 users: Ecto.Integration.User,
                 users_comments: Ecto.Integration.Comment
               ],
               module: Ecto.Integration.Post,
               non_virtual_fields: [
                 {:blob, :binary},
                 {:cost, :decimal},
                 {:intensities, {:map, :float}},
                 {:intensity, :float},
                 {:links, {:map, :string}},
                 {:meta, :map},
                 {:posted, :date},
                 {:public, :boolean},
                 {:title, :string},
                 {:visits, :integer},
                 {:wrapped_visits, WrappedInteger},
                 {:inserted_at, :naive_datetime},
                 {:updated_at, :naive_datetime}
               ],
               one_relations: [
                 author: Ecto.Integration.User,
                 permalink: Ecto.Integration.Permalink,
                 post_user_composite_pk: Ecto.Integration.PostUserCompositePk,
                 update_permalink: Ecto.Integration.Permalink
               ],
               plural: :posts,
               singular: :post,
               virtual_fields: [temp: :__ecto_virtual_field__],
               persisted?: true,
               blank?: false,
               alias_plural: :Posts
             }
    end

    test "with Ecto.Integration.Comment" do
      schema = Ecto.Integration.Comment

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Comment,
               pk_fields: [{:id, :id}],
               fk_fields: [
                 {:author_id, :id},
                 {:post_id, :id}
               ],
               assoc_imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Comments",
               human_singular: "Comment",
               import_aliases: [
                 "Elixir.Ecto.Integration.Post": :Post,
                 "Elixir.Ecto.Integration.User": :User
               ],
               imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               many_relations: [],
               module: Ecto.Integration.Comment,
               non_virtual_fields: [
                 lock_version: :integer,
                 text: :string
               ],
               one_relations: [
                 {:author, Ecto.Integration.User},
                 {:post, Ecto.Integration.Post},
                 {:post_permalink, Ecto.Integration.Permalink}
               ],
               plural: :comments,
               singular: :comment,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Comments
             }
    end

    test "with Ecto.Integration.Permalink" do
      schema = Ecto.Integration.Permalink

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Permalink,
               pk_fields: [{:id, :id}],
               fk_fields: [
                 {:post_id, :id},
                 {:user_id, :id}
               ],
               assoc_imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Permalinks",
               human_singular: "Permalink",
               import_aliases: [
                 "Elixir.Ecto.Integration.Post": :Post,
                 "Elixir.Ecto.Integration.User": :User
               ],
               imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               many_relations: [
                 post_comments_authors: :__ecto_join_table__
               ],
               module: Ecto.Integration.Permalink,
               non_virtual_fields: [title: :string, url: :string],
               one_relations: [
                 post: Ecto.Integration.Post,
                 update_post: Ecto.Integration.Post,
                 user: Ecto.Integration.User
               ],
               plural: :permalinks,
               singular: :permalink,
               virtual_fields: [posted: :__ecto_virtual_field__],
               persisted?: true,
               blank?: false,
               alias_plural: :Permalinks
             }
    end

    test "with Ecto.Integration.PostUser" do
      schema = Ecto.Integration.PostUser

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :PostUser,
               pk_fields: [{:id, :id}],
               fk_fields: [
                 {:post_id, :id},
                 {:user_id, :id}
               ],
               assoc_imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Post users",
               human_singular: "Post user",
               import_aliases: [
                 "Elixir.Ecto.Integration.Post": :Post,
                 "Elixir.Ecto.Integration.User": :User
               ],
               imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               many_relations: [],
               module: Ecto.Integration.PostUser,
               non_virtual_fields: [
                 {:inserted_at, :naive_datetime},
                 {:updated_at, :naive_datetime}
               ],
               one_relations: [
                 post: Ecto.Integration.Post,
                 user: Ecto.Integration.User
               ],
               plural: :post_users,
               singular: :post_user,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :PostUsers
             }
    end

    test "with Ecto.Integration.User" do
      schema = Ecto.Integration.User

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :User,
               assoc_imports: [
                 Ecto.Integration.Comment,
                 Ecto.Integration.Custom,
                 Ecto.Integration.Permalink,
                 Ecto.Integration.Post
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               fk_fields: [
                 {:custom_id, :binary_id}
               ],
               human_plural: "Users",
               human_singular: "User",
               import_aliases: [
                 "Elixir.Ecto.Integration.Comment": :Comment,
                 "Elixir.Ecto.Integration.Custom": :Custom,
                 "Elixir.Ecto.Integration.Permalink": :Permalink,
                 "Elixir.Ecto.Integration.Post": :Post
               ],
               imports: [
                 Ecto.Integration.Comment,
                 Ecto.Integration.Custom,
                 Ecto.Integration.Permalink,
                 Ecto.Integration.Post
               ],
               many_relations: [
                 comments: Ecto.Integration.Comment,
                 posts: Ecto.Integration.Post,
                 schema_posts: Ecto.Integration.Post,
                 unique_posts: Ecto.Integration.Post
               ],
               module: Ecto.Integration.User,
               non_virtual_fields: [
                 {:name, :string},
                 {:inserted_at, :utc_datetime},
                 {:updated_at, :utc_datetime}
               ],
               one_relations: [
                 custom: Ecto.Integration.Custom,
                 permalink: Ecto.Integration.Permalink
               ],
               pk_fields: [id: :id],
               plural: :users,
               singular: :user,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Users
             }
    end

    test "with Ecto.Integration.Custom" do
      schema = Ecto.Integration.Custom

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Custom,
               pk_fields: [{:bid, :binary_id}],
               fk_fields: [uuid: Ecto.UUID],
               assoc_imports: [Ecto.Integration.Custom],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Customs",
               human_singular: "Custom",
               import_aliases: [
                 "Elixir.Ecto.Integration.Custom": :Custom
               ],
               imports: [Ecto.Integration.Custom],
               many_relations: [customs: Ecto.Integration.Custom],
               module: Ecto.Integration.Custom,
               non_virtual_fields: [],
               one_relations: [],
               plural: :customs,
               singular: :custom,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Customs
             }
    end

    test "with Ecto.Integration.Barebone" do
      schema = Ecto.Integration.Barebone

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Barebone,
               pk_fields: [],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Barebones",
               human_singular: "Barebone",
               import_aliases: [],
               imports: [],
               many_relations: [],
               module: Ecto.Integration.Barebone,
               non_virtual_fields: [num: :integer],
               one_relations: [],
               plural: :barebones,
               singular: :barebone,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Barebones
             }
    end

    test "with Ecto.Integration.Tag" do
      schema = Ecto.Integration.Tag

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Tag,
               pk_fields: [{:id, :id}],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [Ecto.Integration.Item],
               embed_one_relations: [],
               embed_many_relations: [items: Ecto.Integration.Item],
               human_plural: "Tags",
               human_singular: "Tag",
               import_aliases: [
                 "Elixir.Ecto.Integration.Item": :Item
               ],
               imports: [Ecto.Integration.Item],
               many_relations: [],
               module: Ecto.Integration.Tag,
               non_virtual_fields: [
                 {:ints, {:array, :integer}},
                 {:uuids, {:array, Ecto.UUID}}
               ],
               one_relations: [],
               plural: :tags,
               singular: :tag,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Tags
             }
    end

    test "with Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Item,
               pk_fields: [{:id, :binary_id}],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [Ecto.Integration.ItemColor],
               embed_one_relations: [
                 {:primary_color, Ecto.Integration.ItemColor}
               ],
               embed_many_relations: [
                 {:secondary_colors, Ecto.Integration.ItemColor}
               ],
               human_plural: "Items",
               human_singular: "Item",
               import_aliases: [
                 {Ecto.Integration.ItemColor, :ItemColor}
               ],
               imports: [Ecto.Integration.ItemColor],
               many_relations: [],
               module: Ecto.Integration.Item,
               non_virtual_fields: [
                 {:price, :integer},
                 {:reference, PrefixedString},
                 {:valid_at, :date}
               ],
               one_relations: [],
               plural: :items,
               singular: :item,
               virtual_fields: [],
               persisted?: false,
               blank?: false,
               alias_plural: :Items
             }
    end

    test "with Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :ItemColor,
               pk_fields: [{:id, :binary_id}],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Item colors",
               human_singular: "Item color",
               import_aliases: [],
               imports: [],
               many_relations: [],
               module: Ecto.Integration.ItemColor,
               non_virtual_fields: [
                 {:name, :string}
               ],
               one_relations: [],
               plural: :item_colors,
               singular: :item_color,
               virtual_fields: [],
               persisted?: false,
               blank?: false,
               alias_plural: :ItemColors
             }
    end

    test "with Ecto.Integration.Order" do
      schema = Ecto.Integration.Order

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Order,
               pk_fields: [{:id, :id}],
               fk_fields: [{:permalink_id, :id}],
               assoc_imports: [Ecto.Integration.Permalink],
               embed_imports: [Ecto.Integration.Item],
               embed_one_relations: [
                 item: Ecto.Integration.Item
               ],
               embed_many_relations: [
                 items: Ecto.Integration.Item
               ],
               human_plural: "Orders",
               human_singular: "Order",
               import_aliases: [
                 "Elixir.Ecto.Integration.Item": :Item,
                 "Elixir.Ecto.Integration.Permalink": :Permalink
               ],
               imports: [
                 Ecto.Integration.Item,
                 Ecto.Integration.Permalink
               ],
               many_relations: [],
               module: Ecto.Integration.Order,
               non_virtual_fields: [meta: :map],
               one_relations: [permalink: Ecto.Integration.Permalink],
               plural: :orders,
               singular: :order,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Orders
             }
    end

    test "with Ecto.Integration.CompositePk" do
      schema = Ecto.Integration.CompositePk

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :CompositePk,
               pk_fields: [
                 a: :integer,
                 b: :integer
               ],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Composite pks",
               human_singular: "Composite pk",
               import_aliases: [],
               imports: [],
               many_relations: [],
               module: Ecto.Integration.CompositePk,
               non_virtual_fields: [
                 name: :string
               ],
               one_relations: [],
               plural: :composite_pks,
               singular: :composite_pk,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :CompositePks
             }
    end

    test "with Ecto.Integration.CorruptedPk" do
      schema = Ecto.Integration.CorruptedPk

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :CorruptedPk,
               pk_fields: [{:a, :string}],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Corrupted pks",
               human_singular: "Corrupted pk",
               import_aliases: [],
               imports: [],
               many_relations: [],
               module: Ecto.Integration.CorruptedPk,
               non_virtual_fields: [],
               one_relations: [],
               plural: :corrupted_pks,
               singular: :corrupted_pk,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :CorruptedPks
             }
    end

    test "with Ecto.Integration.PostUserCompositePk" do
      schema = Ecto.Integration.PostUserCompositePk

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :PostUserCompositePk,
               pk_fields: [{:post_id, :id}, {:user_id, :id}],
               fk_fields: [],
               assoc_imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Post user composite pks",
               human_singular: "Post user composite pk",
               import_aliases: [
                 "Elixir.Ecto.Integration.Post": :Post,
                 "Elixir.Ecto.Integration.User": :User
               ],
               imports: [
                 Ecto.Integration.Post,
                 Ecto.Integration.User
               ],
               many_relations: [],
               module: Ecto.Integration.PostUserCompositePk,
               non_virtual_fields: [
                 inserted_at: :naive_datetime,
                 updated_at: :naive_datetime
               ],
               one_relations: [
                 {:post, Ecto.Integration.Post},
                 {:user, Ecto.Integration.User}
               ],
               plural: :post_user_composite_pks,
               singular: :post_user_composite_pk,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :PostUserCompositePks
             }
    end

    test "with Ecto.Integration.Usec" do
      schema = Ecto.Integration.Usec

      assert EctoSchemaFields.cast(schema) == %EctoSchemaFields{
               alias: :Usec,
               pk_fields: [{:id, :id}],
               fk_fields: [],
               assoc_imports: [],
               embed_imports: [],
               embed_one_relations: [],
               embed_many_relations: [],
               human_plural: "Usecs",
               human_singular: "Usec",
               import_aliases: [],
               imports: [],
               many_relations: [],
               module: Ecto.Integration.Usec,
               non_virtual_fields: [
                 {:naive_datetime_usec, :naive_datetime_usec},
                 {:utc_datetime_usec, :utc_datetime_usec}
               ],
               one_relations: [],
               plural: :usecs,
               singular: :usec,
               virtual_fields: [],
               persisted?: true,
               blank?: false,
               alias_plural: :Usecs
             }
    end
  end
end
