defmodule DarkEcto.Projections.TypescriptTest do
  @moduledoc """
  Test for `DarkEcto.Projections.Typescript`
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Projections.Typescript
  alias DarkEcto.Reflections.EctoSchemaFields

  describe ".cast/1" do
    @tag :focus
    test "with ExampleEctoSchema" do
      schema = ExampleEctoSchema

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :ExampleEctoSchema,
                 factory: [
                   {"exampleEctoSchemaHasOne", "exampleEctoSchemaHasOne.build()"},
                   {"exampleEctoSchemaHasMany", "exampleEctoSchemaHasMany.buildList(0)"},
                   {"exampleEctoSchemaEmbed", "exampleEctoSchemaEmbed.build()"}
                 ],
                 human_plural: "Example ecto schemas",
                 human_singular: "Example ecto schema",
                 import_aliases: [
                   {ExampleEctoSchemaEmbed, :ExampleEctoSchemaEmbed},
                   {ExampleEctoSchemaHasMany, :ExampleEctoSchemaHasMany},
                   {ExampleEctoSchemaHasOne, :ExampleEctoSchemaHasOne}
                 ],
                 many_relations: [
                   {"exampleEctoSchemaHasMany", ExampleEctoSchemaHasMany}
                 ],
                 module: ExampleEctoSchema,
                 embed_one_relations: [
                   {"exampleEctoSchemaEmbed", ExampleEctoSchemaEmbed}
                 ],
                 one_relations: [{"exampleEctoSchemaHasOne", ExampleEctoSchemaHasOne}],
                 plural: "exampleEctoSchemas",
                 singular: "exampleEctoSchema",
                 type_d: [
                   {"id", "ID"},
                   {"date", "DateStr"},
                   {"decimal", "Decimal"},
                   {"float", "number"},
                   {"integer", "Int"},
                   {"naiveDatetime", "DateTimeStr"},
                   {"naiveDatetimeUsec", "DateTimeStr"},
                   {"string", "string"},
                   {"time", "TimeStr"},
                   {"timeUsec", "TimeStr"},
                   {"utcDatetime", "DateTimeStr"},
                   {"utcDatetimeUsec", "DateTimeStr"},
                   {"virtualDate", "any"},
                   {"virtualDecimal", "any"},
                   {"virtualFloat", "any"},
                   {"virtualInteger", "any"},
                   {"virtualNaiveDatetime", "any"},
                   {"virtualNaiveDatetimeUsec", "any"},
                   {"virtualString", "any"},
                   {"virtualTime", "any"},
                   {"virtualTimeUsec", "any"},
                   {"virtualUtcDatetime", "any"},
                   {"virtualUtcDatetimeUsec", "any"},
                   {"exampleEctoSchemaHasOne", "ExampleEctoSchemaHasOne"},
                   {"exampleEctoSchemaHasMany", "ExampleEctoSchemaHasMany[]"},
                   {"exampleEctoSchemaEmbed", "ExampleEctoSchemaEmbed"}
                 ]
               })
    end

    test "with Ecto.Integration.Post" do
      schema = Ecto.Integration.Post

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Post,
                 factory: [
                   {"author", "user.build()"},
                   {"permalink", "permalink.build()"},
                   {"postUserCompositePk", "postUserCompositePk.build()"},
                   {"updatePermalink", "permalink.build()"},
                   {"comments", "comment.buildList(0)"},
                   {"commentsAuthors", "user.buildList(0)"},
                   {"commentsAuthorsPermalinks", "commentsAuthorsPermalink.buildList(0)"},
                   {"constraintUsers", "user.buildList(0)"},
                   {"uniqueUsers", "user.buildList(0)"},
                   {"users", "user.buildList(0)"},
                   {"usersComments", "comment.buildList(0)"}
                 ],
                 human_plural: "Posts",
                 human_singular: "Post",
                 import_aliases: [
                   {Ecto.Integration.Comment, :Comment},
                   {Ecto.Integration.Permalink, :Permalink},
                   {Ecto.Integration.PostUserCompositePk, :PostUserCompositePk},
                   {Ecto.Integration.User, :User}
                 ],
                 many_relations: [
                   {"comments", Ecto.Integration.Comment},
                   {"commentsAuthors", Ecto.Integration.User},
                   #  {"commentsAuthorsPermalinks", Ecto.Integration.Permalink},
                   {"commentsAuthorsPermalinks", :__ecto_join_table__},
                   {"constraintUsers", Ecto.Integration.User},
                   {"uniqueUsers", Ecto.Integration.User},
                   {"users", Ecto.Integration.User},
                   {"usersComments", Ecto.Integration.Comment}
                 ],
                 module: Ecto.Integration.Post,
                 one_relations: [
                   {"author", Ecto.Integration.User},
                   {"permalink", Ecto.Integration.Permalink},
                   {"postUserCompositePk", Ecto.Integration.PostUserCompositePk},
                   {"updatePermalink", Ecto.Integration.Permalink}
                 ],
                 plural: "posts",
                 singular: "post",
                 type_d: [
                   {"id", "ID"},
                   {"authorId", "ID"},
                   {"bid", "UUID4"},
                   {"counter", "ID"},
                   {"uuid", "UUID4"},
                   {"blob", "string"},
                   {"cost", "Decimal"},
                   {"intensities", "Object"},
                   {"intensity", "number"},
                   {"links", "Object"},
                   {"meta", "Object"},
                   {"posted", "DateStr"},
                   {"public", "boolean"},
                   {"title", "string"},
                   {"visits", "Int"},
                   {"wrappedVisits", "WrappedInteger"},
                   {"insertedAt", "DateTimeStr"},
                   {"updatedAt", "DateTimeStr"},
                   {"temp", "any"},
                   {"author", "User"},
                   {"permalink", "Permalink"},
                   {"postUserCompositePk", "PostUserCompositePk"},
                   {"updatePermalink", "Permalink"},
                   {"comments", "Comment[]"},
                   {"commentsAuthors", "User[]"},
                   {"commentsAuthorsPermalinks", "Object[]"},
                   {"constraintUsers", "User[]"},
                   {"uniqueUsers", "User[]"},
                   {"users", "User[]"},
                   {"usersComments", "Comment[]"}
                 ]
               })
    end

    test "with Ecto.Integration.Comment" do
      schema = Ecto.Integration.Post

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Post,
                 factory: [
                   {"author", "user.build()"},
                   {"permalink", "permalink.build()"},
                   {"postUserCompositePk", "postUserCompositePk.build()"},
                   {"updatePermalink", "permalink.build()"},
                   {"comments", "comment.buildList(0)"},
                   {"commentsAuthors", "user.buildList(0)"},
                   {"commentsAuthorsPermalinks", "commentsAuthorsPermalink.buildList(0)"},
                   {"constraintUsers", "user.buildList(0)"},
                   {"uniqueUsers", "user.buildList(0)"},
                   {"users", "user.buildList(0)"},
                   {"usersComments", "comment.buildList(0)"}
                 ],
                 human_plural: "Posts",
                 human_singular: "Post",
                 import_aliases: [
                   {Ecto.Integration.Comment, :Comment},
                   {Ecto.Integration.Permalink, :Permalink},
                   {Ecto.Integration.PostUserCompositePk, :PostUserCompositePk},
                   {Ecto.Integration.User, :User}
                 ],
                 many_relations: [
                   {"comments", Ecto.Integration.Comment},
                   {"commentsAuthors", Ecto.Integration.User},
                   {"commentsAuthorsPermalinks", :__ecto_join_table__},
                   {"constraintUsers", Ecto.Integration.User},
                   {"uniqueUsers", Ecto.Integration.User},
                   {"users", Ecto.Integration.User},
                   {"usersComments", Ecto.Integration.Comment}
                 ],
                 module: Ecto.Integration.Post,
                 one_relations: [
                   {"author", Ecto.Integration.User},
                   {"permalink", Ecto.Integration.Permalink},
                   {"postUserCompositePk", Ecto.Integration.PostUserCompositePk},
                   {"updatePermalink", Ecto.Integration.Permalink}
                 ],
                 plural: "posts",
                 singular: "post",
                 type_d: [
                   {"id", "ID"},
                   {"authorId", "ID"},
                   {"bid", "UUID4"},
                   {"counter", "ID"},
                   {"uuid", "UUID4"},
                   {"blob", "string"},
                   {"cost", "Decimal"},
                   {"intensities", "Object"},
                   {"intensity", "number"},
                   {"links", "Object"},
                   {"meta", "Object"},
                   {"posted", "DateStr"},
                   {"public", "boolean"},
                   {"title", "string"},
                   {"visits", "Int"},
                   {"wrappedVisits", "WrappedInteger"},
                   {"insertedAt", "DateTimeStr"},
                   {"updatedAt", "DateTimeStr"},
                   {"temp", "any"},
                   {"author", "User"},
                   {"permalink", "Permalink"},
                   {"postUserCompositePk", "PostUserCompositePk"},
                   {"updatePermalink", "Permalink"},
                   {"comments", "Comment[]"},
                   {"commentsAuthors", "User[]"},
                   {"commentsAuthorsPermalinks", "Object[]"},
                   {"constraintUsers", "User[]"},
                   {"uniqueUsers", "User[]"},
                   {"users", "User[]"},
                   {"usersComments", "Comment[]"}
                 ]
               })
    end

    test "with Ecto.Integration.Permalink" do
      schema = Ecto.Integration.Permalink

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Permalink,
                 factory: [
                   {"post", "post.build()"},
                   {"updatePost", "post.build()"},
                   {"user", "user.build()"},
                   {"postCommentsAuthors", "postCommentsAuthor.buildList(0)"}
                 ],
                 human_plural: "Permalinks",
                 human_singular: "Permalink",
                 import_aliases: [{Ecto.Integration.Post, :Post}, {Ecto.Integration.User, :User}],
                 many_relations: [{"postCommentsAuthors", :__ecto_join_table__}],
                 module: Ecto.Integration.Permalink,
                 one_relations: [
                   {"post", Ecto.Integration.Post},
                   {"updatePost", Ecto.Integration.Post},
                   {"user", Ecto.Integration.User}
                 ],
                 plural: "permalinks",
                 singular: "permalink",
                 type_d: [
                   {"id", "ID"},
                   {"postId", "ID"},
                   {"userId", "ID"},
                   {"title", "string"},
                   {"url", "string"},
                   {"posted", "any"},
                   {"post", "Post"},
                   {"updatePost", "Post"},
                   {"user", "User"},
                   {"postCommentsAuthors", "Object[]"}
                 ]
               })
    end

    test "with Ecto.Integration.PostUser" do
      schema = Ecto.Integration.PostUser

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :PostUser,
                 factory: [{"post", "post.build()"}, {"user", "user.build()"}],
                 human_plural: "Post users",
                 human_singular: "Post user",
                 import_aliases: [{Ecto.Integration.Post, :Post}, {Ecto.Integration.User, :User}],
                 many_relations: [],
                 module: Ecto.Integration.PostUser,
                 one_relations: [{"post", Ecto.Integration.Post}, {"user", Ecto.Integration.User}],
                 plural: "postUsers",
                 singular: "postUser",
                 type_d: [
                   {"id", "ID"},
                   {"postId", "ID"},
                   {"userId", "ID"},
                   {"insertedAt", "DateTimeStr"},
                   {"updatedAt", "DateTimeStr"},
                   {"post", "Post"},
                   {"user", "User"}
                 ]
               })
    end

    test "with Ecto.Integration.User" do
      schema = Ecto.Integration.User

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :User,
                 factory: [
                   {"custom", "custom.build()"},
                   {"permalink", "permalink.build()"},
                   {"comments", "comment.buildList(0)"},
                   {"posts", "post.buildList(0)"},
                   {"schemaPosts", "post.buildList(0)"},
                   {"uniquePosts", "post.buildList(0)"}
                 ],
                 human_plural: "Users",
                 human_singular: "User",
                 import_aliases: [
                   {Ecto.Integration.Comment, :Comment},
                   {Ecto.Integration.Custom, :Custom},
                   {Ecto.Integration.Permalink, :Permalink},
                   {Ecto.Integration.Post, :Post}
                 ],
                 many_relations: [
                   {"comments", Ecto.Integration.Comment},
                   {"posts", Ecto.Integration.Post},
                   {"schemaPosts", Ecto.Integration.Post},
                   {"uniquePosts", Ecto.Integration.Post}
                 ],
                 module: Ecto.Integration.User,
                 one_relations: [
                   {"custom", Ecto.Integration.Custom},
                   {"permalink", Ecto.Integration.Permalink}
                 ],
                 plural: "users",
                 singular: "user",
                 type_d: [
                   {"id", "ID"},
                   {"customId", "UUID4"},
                   {"name", "string"},
                   {"insertedAt", "DateTimeStr"},
                   {"updatedAt", "DateTimeStr"},
                   {"custom", "Custom"},
                   {"permalink", "Permalink"},
                   {"comments", "Comment[]"},
                   {"posts", "Post[]"},
                   {"schemaPosts", "Post[]"},
                   {"uniquePosts", "Post[]"}
                 ]
               })
    end

    test "with Ecto.Integration.Custom" do
      schema = Ecto.Integration.Custom

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Custom,
                 factory: [{"customs", "custom.buildList(0)"}],
                 human_plural: "Customs",
                 human_singular: "Custom",
                 import_aliases: [{Ecto.Integration.Custom, :Custom}],
                 many_relations: [{"customs", Ecto.Integration.Custom}],
                 module: Ecto.Integration.Custom,
                 one_relations: [],
                 plural: "customs",
                 singular: "custom",
                 type_d: [{"bid", "UUID4"}, {"uuid", "UUID4"}, {"customs", "Custom[]"}]
               })
    end

    test "with Ecto.Integration.Barebone" do
      schema = Ecto.Integration.Barebone

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Barebone,
                 factory: [],
                 human_plural: "Barebones",
                 human_singular: "Barebone",
                 import_aliases: [],
                 many_relations: [],
                 module: Ecto.Integration.Barebone,
                 one_relations: [],
                 plural: "barebones",
                 singular: "barebone",
                 type_d: [{"num", "Int"}]
               })
    end

    test "with Ecto.Integration.Tag" do
      schema = Ecto.Integration.Tag

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Tag,
                 factory: [{"items", "item.buildList(0)"}],
                 embed_many_relations: [
                   {"items", Ecto.Integration.Item}
                 ],
                 human_plural: "Tags",
                 human_singular: "Tag",
                 import_aliases: [{Ecto.Integration.Item, :Item}],
                 many_relations: [],
                 module: Ecto.Integration.Tag,
                 one_relations: [],
                 plural: "tags",
                 singular: "tag",
                 type_d: [
                   {"id", "ID"},
                   {"ints", "Int[]"},
                   {"uuids", "UUID4[]"},
                   {"items", "Item[]"}
                 ]
               })
    end

    test "with Ecto.Integration.Item" do
      schema = Ecto.Integration.Item

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Item,
                 embed_many_relations: [
                   {"secondaryColors", Ecto.Integration.ItemColor}
                 ],
                 embed_one_relations: [
                   {"primaryColor", Ecto.Integration.ItemColor}
                 ],
                 factory: [
                   {"primaryColor", "itemColor.build()"},
                   {"secondaryColors", "itemColor.buildList(0)"}
                 ],
                 human_plural: "Items",
                 human_singular: "Item",
                 import_aliases: [{Ecto.Integration.ItemColor, :ItemColor}],
                 many_relations: [],
                 module: Ecto.Integration.Item,
                 one_relations: [],
                 plural: "items",
                 singular: "item",
                 type_d: [
                   {"id", "UUID4"},
                   {"price", "Int"},
                   {"reference", "PrefixedString"},
                   {"validAt", "DateStr"},
                   {"primaryColor", "ItemColor"},
                   {"secondaryColors", "ItemColor[]"}
                 ]
               })
    end

    test "with Ecto.Integration.ItemColor" do
      schema = Ecto.Integration.ItemColor

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :ItemColor,
                 factory: [],
                 human_plural: "Item colors",
                 human_singular: "Item color",
                 import_aliases: [],
                 many_relations: [],
                 module: Ecto.Integration.ItemColor,
                 one_relations: [],
                 plural: "itemColors",
                 singular: "itemColor",
                 type_d: [{"id", "UUID4"}, {"name", "string"}]
               })
    end

    test "with Ecto.Integration.Order" do
      schema = Ecto.Integration.Order

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Order,
                 factory: [
                   {"permalink", "permalink.build()"},
                   {"item", "item.build()"},
                   {"items", "item.buildList(0)"}
                 ],
                 embed_many_relations: [
                   {"items", Ecto.Integration.Item}
                 ],
                 embed_one_relations: [{"item", Ecto.Integration.Item}],
                 human_plural: "Orders",
                 human_singular: "Order",
                 import_aliases: [
                   {Ecto.Integration.Item, :Item},
                   {Ecto.Integration.Permalink, :Permalink}
                 ],
                 many_relations: [],
                 module: Ecto.Integration.Order,
                 one_relations: [{"permalink", Ecto.Integration.Permalink}],
                 plural: "orders",
                 singular: "order",
                 type_d: [
                   {"id", "ID"},
                   {"permalinkId", "ID"},
                   {"meta", "Object"},
                   {"permalink", "Permalink"},
                   {"item", "Item"},
                   {"items", "Item[]"}
                 ]
               })
    end

    test "with Ecto.Integration.CompositePk" do
      schema = Ecto.Integration.CompositePk

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :CompositePk,
                 factory: [],
                 human_plural: "Composite pks",
                 human_singular: "Composite pk",
                 import_aliases: [],
                 many_relations: [],
                 module: Ecto.Integration.CompositePk,
                 one_relations: [],
                 plural: "compositePks",
                 singular: "compositePk",
                 type_d: [{"a", "Int"}, {"b", "Int"}, {"name", "string"}]
               })
    end

    test "with Ecto.Integration.CorruptedPk" do
      schema = Ecto.Integration.CorruptedPk

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :CorruptedPk,
                 factory: [],
                 human_plural: "Corrupted pks",
                 human_singular: "Corrupted pk",
                 import_aliases: [],
                 many_relations: [],
                 module: Ecto.Integration.CorruptedPk,
                 one_relations: [],
                 plural: "corruptedPks",
                 singular: "corruptedPk",
                 type_d: [{"a", "string"}]
               })
    end

    test "with Ecto.Integration.PostUserCompositePk" do
      schema = Ecto.Integration.PostUserCompositePk

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :PostUserCompositePk,
                 factory: [{"post", "post.build()"}, {"user", "user.build()"}],
                 human_plural: "Post user composite pks",
                 human_singular: "Post user composite pk",
                 import_aliases: [{Ecto.Integration.Post, :Post}, {Ecto.Integration.User, :User}],
                 many_relations: [],
                 module: Ecto.Integration.PostUserCompositePk,
                 one_relations: [{"post", Ecto.Integration.Post}, {"user", Ecto.Integration.User}],
                 plural: "postUserCompositePks",
                 singular: "postUserCompositePk",
                 type_d: [
                   {"postId", "ID"},
                   {"userId", "ID"},
                   {"insertedAt", "DateTimeStr"},
                   {"updatedAt", "DateTimeStr"},
                   {"post", "Post"},
                   {"user", "User"}
                 ]
               })
    end

    test "with Ecto.Integration.Usec" do
      schema = Ecto.Integration.Usec

      assert Typescript.cast(schema) ==
               Map.merge(Map.from_struct(EctoSchemaFields.cast(schema)), %{
                 alias: :Usec,
                 factory: [],
                 human_plural: "Usecs",
                 human_singular: "Usec",
                 import_aliases: [],
                 many_relations: [],
                 module: Ecto.Integration.Usec,
                 one_relations: [],
                 plural: "usecs",
                 singular: "usec",
                 type_d: [
                   {"id", "ID"},
                   {"naiveDatetimeUsec", "DateTimeStr"},
                   {"utcDatetimeUsec", "DateTimeStr"}
                 ]
               })
    end
  end
end
