Code.require_file("../../support/fixture_factories.exs", __DIR__)

defmodule DarkEcto.Reflections.ExMachinaFactoryReflectionTest do
  @moduledoc """
  Test for DarkEcto.Reflections.ExMachinaFactoryReflection
  """

  use ExUnit.Case, async: true

  alias DarkEcto.Reflections.ExMachinaFactoryReflection

  describe ".factories/1" do
    test "given a valid factory module" do
      factory = DarkEcto.TestFactory

      assert ExMachinaFactoryReflection.factories(factory) == [
               [ExampleEctoSchema, :example_ecto_schema, %ExampleEctoSchema{}],
               [
                 DarkEcto.TestFactory.TestStruct,
                 :example_test_struct,
                 %DarkEcto.TestFactory.TestStruct{
                   a: 100,
                   b: 100,
                   c: nil,
                   d: nil,
                   matcher: nil,
                   no_matcher: nil
                 }
               ],
               [
                 DarkEcto.TestFactory.TestStruct,
                 :example_test_with_struct_mutation,
                 %DarkEcto.TestFactory.TestStruct{
                   a: 2,
                   b: nil,
                   c: 4,
                   d: nil,
                   matcher: nil,
                   no_matcher: true
                 }
               ]
             ]
    end
  end

  describe ".factory_entries/1" do
    test "given a valid factory module" do
      factory = DarkEcto.TestFactory

      assert ExMachinaFactoryReflection.factory_entries(factory) == [
               {DarkEcto.TestFactory.TestStruct,
                [
                  %{
                    data: %DarkEcto.TestFactory.TestStruct{
                      a: 100,
                      b: 100
                    },
                    default: true,
                    factory_atom: :example_test_struct,
                    module: DarkEcto.TestFactory.TestStruct
                  },
                  %{
                    data: %DarkEcto.TestFactory.TestStruct{
                      a: 2,
                      c: 4,
                      no_matcher: true
                    },
                    default: false,
                    factory_atom: :example_test_with_struct_mutation,
                    module: DarkEcto.TestFactory.TestStruct
                  }
                ]},
               {ExampleEctoSchema,
                [
                  %{
                    data: %ExampleEctoSchema{
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
                      virtual_utc_datetime_usec: nil
                    },
                    default: true,
                    factory_atom: :example_ecto_schema,
                    module: ExampleEctoSchema
                  }
                ]}
             ]
    end
  end

  describe ".factory_modules/1" do
    test "given a valid factory module" do
      factory = DarkEcto.TestFactory

      assert ExMachinaFactoryReflection.factory_modules(factory) == [
               ExampleEctoSchema,
               DarkEcto.TestFactory.TestStruct
             ]
    end
  end

  describe ".factory_named_modules/1" do
    test "given a valid factory module" do
      factory = DarkEcto.TestFactory

      assert ExMachinaFactoryReflection.factory_named_modules(factory) == [
               %{
                 alias: :ExampleEctoSchema,
                 module: ExampleEctoSchema,
                 plural: :example_ecto_schemas,
                 singular: :example_ecto_schema
               },
               %{
                 alias: :TestStruct,
                 module: DarkEcto.TestFactory.TestStruct,
                 plural: :test_structs,
                 singular: :test_struct
               }
             ]
    end
  end

  describe ".typescript_types/1" do
    test "given a valid factory module" do
      factory = DarkEcto.TestFactory

      assert ExMachinaFactoryReflection.typescript_types(factory) == [
               %{
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
                 embed_one_relations: [{"exampleEctoSchemaEmbed", ExampleEctoSchemaEmbed}],
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
                 ],
                 assoc_imports: [
                   ExampleEctoSchemaHasMany,
                   ExampleEctoSchemaHasOne
                 ],
                 embed_imports: [ExampleEctoSchemaEmbed],
                 embed_many_relations: [],
                 enums: [],
                 fk_fields: [],
                 imports: [
                   ExampleEctoSchemaEmbed,
                   ExampleEctoSchemaHasMany,
                   ExampleEctoSchemaHasOne
                 ],
                 non_virtual_fields: [
                   date: :date,
                   decimal: :decimal,
                   float: :float,
                   integer: :integer,
                   naive_datetime: :naive_datetime,
                   naive_datetime_usec: :naive_datetime_usec,
                   string: :string,
                   time: :time,
                   time_usec: :time_usec,
                   utc_datetime: :utc_datetime,
                   utc_datetime_usec: :utc_datetime_usec
                 ],
                 pk_fields: [id: :id],
                 virtual_fields: [
                   virtual_date: :__ecto_virtual_field__,
                   virtual_decimal: :__ecto_virtual_field__,
                   virtual_float: :__ecto_virtual_field__,
                   virtual_integer: :__ecto_virtual_field__,
                   virtual_naive_datetime: :__ecto_virtual_field__,
                   virtual_naive_datetime_usec: :__ecto_virtual_field__,
                   virtual_string: :__ecto_virtual_field__,
                   virtual_time: :__ecto_virtual_field__,
                   virtual_time_usec: :__ecto_virtual_field__,
                   virtual_utc_datetime: :__ecto_virtual_field__,
                   virtual_utc_datetime_usec: :__ecto_virtual_field__
                 ],
                 required_fields: [],
                 command_singulars: [:update],
                 alias_plural: :ExampleEctoSchemas,
                 blank?: false,
                 persisted?: true
               },
               %{
                 alias: :TestStruct,
                 alias_plural: :TestStructs,
                 assoc_imports: [],
                 blank?: true,
                 command_singulars: [:update],
                 embed_imports: [],
                 embed_one_relations: [],
                 embed_many_relations: [],
                 enums: [],
                 factory: [],
                 fk_fields: [],
                 human_plural: "Test structs",
                 human_singular: "Test struct",
                 import_aliases: [],
                 imports: [],
                 many_relations: [],
                 module: DarkEcto.TestFactory.TestStruct,
                 non_virtual_fields: [],
                 one_relations: [],
                 persisted?: false,
                 pk_fields: [],
                 plural: "testStructs",
                 required_fields: [],
                 singular: "testStruct",
                 type_d: [
                   {"a", "Object"},
                   {"b", "Object"},
                   {"c", "Object"},
                   {"d", "Object"},
                   {"matcher", "Object"},
                   {"noMatcher", "Object"}
                 ],
                 virtual_fields: []
               }
             ]
    end
  end
end
