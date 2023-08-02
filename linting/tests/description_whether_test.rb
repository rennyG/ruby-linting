# typed: true
# frozen_string_literal: true

require_relative "../cops_test"
require "test_helper"
require "development_support/cops/graphql/description_whether"

module Cops
  module GraphQL
    class DescriptionWhetherTest < CopsTest
      setup do
        config = RuboCop::Config.new(
          {
            "GraphQL/DescriptionWhether" => {
              "Enabled" => true,
            },
          },
          ""
        )
        @cop = DescriptionWhether.new(config)
      end

      # test "adds offense if 'Whether or not' is used in boolean field description and autocorrects" do
      #   assert_offense(<<~RUBY)
      #     field :user_active, :boolean, null: false, description: "Whether or not the user is active."
      #                                                                      ^^^^^^ #{DescriptionWhether::MSG}
      #   RUBY
      #   assert_correction(<<~RUBY)
      #     field :user_active, :boolean, null: false, description: "Whether the user is active."
      #   RUBY
      # end

      test "if boolean field description starts with an article, prepend 'Whether' and downcases the article" do
        assert_offense(<<~RUBY)
          field :user_active, :boolean, null: false, description: "A user is active."
                                                                   ^ #{DescriptionWhether::MSG}
        RUBY
        assert_correction(<<~RUBY)
          field :user_active, :boolean, null: false, description: "Whether a user is active."
        RUBY
      end

      # test "removes 'or not' from the boolean field description" do
      #   assert_offense(<<~RUBY)
      #     field :user_active, :boolean, null: false, description: "Whether the user is active or not."
      #                                                                                         ^^^^^^ #{DescriptionWhether::MSG}
      #   RUBY
      #   assert_correction(<<~RUBY)
      #     field :user_active, :boolean, null: false, description: "Whether the user is active."
      #   RUBY
      # end

      test "does not add offense if boolean field description starts with 'Whether' and does not contain 'or not'" do
        assert_no_offenses(<<~RUBY)
          field :user_active, :boolean, null: false, description: "Whether the user is active."
        RUBY
      end

      # test "does not add offense if field type is not boolean" do
      #   assert_no_offenses(<<~RUBY)
      #     field :user_name, String, null: false, description: "Whether the user is active."
      #   RUBY
      # end

      # test "does not downcase proper nouns" do
      #   assert_no_offenses(<<~RUBY)
      #     field :user_active, :boolean, null: false, description: "Whether a Shopify user is active."
      #   RUBY
      # end
    end
  end
end
