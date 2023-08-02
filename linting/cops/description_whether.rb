# typed: true
# frozen_string_literal: true

require "rubocop-graphql"
require_relative "graphql_description_cop_helper"

module Cops
  module GraphQL
    # This cop ensures that GraphQL field descriptions describe Booleans using "Whether"
    # and provides autocorrect functionality.
    #
    # @example
    #
    #   # good
    #
    #   field :unified_compatible,
    #   :boolean,
    #   null: false,
    #   description: "Whether an app is capable of being loaded in unified admin." do |field|
    #   field.visibility(:internal, as_of: :minor_changes_unstable)
    #   end
    #
    #   field :can_manually_mark_completed,
    #   :boolean,
    #   null: false,
    #   description: "Whether the merchant can manually mark the recommendation as 'complete'.",
    #   method: :can_manually_mark_completed?
    #
    #   field :completed,
    #   :boolean,
    #   null: false,
    #   description: "Whether the merchant has followed the recommendation.",
    #   method: :complete?
    #
    #   # bad
    #
    #   field :unified_compatible,
    #   :boolean,
    #   null: false,
    #   description: "Whether or not an app is capable of being loaded in unified admin." do |field|
    #   field.visibility(:internal, as_of: :minor_changes_unstable)
    #   end
    #
    #   field :can_manually_mark_completed,
    #   :boolean,
    #   null: false,
    #   description: "A flag which indicates if the merchant can manually mark the recommendation as 'complete'.",
    #   method: :can_manually_mark_completed?
    #
    #   field :completed,
    #   :boolean,
    #   null: false,
    #   description: "The status of whether or not the merchant has followed the recommendation.",
    #   method: :complete?

    class DescriptionWhether < ::RuboCop::Cop::Base
      include ::RuboCop::GraphQL::NodePattern
      include GraphQLDescriptionCopHelper
      extend ::RuboCop::Cop::AutoCorrector

      MSG = "In descriptions, Boolean field descriptions should start with 'Whether'. They shouldn't contain 'or not'."

      BOOLEAN_FIELD_PATTERN = /\AWhether or not/
      START_WITH_ARTICLE_PATTERN = /\A(a|an|the)\b/i
      PROPER_NOUN_PATTERN = /\b([A-Z][a-z]*)\b/
      OR_NOT_PATTERN = /or not/

      RESTRICT_ON_SEND = [:field].freeze

      def_node_search :description_nodes, <<~PATTERN
        (send nil? {:field}
         (sym :boolean)
         ...
         (hash <(pair (sym :description) ${str dstr}) ...>)
        )
      PATTERN

      def on_send(node)
        description_nodes(node).each do |description_node|
          check_description(description_node)
        end
      end

      private

      def check_description(description_node)
        string_node = description_node
        value = string_node.value

        if value.match(BOOLEAN_FIELD_PATTERN)
          range = calculate_range(string_node, ' or not')

          add_offense(range) do |corrector|
            corrector.remove(range)
          end
        elsif value.match(START_WITH_ARTICLE_PATTERN)
          range = calculate_range(string_node, value.match(START_WITH_ARTICLE_PATTERN)[0])

          add_offense(range) do |corrector|
            corrector.replace(range, 'Whether ' + value.match(START_WITH_ARTICLE_PATTERN)[0].downcase)
          end

          next_word = value.split[1]
          if !next_word.match(PROPER_NOUN_PATTERN)
            range = calculate_range(string_node, next_word)

            add_offense(range) do |corrector|
              corrector.replace(range, next_word.downcase)
            end
          end
        elsif value.match(OR_NOT_PATTERN)
          range = calculate_range(string_node, ' or not')

          add_offense(range) do |corrector|
            corrector.remove(range)
          end
        end
      end
    end
  end
end
