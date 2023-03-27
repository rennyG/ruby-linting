# Draft logic to handle descriptions provided as active verbs

def plural(description)
  arr = description.split
  if arr[0].end_with?('s')
    arr.drop(1)
    # Need to account for `a, an`
    if arr.first.start_with?('the')
      arr.join(' ').capitalize
    else
      arr.join(' ').capitalize
      # In some cases, `A` or `An` is more appropriate. Need to build this in.
      arr.unshift('The')
    end
  end
