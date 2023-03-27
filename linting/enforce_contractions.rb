# problems:
# case insensitivity
# test

def verify_contractions(words)
  required_contractions = {
    "cannot" => "can't",
    "will not" => "won't",
    "should not" => "shouldn't",
    "would not" => "wouldn't",
    "could not" => "couldn't",
    "it is" => "it's",
    "they are" => "they're",
    "we are" => "we're",
    "you are" => "you're",
    "that is" => "that's",
    "there is" => "there's",
    "are not" => "aren't"
  }

  disallowed_contractions = {
      "they'rent" => "they aren't",
      "theren't" => "there aren't",
      "ain't" => "aren't"
  }

  terms = words.split(" ")
  terms.each_with_index do |word, index|
    phrase = terms[index..index+1].join(" ")
    if required_contractions.has_key?(phrase)
      puts "You should use the contraction '#{required_contractions[phrase]}' instead of '#{phrase}'."
    end
    if required_contractions.has_key?(word)
      puts "You should use the contraction '#{required_contractions[word]}' instead of '#{word}'."
    end
    if disallowed_contractions.has_key?(word)
      puts "'#{word}' isn't a valid contraction. Instead, use '#{disallowed_contractions[word]}'."
    end
  end
end

verify_contractions("should not could not would not")
