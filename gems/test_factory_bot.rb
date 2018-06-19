require "../test_helper"

require "active_record"
require "factory_bot"

ActiveRecord::Migration.verbose = false

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
  create_table :articles do |t|
    t.belongs_to :user
    t.string :name
    t.integer :price
  end
end

class User < ActiveRecord::Base
  has_many :articles, dependent: :destroy
end

class Article < ActiveRecord::Base
  belongs_to :user
end

FactoryBot.define do
  factory :user, :class => User do
    name :alice
  end
end

FactoryBot.define do
  factory :article, :class => Article do
  end
end

class TestFactoryBot < Test::Unit::TestCase
  setup do
    User.destroy_all
  end

  test "build" do
    assert { FactoryBot.build(:user).attributes == {"id"=>nil, "name"=>"alice"} }
  end

  test "create" do
    assert { FactoryBot.create(:user).attributes == {"id"=>1, "name"=>"alice"} }

    user = FactoryBot.create(:user) do |user|
      FactoryBot.create(:article, user: user)
    end
    assert { user.articles.count == 1 }
  end

  test "attributes_for" do
    assert { FactoryBot.attributes_for(:user) == {:name=>:alice} }
  end

  test "build_stubbed" do
    assert { FactoryBot.build_stubbed(:user).attributes == {"id"=>1001, "name"=>"alice"} }
  end

  test "create_list" do
    assert { FactoryBot.create_list(:user, 2).collect(&:id) == [3, 4] }
  end

  test "build_list" do
    assert { FactoryBot.build_list(:user, 2).collect(&:id) == [nil, nil] }
  end

  test "attributes_for_list" do
    assert { FactoryBot.attributes_for_list(:user, 2, name: "bob") == [{:name=>"bob"}, {:name=>"bob"}] }
  end

  test "build_stubbed_list" do
    assert { FactoryBot.build_stubbed_list(:user, 2, name: "bob").collect(&:id) == [1002, 1003] }
  end
end
# >> Loaded suite -
# >> Started
# >> ........
# >> Finished in 0.036644 seconds.
# >> -------------------------------------------------------------------------------
# >> 8 tests, 9 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 218.32 tests/s, 245.61 assertions/s
