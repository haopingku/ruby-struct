def get_z_array s
  z = Array.new(s.size, 0)
  x = y = 0
  for i in 1 ... s.size
    z[i] = [0, [z[i-x], y - i + 1].min].max
    while i + z[i] < s.size && s[z[i]] == s[i + z[i]]
      x, y = i, i + z[i]
      z[i] += 1
    end
  end
  z
end