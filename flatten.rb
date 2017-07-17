def flatten(arr)
  return [arr] if !arr.is_a?(Array)
  new_arr = []
  arr.each do |d|
    new_arr += flatten(d)
  end
  new_arr
end

b = [1,2,3,4]
puts
puts "#{b} flattened is #{flatten(b)}"
puts

c =  [ 1, [ 2, [ 3 ] ], 4 ]
puts "#{c} flattened is #{flatten(c)}"
puts
