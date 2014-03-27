def sum(arr, s)
  res = []
  d = {}
  arr.each_index do |i|
   d[arr[i]] = i
  end
  arr.each_index do |j|
   if d.has_key?(s - arr[j])
     res << arr[j]
   end
  end
  res
end

a = [ 1,3,4,5,6,7,8 ]
s = 6
p a
p s
p sum a, s
