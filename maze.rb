class Maze 
	# constructor to initialize he state of the Maze object
	def initialize(m,n)
		@m = m 
		@n = n 
		@cells = Array.new(m){Array.new(n)}
		load_cells
		@shape = [ ]
	end 

	# load cells in a way that the array numbering is reversed to replicate a maze whos numbering is opposite 
	def load_cells()
		(0..@m-1).each do |row|
			(0..@n-1).each do |col| 
				@cells [row] [col] = Cell.new(col,row)
			end
		end
	end

	def load(s)
		row = (@m *2) + 1
		col = (@n*2) + 1 
		count = 0 
		ary = s.split('').map(&:to_i)
		(0..row-1).each do |r|
			@shape[r] = Array.new(ary[count..count+col-1])
			count = count + col
		end
		(0..@m-1).each do |r|
			(0..@n-1).each do |c|
				current = @cells[r][c]
				top = @cells[r-1][c]
				left = @cells[r][c-1]
				if @shape [2*r][(2*c)+1] == 0 
					current.join_cells(top)
				end 
				if @shape[2*r+1][2*c] == 0
					current.join_cells(left)
				end
			end 
		end 
	end 

	# a method to print out the diagram of maze on the output window 
	def display()
		@shape.each_index do |r| 
			@shape[r].each_index do |c|
				if r%2 == 0 # it is an even numbered rows 
					if c%2 == 0 #
						print '+'
					elsif @shape [r][c] == 1 
						print '-'
					else 
						print ' '
					end 
				else 
					if @shape [r][c] == 1
						print '|'
					else 
						print ' '
					end 
				end 
			end 
			puts ' '
		end 
	end


	# figures out whether there is way to solve the maze 
	def solve(begX, begY, endX, endY)
		start_cell = @cells[begY][begX]
		end_cell = @cells[endY][endX]
		htable = {}
		queue = []
		htable[[begX,begY]] = start_cell
		queue.push(start_cell)
		current = start_cell
		while (current.x != endX || current.y != endY) do
			if queue.length == 0
				return false
				break
			else
				current = queue.shift
				current.accessible_cells.each do |cell|
					if !htable.has_value?(cell)
						cell.back_pointer = current
						htable[[cell.x,cell.y]] = cell
						queue.push(cell)
					end
				end
			end
		end
		current 
	end

	def trace(begX, begY, endX, endY)
		current = solve(begX, begY, endX, endY)
		maze_trace = []
		while (current.back_pointer != nil ) do
			maze_trace.push([current.x, current.y])
			current = current.back_pointer
		end
		maze_trace.reverse 
	end

end

class Cell
	attr_accessor :x, :y, :accessible_cells, :back_pointer
	def initialize(x,y)
		@x = x
		@y = y
		@accessible_cells = [ ]
		@back_pointer = nil
	end      

	def join_cells(cell)
		@accessible_cells.push(cell)
		cell.accessible_cells.push(self)
	end

end

x = Maze.new(4,4)
 x.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
puts x.trace(0,0,0,1)
