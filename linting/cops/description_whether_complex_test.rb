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

      test "adds offense if Boolean-type fields don't start with 'Whether' " do
        assert_offense(<<~RUBY)
          field :user_active, :boolean, null: false, description: "A user is active."
                                                                  ^^^^^^^^^^^^^^^^^^^ #{DescriptionWhether::MSG}
        RUBY

        assert_correction(<<~RUBY)
          field :user_active, :boolean, null: false, description: "Whether a user is active."
        RUBY
      end

      test "if boolean field description starts with an active verb, prepend 'Whether to', change the verb to its infinitive form, and make the next word lowercase" do
        assert_offense(<<~RUBY)
          field :activate_staff, :boolean, null: false, description: "Specifies if the staff member is active or not."
                                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{DescriptionWhether::MSG}
        RUBY
        assert_correction(<<~RUBY)
          field :activate_staff, :boolean, null: false, description: "Whether to specify if the staff member is active or not."
        RUBY
      end

      test "if boolean field description starts with an article, prepend 'Whether' and downcases the article" do
        assert_offense(<<~RUBY)
          field :user_active, :boolean, null: false, description: "The user is active."
                                                                  ^^^^^^^^^^^^^^^^^^^ #{DescriptionWhether::MSG}
        RUBY
        assert_correction(<<~RUBY)
          field :user_active, :boolean, null: false, description: "Whether the user is active."
        RUBY
      end

      test "if boolean field description contains 'whether' but doesn't start with it, prepend 'Whether' and keep the rest of the sentence" do
        assert_offense(<<~RUBY)
          field :activate_staff, :boolean, null: false, description: "This field specifies whether to activate the staff member."
                                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{DescriptionWhether::MSG}
        RUBY
        assert_correction(<<~RUBY)
          field :activate_staff, :boolean, null: false, description: "Whether to activate the staff member."
        RUBY
      end

      test "does not add offense if Boolean-type fields start with 'Whether' " do
        assert_no_offenses(<<~RUBY)
          field :user_active, :boolean, null: false, description: "Whether a user is active."
        RUBY
      end
    end
  end
end
