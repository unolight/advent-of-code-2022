# input_file = "sample.in"
input_file = "1.in"

Point = Struct.new(:x, :y)
points = Array.new(10) {Point.new(0, 0)}
vis = Hash.new{|h, k| h[k]=0}
vis[points[9].to_h] += 1
IO.foreach(input_file) {|line|
  op, v = line.split
  v = v.to_i
  v.times {
    case op
    when "L"
      points[0].x -= 1
    when "R"
      points[0].x += 1
    when "U"
      points[0].y += 1
    when "D"
      points[0].y -= 1
    end

    (1...10).each{|i|
      dx = points[i - 1].x - points[i].x
      dy = points[i - 1].y - points[i].y

      if dx.abs <= 1 && dy.abs <= 1
        next
      end
      if dx.abs > 1
        points[i].x += (dx > 0 ? 1 : -1)
        points[i].y += (dy == 0 ? 0 : dy > 0 ? 1 : -1)
      elsif dy.abs > 1
        points[i].x += (dx == 0 ? 0 : dx > 0 ? 1 : -1)
        points[i].y += (dy > 0 ? 1 : -1)
      end
    }
    vis[points[9].to_h] += 1
  }
}
p vis.length