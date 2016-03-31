input = $stdin.read
words = Hash.new
input.split(/\s/).keep_if { |word| word.length > 0 }.each do |word|
  if words.has_key?(word)
    words[word] += 1
  else
    words[word] = 1
  end
end
words = words.to_a
words.sort! { |a, b| a[0] <=> b[0] }
words.sort! { |a, b| b[1] <=> a[1] }
words.each do |pair|
  $stdout.puts pair[0] + "\t" + pair[1].to_s
end
