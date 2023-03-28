# Draft logic to handle descriptions provided as active verbs, but which shouoldn't be
# Needs testing

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
end

  plural("Emails a mess of the place")
