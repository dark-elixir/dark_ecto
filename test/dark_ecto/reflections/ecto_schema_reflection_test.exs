defmodule DarkEcto.Reflections.EctoSchemaReflectionTest do
  @moduledoc """
  Test for DarkEcto.Reflections.EctoSchemaReflection
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Reflections.EctoSchemaReflection

  describe ".ecto_schema?/1" do
    test "given a valid schema module" do
      schema = ExampleEctoSchema
      assert EctoSchemaReflection.ecto_schema?(schema) == true
    end

    test "given a valid schema struct" do
      schema = %ExampleEctoSchema{}
      assert EctoSchemaReflection.ecto_schema?(schema) == true
    end

    test "given a plain struct" do
      schema = %{__struct__: :Example}
      assert EctoSchemaReflection.ecto_schema?(schema) == false
    end

    test "given a plain map" do
      schema = %{}
      assert EctoSchemaReflection.ecto_schema?(schema) == false
    end

    test "given nil" do
      schema = nil
      assert EctoSchemaReflection.ecto_schema?(schema) == false
    end
  end

  describe ".non_virtual_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.non_virtual_fields(schema) == [
               {:id, :id},
               {:decimal, :decimal},
               {:float, :float},
               {:integer, :integer},
               {:string, :string},
               {:naive_datetime, :naive_datetime},
               {:naive_datetime_usec, :naive_datetime_usec},
               {:utc_datetime, :utc_datetime},
               {:utc_datetime_usec, :utc_datetime_usec},
               {:date, :date},
               {:time, :time},
               {:time_usec, :time_usec}
             ]
    end
  end

  describe ".virtual_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.virtual_fields(schema) == [
               :virtual_date,
               :virtual_decimal,
               :virtual_float,
               :virtual_integer,
               :virtual_naive_datetime,
               :virtual_naive_datetime_usec,
               :virtual_string,
               :virtual_time,
               :virtual_time_usec,
               :virtual_utc_datetime,
               :virtual_utc_datetime_usec
             ]
    end
  end

  describe ".assocs/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.assocs(schema) == [
               %Ecto.Association.Has{
                 cardinality: :one,
                 defaults: [],
                 field: :example_ecto_schema_has_one,
                 on_cast: nil,
                 on_delete: :nothing,
                 on_replace: :raise,
                 ordered: false,
                 owner: ExampleEctoSchema,
                 owner_key: :id,
                 queryable: ExampleEctoSchemaHasOne,
                 related: ExampleEctoSchemaHasOne,
                 related_key: :example_ecto_schema_id,
                 relationship: :child,
                 unique: true,
                 where: []
               },
               %Ecto.Association.Has{
                 cardinality: :many,
                 defaults: [],
                 field: :example_ecto_schema_has_many,
                 on_cast: nil,
                 on_delete: :nothing,
                 on_replace: :raise,
                 ordered: false,
                 owner: ExampleEctoSchema,
                 owner_key: :id,
                 queryable: ExampleEctoSchemaHasMany,
                 related: ExampleEctoSchemaHasMany,
                 related_key: :example_ecto_schema_id,
                 relationship: :child,
                 unique: true,
                 where: []
               }
             ]
    end
  end

  describe ".embeds/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.embeds(schema) == [
               %Ecto.Embedded{
                 cardinality: :one,
                 field: :example_ecto_schema_embed,
                 on_cast: nil,
                 on_replace: :raise,
                 ordered: true,
                 owner: ExampleEctoSchema,
                 related: ExampleEctoSchemaEmbed,
                 unique: true
               }
             ]
    end
  end

  describe ".non_virtual_fields_by_types/2" do
    test "given a valid schema struct and types []" do
      schema = ExampleEctoSchema
      types = []
      assert EctoSchemaReflection.non_virtual_fields_by_types(schema, types) == []
    end
  end

  describe ".non_virtual_date_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema
      assert EctoSchemaReflection.non_virtual_date_fields(schema) == [:date]
    end
  end

  describe ".non_virtual_datetime_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.non_virtual_datetime_fields(schema) == [
               :utc_datetime,
               :utc_datetime_usec
             ]
    end
  end

  describe ".non_virtual_naive_datetime_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.non_virtual_naive_datetime_fields(schema) == [
               :naive_datetime,
               :naive_datetime_usec
             ]
    end
  end

  describe ".non_virtual_time_fields/1" do
    test "given a valid schema struct" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.non_virtual_time_fields(schema) == [
               :time,
               :time_usec
             ]
    end
  end

  describe ".keys/1" do
    test "given a valid schema" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.keys(schema) == [
               :date,
               :decimal,
               :example_ecto_schema_embed,
               :example_ecto_schema_has_many,
               :example_ecto_schema_has_one,
               :float,
               :id,
               :integer,
               :naive_datetime,
               :naive_datetime_usec,
               :string,
               :time,
               :time_usec,
               :utc_datetime,
               :utc_datetime_usec,
               :virtual_date,
               :virtual_decimal,
               :virtual_float,
               :virtual_integer,
               :virtual_naive_datetime,
               :virtual_naive_datetime_usec,
               :virtual_string,
               :virtual_time,
               :virtual_time_usec,
               :virtual_utc_datetime,
               :virtual_utc_datetime_usec
             ]
    end

    test "given a valid embed Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert EctoSchemaReflection.ecto_schema?(schema) == true

      assert EctoSchemaReflection.keys(schema) == [
               :id,
               :price,
               :primary_color,
               :reference,
               :secondary_colors,
               :valid_at
             ]
    end

    test "given a valid embed Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert EctoSchemaReflection.ecto_schema?(schema) == true
      assert EctoSchemaReflection.keys(schema) == [:id, :name]
    end
  end

  describe ".from_struct/1" do
    test "given a valid schema struct" do
      schema = %ExampleEctoSchema{
        example_ecto_schema_has_one: nil,
        example_ecto_schema_has_many: []
      }

      assert EctoSchemaReflection.from_struct(schema) == %{
               date: nil,
               decimal: nil,
               float: nil,
               id: nil,
               integer: nil,
               naive_datetime: nil,
               naive_datetime_usec: nil,
               string: nil,
               time: nil,
               time_usec: nil,
               utc_datetime: nil,
               utc_datetime_usec: nil,
               virtual_date: nil,
               virtual_decimal: nil,
               virtual_float: nil,
               virtual_integer: nil,
               virtual_naive_datetime: nil,
               virtual_naive_datetime_usec: nil,
               virtual_string: nil,
               virtual_time: nil,
               virtual_time_usec: nil,
               virtual_utc_datetime: nil,
               virtual_utc_datetime_usec: nil,
               example_ecto_schema_embed: nil,
               example_ecto_schema_has_one: nil,
               example_ecto_schema_has_many: []
             }
    end
  end

  test "describe ExampleEctoSchema" do
    schema = ExampleEctoSchema

    assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
             ecto_schema?: true,
             primary_key_fields: [id: :id],
             assocs: [
               %Ecto.Association.Has{
                 cardinality: :one,
                 defaults: [],
                 field: :example_ecto_schema_has_one,
                 on_cast: nil,
                 on_delete: :nothing,
                 on_replace: :raise,
                 ordered: false,
                 owner: ExampleEctoSchema,
                 owner_key: :id,
                 queryable: ExampleEctoSchemaHasOne,
                 related: ExampleEctoSchemaHasOne,
                 related_key: :example_ecto_schema_id,
                 relationship: :child,
                 unique: true,
                 where: []
               },
               %Ecto.Association.Has{
                 cardinality: :many,
                 defaults: [],
                 field: :example_ecto_schema_has_many,
                 on_cast: nil,
                 on_delete: :nothing,
                 on_replace: :raise,
                 ordered: false,
                 owner: ExampleEctoSchema,
                 owner_key: :id,
                 queryable: ExampleEctoSchemaHasMany,
                 related: ExampleEctoSchemaHasMany,
                 related_key: :example_ecto_schema_id,
                 relationship: :child,
                 unique: true,
                 where: []
               }
             ],
             embeds: [
               %Ecto.Embedded{
                 cardinality: :one,
                 field: :example_ecto_schema_embed,
                 on_cast: nil,
                 on_replace: :raise,
                 ordered: true,
                 owner: ExampleEctoSchema,
                 related: ExampleEctoSchemaEmbed,
                 unique: true
               }
             ],
             non_virtual_fields: [
               id: :id,
               decimal: :decimal,
               float: :float,
               integer: :integer,
               string: :string,
               naive_datetime: :naive_datetime,
               naive_datetime_usec: :naive_datetime_usec,
               utc_datetime: :utc_datetime,
               utc_datetime_usec: :utc_datetime_usec,
               date: :date,
               time: :time,
               time_usec: :time_usec
             ],
             virtual_fields: [
               :virtual_date,
               :virtual_decimal,
               :virtual_float,
               :virtual_integer,
               :virtual_naive_datetime,
               :virtual_naive_datetime_usec,
               :virtual_string,
               :virtual_time,
               :virtual_time_usec,
               :virtual_utc_datetime,
               :virtual_utc_datetime_usec
             ]
           }
  end

  describe ".describe/1" do
    test "with ExampleEctoSchema" do
      schema = ExampleEctoSchema

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               primary_key_fields: [id: :id],
               assocs: [
                 %Ecto.Association.Has{
                   cardinality: :one,
                   defaults: [],
                   field: :example_ecto_schema_has_one,
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: ExampleEctoSchema,
                   owner_key: :id,
                   queryable: ExampleEctoSchemaHasOne,
                   related: ExampleEctoSchemaHasOne,
                   related_key: :example_ecto_schema_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.Has{
                   cardinality: :many,
                   defaults: [],
                   field: :example_ecto_schema_has_many,
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: ExampleEctoSchema,
                   owner_key: :id,
                   queryable: ExampleEctoSchemaHasMany,
                   related: ExampleEctoSchemaHasMany,
                   related_key: :example_ecto_schema_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 }
               ],
               embeds: [
                 %Ecto.Embedded{
                   cardinality: :one,
                   field: :example_ecto_schema_embed,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: ExampleEctoSchema,
                   related: ExampleEctoSchemaEmbed,
                   unique: true
                 }
               ],
               non_virtual_fields: [
                 id: :id,
                 decimal: :decimal,
                 float: :float,
                 integer: :integer,
                 string: :string,
                 naive_datetime: :naive_datetime,
                 naive_datetime_usec: :naive_datetime_usec,
                 utc_datetime: :utc_datetime,
                 utc_datetime_usec: :utc_datetime_usec,
                 date: :date,
                 time: :time,
                 time_usec: :time_usec
               ],
               virtual_fields: [
                 :virtual_date,
                 :virtual_decimal,
                 :virtual_float,
                 :virtual_integer,
                 :virtual_naive_datetime,
                 :virtual_naive_datetime_usec,
                 :virtual_string,
                 :virtual_time,
                 :virtual_time_usec,
                 :virtual_utc_datetime,
                 :virtual_utc_datetime_usec
               ]
             }
    end

    test "with Ecto.Integration.Post" do
      schema = Ecto.Integration.Post

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.Has{
                   cardinality: :many,
                   defaults: [],
                   field: :comments,
                   on_cast: nil,
                   on_delete: :delete_all,
                   on_replace: :delete,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.Comment,
                   related: Ecto.Integration.Comment,
                   related_key: :post_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.Has{
                   cardinality: :one,
                   defaults: [],
                   field: :permalink,
                   on_cast: nil,
                   on_delete: :delete_all,
                   on_replace: :delete,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.Permalink,
                   related: Ecto.Integration.Permalink,
                   related_key: :post_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.Has{
                   cardinality: :one,
                   defaults: [],
                   field: :update_permalink,
                   on_cast: nil,
                   on_delete: :delete_all,
                   on_replace: :update,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.Permalink,
                   related: Ecto.Integration.Permalink,
                   related_key: :post_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.HasThrough{
                   cardinality: :many,
                   field: :comments_authors,
                   on_cast: nil,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   relationship: :child,
                   through: [:comments, :author],
                   unique: true
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :author,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :author_id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :users,
                   join_defaults: [],
                   join_keys: [post_id: :id, user_id: :id],
                   join_through: "posts_users",
                   join_where: [],
                   on_cast: nil,
                   on_delete: :delete_all,
                   on_replace: :delete,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   relationship: :child,
                   unique: false,
                   where: []
                 },
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :unique_users,
                   join_defaults: [],
                   join_keys: [post_id: :id, user_id: :id],
                   join_through: "posts_users",
                   join_where: [],
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :constraint_users,
                   join_defaults: [],
                   join_keys: [post_id: :id, user_id: :id],
                   join_through: Ecto.Integration.PostUserCompositePk,
                   join_where: [],
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   relationship: :child,
                   unique: false,
                   where: []
                 },
                 %Ecto.Association.HasThrough{
                   cardinality: :many,
                   field: :users_comments,
                   on_cast: nil,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   relationship: :child,
                   through: [:users, :comments],
                   unique: true
                 },
                 %Ecto.Association.HasThrough{
                   cardinality: :many,
                   field: :comments_authors_permalinks,
                   on_cast: nil,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   relationship: :child,
                   through: [:comments_authors, :permalink],
                   unique: true
                 },
                 %Ecto.Association.Has{
                   cardinality: :one,
                   defaults: [],
                   field: :post_user_composite_pk,
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Post,
                   owner_key: :id,
                   queryable: Ecto.Integration.PostUserCompositePk,
                   related: Ecto.Integration.PostUserCompositePk,
                   related_key: :post_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:counter, :id},
                 {:title, :string},
                 {:blob, :binary},
                 {:public, :boolean},
                 {:cost, :decimal},
                 {:visits, :integer},
                 {:wrapped_visits, WrappedInteger},
                 {:intensity, :float},
                 {:bid, :binary_id},
                 {:uuid, Ecto.UUID},
                 {:meta, :map},
                 {:links, {:map, :string}},
                 {:intensities, {:map, :float}},
                 {:posted, :date},
                 {:author_id, :id},
                 {:inserted_at, :naive_datetime},
                 {:updated_at, :naive_datetime}
               ],
               primary_key_fields: [{:id, :id}],
               virtual_fields: [:temp]
             }
    end

    test "with Ecto.Integration.Comment" do
      schema = Ecto.Integration.Comment

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :post,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Comment,
                   owner_key: :post_id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :author,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Comment,
                   owner_key: :author_id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.HasThrough{
                   cardinality: :one,
                   field: :post_permalink,
                   on_cast: nil,
                   ordered: false,
                   owner: Ecto.Integration.Comment,
                   owner_key: :post_id,
                   relationship: :child,
                   through: [:post, :permalink],
                   unique: true
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:text, :string},
                 {:lock_version, :integer},
                 {:post_id, :id},
                 {:author_id, :id}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end

    test "with Ecto.Integration.Permalink" do
      schema = Ecto.Integration.Permalink

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :post,
                   on_cast: nil,
                   on_replace: :nilify,
                   ordered: false,
                   owner: Ecto.Integration.Permalink,
                   owner_key: :post_id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :update_post,
                   on_cast: nil,
                   on_replace: :update,
                   ordered: false,
                   owner: Ecto.Integration.Permalink,
                   owner_key: :post_id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :user,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Permalink,
                   owner_key: :user_id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.HasThrough{
                   cardinality: :many,
                   field: :post_comments_authors,
                   on_cast: nil,
                   ordered: false,
                   owner: Ecto.Integration.Permalink,
                   owner_key: :post_id,
                   relationship: :child,
                   through: [:post, :comments_authors],
                   unique: true
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:url, :string},
                 {:title, :string},
                 {:post_id, :id},
                 {:user_id, :id}
               ],
               primary_key_fields: [{:id, :id}],
               virtual_fields: [:posted]
             }
    end

    test "with Ecto.Integration.PostUser" do
      schema = Ecto.Integration.PostUser

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :user,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.PostUser,
                   owner_key: :user_id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :post,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.PostUser,
                   owner_key: :post_id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:user_id, :id},
                 {:post_id, :id},
                 {:inserted_at, :naive_datetime},
                 {:updated_at, :naive_datetime}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end

    test "with Ecto.Integration.User" do
      schema = Ecto.Integration.User

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.Has{
                   cardinality: :many,
                   defaults: [],
                   field: :comments,
                   on_cast: nil,
                   on_delete: :nilify_all,
                   on_replace: :nilify,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :id,
                   queryable: Ecto.Integration.Comment,
                   related: Ecto.Integration.Comment,
                   related_key: :author_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.Has{
                   cardinality: :one,
                   defaults: [],
                   field: :permalink,
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :nilify,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :id,
                   queryable: Ecto.Integration.Permalink,
                   related: Ecto.Integration.Permalink,
                   related_key: :user_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.Has{
                   cardinality: :many,
                   defaults: [],
                   field: :posts,
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :delete,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :author_id,
                   relationship: :child,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :custom,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :custom_id,
                   queryable: Ecto.Integration.Custom,
                   related: Ecto.Integration.Custom,
                   related_key: :bid,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :schema_posts,
                   join_defaults: [],
                   join_keys: [user_id: :id, post_id: :id],
                   join_through: Ecto.Integration.PostUser,
                   join_where: [],
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   relationship: :child,
                   unique: false,
                   where: []
                 },
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :unique_posts,
                   join_defaults: [],
                   join_keys: [user_id: :id, post_id: :id],
                   join_through: Ecto.Integration.PostUserCompositePk,
                   join_where: [],
                   on_cast: nil,
                   on_delete: :nothing,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.User,
                   owner_key: :id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   relationship: :child,
                   unique: false,
                   where: []
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:name, :string},
                 {:custom_id, :binary_id},
                 {:inserted_at, :utc_datetime},
                 {:updated_at, :utc_datetime}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end

    test "with Ecto.Integration.Custom" do
      schema = Ecto.Integration.Custom

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.ManyToMany{
                   cardinality: :many,
                   defaults: [],
                   field: :customs,
                   join_defaults: [],
                   join_keys: [custom_id1: :bid, custom_id2: :bid],
                   join_through: "customs_customs",
                   join_where: [],
                   on_cast: nil,
                   on_delete: :delete_all,
                   on_replace: :delete,
                   ordered: false,
                   owner: Ecto.Integration.Custom,
                   owner_key: :bid,
                   queryable: Ecto.Integration.Custom,
                   related: Ecto.Integration.Custom,
                   relationship: :child,
                   unique: false,
                   where: []
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:bid, :binary_id},
                 {:uuid, Ecto.UUID}
               ],
               primary_key_fields: [{:bid, :binary_id}]
             }
    end

    test "with Ecto.Integration.Barebone" do
      schema = Ecto.Integration.Barebone

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               non_virtual_fields: [{:num, :integer}]
             }
    end

    test "with Ecto.Integration.Tag" do
      schema = Ecto.Integration.Tag

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               embeds: [
                 %Ecto.Embedded{
                   cardinality: :many,
                   field: :items,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: Ecto.Integration.Tag,
                   related: Ecto.Integration.Item,
                   unique: true
                 }
               ],
               non_virtual_fields: [
                 {:id, :id},
                 {:ints, {:array, :integer}},
                 {:uuids, {:array, Ecto.UUID}}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end

    test "with Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               embeds: [
                 %Ecto.Embedded{
                   cardinality: :one,
                   field: :primary_color,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: Ecto.Integration.Item,
                   related: Ecto.Integration.ItemColor,
                   unique: true
                 },
                 %Ecto.Embedded{
                   cardinality: :many,
                   field: :secondary_colors,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: Ecto.Integration.Item,
                   related: Ecto.Integration.ItemColor,
                   unique: true
                 }
               ],
               non_virtual_fields: [
                 {:id, :binary_id},
                 {:reference, PrefixedString},
                 {:price, :integer},
                 {:valid_at, :date}
               ],
               primary_key_fields: [{:id, :binary_id}]
             }
    end

    test "with Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :binary_id},
                 {:name, :string}
               ],
               primary_key_fields: [{:id, :binary_id}]
             }
    end

    test "with Ecto.Integration.Order" do
      schema = Ecto.Integration.Order

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :permalink,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.Order,
                   owner_key: :permalink_id,
                   queryable: Ecto.Integration.Permalink,
                   related: Ecto.Integration.Permalink,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 }
               ],
               ecto_schema?: true,
               embeds: [
                 %Ecto.Embedded{
                   cardinality: :one,
                   field: :item,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: Ecto.Integration.Order,
                   related: Ecto.Integration.Item,
                   unique: true
                 },
                 %Ecto.Embedded{
                   cardinality: :many,
                   field: :items,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: true,
                   owner: Ecto.Integration.Order,
                   related: Ecto.Integration.Item,
                   unique: true
                 }
               ],
               non_virtual_fields: [
                 {:id, :id},
                 {:meta, :map},
                 {:permalink_id, :id}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end

    test "with Ecto.Integration.CompositePk" do
      schema = Ecto.Integration.CompositePk

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               non_virtual_fields: [
                 {:a, :integer},
                 {:b, :integer},
                 {:name, :string}
               ],
               primary_key_fields: [{:a, :integer}, {:b, :integer}]
             }
    end

    test "with Ecto.Integration.CorruptedPk" do
      schema = Ecto.Integration.CorruptedPk

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               non_virtual_fields: [{:a, :string}],
               primary_key_fields: [{:a, :string}]
             }
    end

    test "with Ecto.Integration.PostUserCompositePk" do
      schema = Ecto.Integration.PostUserCompositePk

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               assocs: [
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :user,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.PostUserCompositePk,
                   owner_key: :user_id,
                   queryable: Ecto.Integration.User,
                   related: Ecto.Integration.User,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 },
                 %Ecto.Association.BelongsTo{
                   cardinality: :one,
                   defaults: [],
                   field: :post,
                   on_cast: nil,
                   on_replace: :raise,
                   ordered: false,
                   owner: Ecto.Integration.PostUserCompositePk,
                   owner_key: :post_id,
                   queryable: Ecto.Integration.Post,
                   related: Ecto.Integration.Post,
                   related_key: :id,
                   relationship: :parent,
                   unique: true,
                   where: []
                 }
               ],
               ecto_schema?: true,
               non_virtual_fields: [
                 {:user_id, :id},
                 {:post_id, :id},
                 {:inserted_at, :naive_datetime},
                 {:updated_at, :naive_datetime}
               ],
               primary_key_fields: [{:user_id, :id}, {:post_id, :id}]
             }
    end

    test "with Ecto.Integration.Usec" do
      schema = Ecto.Integration.Usec

      assert EctoSchemaReflection.describe(schema) == %EctoSchemaReflection{
               ecto_schema?: true,
               non_virtual_fields: [
                 {:id, :id},
                 {:naive_datetime_usec, :naive_datetime_usec},
                 {:utc_datetime_usec, :utc_datetime_usec}
               ],
               primary_key_fields: [{:id, :id}]
             }
    end
  end
end
