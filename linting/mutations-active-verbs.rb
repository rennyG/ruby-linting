# Draft logic to handle mutation description provided as active verbs
# For the rule, we'd probably make this conditional on the object being a mutation and it not ending with s. So could use unless, or if.

def mutation(w)
  arr = w.split
  if arr.first.end_with?("s")
   puts "yey"
  else
   puts "nay"
  end
