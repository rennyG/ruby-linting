require 'graphql'
require 'json'
require 'terminal-table'
require 'csv'

# Load and parse the schema from the JSON file
schema_json = File.read('admin-schema.json')
schema_hash = JSON.parse(schema_json)
schema = GraphQL::Schema.from_introspection(schema_hash)

# Initialize counters
type_count = 0
field_count = 0
argument_count = 0
enum_value_count = 0

# Initialize an array to hold descriptions
descriptions = []

# Iterate over all types in the schema
schema.types.each_value do |type|
  # Count and save description for the type itself
  if type.description
    type_count += 1
    descriptions << ["Type", type.name, type.description, "Type: #{type.name}", "N/A"]
  end

  # If the type has fields, iterate over them
  if type.respond_to?(:fields)
    type.fields.each_value do |field|
      # Count and save description for the field
      if field.description
        field_count += 1
        descriptions << ["Field", field.name, field.description, "Type: #{type.name}, Field: #{field.name}", field.type.to_s]
      end

      # If the field has arguments, iterate over them
      field.arguments.each_value do |argument|
        # Count and save description for the argument
        if argument.description
          argument_count += 1
          descriptions << ["Argument", argument.name, argument.description, "Type: #{type.name}, Field: #{field.name}, Argument: #{argument.name}", argument.type.to_s]
        end
      end
    end
  end

  # If the type is an enum, iterate over its values
  if type.kind.enum?
    type.values.each_value do |enum_value|
      # Count and save description for the enum value
      if enum_value.description
        enum_value_count += 1
        descriptions << ["Enum Value", enum_value.graphql_name, enum_value.description, "Type: #{type.name}, Enum Value: #{enum_value.graphql_name}", "N/A"]
      end
    end
  end
end

# Create a table
table = Terminal::Table.new do |t|
  t << ['Element', 'Count', 'Data Type']
  t << :separator
  t << ['Type', type_count, 'N/A']
  t << ['Field', field_count, 'N/A']
  t << ['Argument', argument_count, 'N/A']
  t << ['Enum Value', enum_value_count, 'N/A']
end

puts table

# Generate a CSV file with all the descriptions
CSV.open("descriptions.csv", "wb") do |csv|
  csv << ["Element Type", "Element Name", "Description", "Identifier", "Data Type"]
  descriptions.each do |description|
    csv << description
  end
end
