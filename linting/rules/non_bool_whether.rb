# Draft logic to handle non-Booelean fields that should not start with Whether

def notbool(d)
  if field_type != "boolean" && d.downcase.start_with?("Whether")
    puts "Only descriptions for Booleans should start with 'Whether'. Use an article instead."
  end
end
