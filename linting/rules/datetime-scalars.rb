# Draft logic to handle descriptions of datetime scalars


def datetime(d)
  field_type = "datetime"
  dt_when = "the date and time when"
  dt_for = "the date and time for"
  dt_which  = "the date and time at which"
    if field_type == "datetime" && d.downcase.start_with?(dt_when, dt_for, dt_which) == false
      puts "Descriptions of datetime scalars must start with 'The date and time when'."
  end
end


datetime("The date and time when it all went south")
