require_relative 'tile'
class Board
  attr_reader :board

  def initialize
    @grid = new_grid
    seed_bombs
    count_neighbors
  end

  def run

  end

  def new_grid
    Array.new(9) { Array.new(9) { Tile.new } }
  end

  def render
    @grid.each do |row|
      row.map { |tile| tile.inspect }
      p row
    end
    nil
  end

  def seed_bombs
    bombs = 0
    until bombs == 10
      i = rand(0...9)
      j = rand(0...9)
      unless @grid[i][j].bomb?
        @grid[i][j].set_bomb
        bombs += 1
      end
    end
  end

  def count_neighbors
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        row_idx == 0 ? previous_row = row_idx : previous_row = row_idx-1
        row_idx == 8 ? next_row = row_idx : next_row = row_idx+1
        col_idx == 0 ? previous_col = col_idx : previous_col = col_idx-1
        col_idx == 8 ? next_col = col_idx : next_col = col_idx+1

        if tile.bomb?
          unless row_idx == previous_row
            @grid[previous_row][previous_col..next_col].each do |t|
              t.incr_neighbors unless t.bomb?
            end
          end
          unless next_row == row_idx
            @grid[next_row][previous_col..next_col].each {|t| t.incr_neighbors unless t.bomb? }
          end
          @grid[row_idx][previous_col..next_col].each { |t| t.incr_neighbors unless t.bomb? }
        end
      end
    end
  end
end
