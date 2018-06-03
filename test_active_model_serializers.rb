require "./test_helper"

require "active_record"
require "active_model_serializers"

class TestActiveModelSerializers < Test::Unit::TestCase
  setup do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :users do |t|
        t.string :name
        t.timestamps
      end
      create_table :comments do |t|
        t.belongs_to :user
        t.string :body
        t.timestamps
      end
    end

    class User < ActiveRecord::Base
      has_many :comments
      has_one :comment
    end

    class Comment < ActiveRecord::Base
      belongs_to :user
    end

    @user = User.create!(name: "alice")
    @user.comments.create!(body: "a")
    @user.comments.create!(body: "b")

    ActiveModelSerializers.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    ActiveModelSerializers.logger = nil
  end

  sub_test_case "親クラスを継承すことで定義を共有化" do
    setup do
      @application_serializer = Class.new(ActiveModel::Serializer) do
        attribute :id
      end
      @user_serializer = Class.new(@application_serializer) do
        attributes :name
      end
    end

    test "" do
      assert_equal({:id=>1, :name=>"alice"}, ams_sr(@user, serializer: @user_serializer))
    end
  end

  sub_test_case "属性に小細工する" do
    setup do
      @user_serializer = Class.new(ActiveModel::Serializer) do
        attribute :name do
          "(#{object.name})"
        end

        attribute :name2
        def name2
          object.name
        end

        attribute :name3, :if => :is_ok do
          object.name
        end

        def is_ok
          true
        end
      end
    end

    test "" do
      assert_equal({:name=>"(alice)", :name2=>"alice", :name3=>"alice"}, ams_sr(@user, serializer: @user_serializer))
    end
  end

  sub_test_case "associations options" do
    test "" do
      assert_equal([:foo], ams_sr(@user, serializer: def_class { has_one :comment, key: :foo }).keys)
      assert_equal({:comment=>{:body=>"a"}}, ams_sr(@user, serializer: def_class.tap { |c| c.has_one :comment, serializer: def_class { attribute :body } }))
      assert_equal([], ams_sr(@user, serializer: def_class { has_one :comment, :if => -> { false } }).keys)
      assert_equal([], ams_sr(@user, serializer: def_class { has_one :comment, :if => "false" }).keys)
      assert_equal([:comment], ams_sr(@user, serializer: def_class { has_one :comment, :if => -> s { s.object.name == "alice" } }).keys)
      assert_equal({:comment=>"foo"}, ams_sr(@user, serializer: def_class.tap { |c| c.has_one :comment, virtual_value: "foo", serializer: def_class { attribute :body } }))
      # ams_sr(@user, serializer: def_class { has_one :comment, :if => -> { p scope }; def foo?; true; end; }).keys.should                               == []
    end
  end

  sub_test_case "Associations" do
    setup do
      @user_serializer = Class.new(ActiveModel::Serializer) do
        attributes :name

        comment_serializer = Class.new(ActiveModel::Serializer) do
          attributes :body
        end

        has_many :comments, serializer: comment_serializer
        has_one :comment, serializer: comment_serializer
      end

      @comment_serializer = Class.new(ActiveModel::Serializer).tap do |c|
        c.attributes :body
        c.belongs_to :user, serializer: @user_serializer
      end
    end

    test "何も指定しないと1段階まで" do
      assert_equal({:name=>"alice", :comments=>[{:body=>"a"}, {:body=>"b"}], :comment=>{:body=>"a"}}, ams_sr(@user, serializer: @user_serializer))
    end

    test "デフォルトでは一段階のみ展開するので user_serializer の has_one :comment までは展開されない" do
      assert_equal({:body=>"a", :user=>{:name=>"alice"}}, ams_sr(@user.comment, serializer: @comment_serializer))
    end

    test "リレーションの先まで展開するには include で明示的に指定する" do
      assert_equal({:body=>"a", :user=>{:name=>"alice", :comment=>{:body=>"a"}}}, ams_sr(@user.comment, serializer: @comment_serializer, include: {user: :comment}))
    end
  end

  sub_test_case "ActiveModelSerializers.config" do
    setup do
      tp ActiveModelSerializers.config
      @user_serializer = Class.new(ActiveModel::Serializer) do
        attributes :name
      end
      @save_config = ActiveModelSerializers.config.dup
    end

    teardown do
      ActiveModelSerializers.config.replace(@save_config)
    end

    test "key_transform が camel の場合" do
      ActiveModelSerializers.config[:key_transform] = :camel
      assert_equal({:Name=>"alice"}, ams_sr(@user, serializer: @user_serializer))
    end
  end

  def ams_sr(*args)
    ActiveModelSerializers::SerializableResource.new(*args).as_json
  end

  def def_class(&block)
    Class.new(ActiveModel::Serializer, &block)
  end
end
# >> Loaded suite -
# >> Started
# >> |----------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                              collection_serializer | ActiveModel::Serializer::CollectionSerializer                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
# >> |                          serializer_lookup_enabled | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
# >> |                                   default_includes | *                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
# >> |                                            adapter | attributes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
# >> |                                      key_transform |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
# >> |                   jsonapi_pagination_links_enabled | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
# >> |                              jsonapi_resource_type | plural                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
# >> |                        jsonapi_namespace_separator | -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
# >> |                                    jsonapi_version | 1.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
# >> |                              jsonapi_toplevel_meta | {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
# >> |                    jsonapi_include_toplevel_object | false                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
# >> | jsonapi_use_foreign_key_on_belongs_to_relationship | false                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
# >> |                               include_data_default | true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
# >> |                            serializer_lookup_chain | [#<Proc:0x00007f92e6a129f0@/usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/lookup_chain.rb:47 (lambda)>, #<Proc:0x00007f92e6a12a18@/usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/lookup_chain.rb:26 (lambda)>, #<Proc:0x00007f92e6a12a40@/usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/lookup_chain.rb:15 (lambda)>, #<Proc:0x00007f92e6a12a68@/usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers/lookup_chain.rb:7 (lambda)>] |
# >> |                                        schema_path | test/support/schemas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
# >> |----------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> .......
# >> Finished in 0.443868 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 12 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 15.77 tests/s, 27.04 assertions/s
