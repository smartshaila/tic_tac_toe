@board = [[nil,nil,nil],
          [nil,nil,nil],
          [nil,nil,nil]]

@win_coordinates = [[[0,0],[0,1],[0,2]],
                    [[1,0],[1,1],[1,2]],
                    [[2,0],[2,1],[2,2]],
                    [[0,0],[1,0],[2,0]],
                    [[0,1],[1,1],[2,1]],
                    [[0,2],[1,2],[2,2]],
                    [[0,0],[1,1],[2,2]],
                    [[0,2],[1,1],[2,0]]]

def render_board
  @board.map{|row| row.map{|cell| cell.nil? ? ' ' : cell} * '|' } * "\n-+-+-\n"
end

def parse_input(user_input)
  captured_input = user_input.match(/^([ABC])([123])$/)
  return nil if captured_input.nil?
  row_map = {"A" => 0, "B" => 1, "C" => 2}
  puts captured_input[1]
  row = row_map[captured_input[1]]
  col = captured_input[2].to_i - 1
  {row: row, column: col}
end

def calculate_game_state
  @win_coordinates.any?{|set|
    values = set.map{|coord| @board[coord.first][coord.last]}
    values.uniq.length == 1 && values.compact.length > 0
  }
end

def whats_here(coordinates)
  @board[coordinates.first][coordinates.last]
end

def set_here(coordinates, value)
  @board[coordinates.first][coordinates.last] = value
end

def skynet_move
  best_set_ish = @win_coordinates.map{|set|
    win_moves = set.map{|coord| whats_here(coord)}
    {
        set: set,
        count: win_moves.count("O") > 0 ? -1 : win_moves.count("X")
    }
  }.max_by{|r| r[:count]}
  move = best_set_ish[:set].select{|coord| whats_here(coord).nil?}.sample
  pp move
  set_here(move, "O")
end

puts render_board
until calculate_game_state do
  print "Enter Coordinates: "
  user_input = parse_input(gets.chomp)
  if user_input.nil?
    puts "Invalid Coordinates"
  else
    puts user_input
    @board[user_input[:row]][user_input[:column]] = "X"
    skynet_move unless calculate_game_state
  end
  puts render_board
end