# file = "sample.in"
file = "1.in"

def move_left(points, blocks)
  res = points.map{|i| [i[0], i[1]-1]}
  res.filter{|i| i[1]<0}.length > 0 || res.reduce(0){|acc,i| acc+blocks[i]} > 0 ? points : res
end

def move_right(points, blocks)
  res = points.map{|i| [i[0], i[1]+1]}
  res.filter{|i| i[1]>=7}.length > 0 || res.reduce(0){|acc,i| acc+blocks[i]} > 0 ? points : res
end

def drop(points, blocks)
  res = points.map{|i| [i[0]-1, i[1]]}
  res.filter{|i| i[0]<0}.length > 0 || res.reduce(0){|acc,i| acc+blocks[i]} > 0 ?
    [points, false] : [res, true]
end

def draw_game(blocks, curr)
  pos = blocks.keys
  if !curr.nil?
    pos += curr
  end
  height = pos.reduce(0){|mx,i| [mx, i[0]].max} + 1
  a = Array.new(height) {|i| i = [".", ".", ".", ".", ".", ".", "." ]}
  pos.each{|i| a[i[0]][i[1]] = "#"}
  a.reverse.each{|i| p i}
end
solve = ->(num) {
  stone = [
    [[0,0],[0,1],[0,2],[0,3]],
    [[0,1],[1,0],[1,1],[1,2],[2,1]],
    [[0,0],[0,1],[0,2],[1,2],[2,2]],
    [[0,0],[1,0],[2,0],[3,0]],
    [[0,0],[0,1],[1,0],[1,1]],
  ]

  blocks = Hash.new(0)
  op = File.read(file).strip.chars

  seen = Hash.new{|h,k| h[k]=[]}  # h[[cnt1 % stone.length, cnt2 % op.length]] = [[cnt1, height],...]
  ord = []
  cnt1, cnt2, height = 0, 0, 0
  while true
    if cnt1 >= num
      return height
    end

    if seen[[cnt1 % stone.length, cnt2 % op.length]].length == 2
      # draw_game(blocks, nil)
      prv, base = seen[[cnt1 % stone.length, cnt2 % op.length]].last
      cycle_size = cnt1 - prv
      height_inc = height - base
      rem = (num - prv) % cycle_size
      return  (num - prv) / cycle_size * height_inc + ord[prv + rem]
    end
    seen[[cnt1 % stone.length, cnt2 % op.length]] << [cnt1, height]
    ord << height
    me = stone[0].map{|i| [i[0]+height+3, i[1]+2]}
    # draw_game(blocks, me)
    while true
      c = op[0]
      op = op.rotate
      cnt2 += 1
      # move
      me =
        case c
        when "<"
          move_left(me, blocks)
        when ">"
          move_right(me, blocks)
        else
          me
        end
      # draw_game(blocks, me)
      # drop
      me, ok = drop(me, blocks)
      if !ok
        break
      end
      # draw_game(blocks, me)
    end
    # draw_game(blocks, nil)
    me.each{|i| blocks[i] = 1}
    height = [me.map{|i| i[0]}.max + 1, height].max
    stone = stone.rotate
    cnt1 += 1
  end
}

p solve.(2022)
p solve.(1000000000000)