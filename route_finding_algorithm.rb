class RouteFindingAlgorithm

	def self.generate_map
		map = [
			['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
			['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'A', 'X'],
			['X', ' ', 'X', 'X', ' ', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', ' ', 'X', 'X', ' ', 'X'],
			['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X'],
			['X', ' ', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', ' ', 'X'],
			['X', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X'],
			['X', 'X', 'X', 'X', ' ', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', ' ', 'X', 'X', 'X', 'X'],
			[' ', ' ', ' ', 'X', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', ' ', 'X', ' ', ' ', ' '],
			['X', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', ' ', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', 'X'],
			[' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
			['X', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', 'X'],
			[' ', ' ', ' ', 'X', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', ' ', 'X', ' ', ' ', ' '],
			['X', 'X', 'X', 'X', ' ', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', ' ', 'X', 'X', 'X', 'X'],
			['X', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X'],
			['X', ' ', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', ' ', 'X'],
			['X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X'],
			['X', ' ', 'X', 'X', ' ', 'X', 'X', 'X', ' ', 'X', ' ', 'X', 'X', 'X', ' ', 'X', 'X', ' ', 'X'],
			['X', 'B', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X'],
			['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
		]
	end

	def self.generate_score_map(map)
		count = 0

		# Find point A and B
		a = find('A', map)
		b = find('B', map)
		next_steps = [b]

		while !next_steps.include?(a)
			if next_steps.empty?
				puts "Impossible to trace route!"
				return false
			end
			puts "Calculating score #{count}... Next steps:"
			puts next_steps.join(', ')
			next_steps = assign_next_steps(map, next_steps, count)
			count += 1
		end

		map
	end

	def self.get_neighbours(point, map)
		steps = []
		steps << {x: point[:x], y: point[:y] - 1} unless point[:y] == 0
		steps << {x: point[:x], y: point[:y] + 1} unless point[:y] == map.size - 1
		steps << {x: point[:x] + 1, y: point[:y]} unless point[:x] == map.size - 1
		steps << {x: point[:x] - 1, y: point[:y]} unless point[:x] == 0
		steps
	end

	def self.assign_next_steps(map, next_steps, count)
		new_next_steps = []
		next_steps.each do |point|

			steps = get_neighbours(point, map)

			steps.each do |step|
				# Assign count, unless target = X , nil ou bigger <= count
				value = map[step[:y]][step[:x]]
				cannot_assign = true if value == 'X'
				cannot_assign = true if value.nil?
				cannot_assign = true if value.is_a? Numeric and value.to_i <= count

				map[step[:y]][step[:x]] = count unless cannot_assign
				new_next_steps << step unless cannot_assign
			end
		end
		return new_next_steps
	end

	def self.find(point, map)
		map.each_with_index do |row, index|
			x = row.index(point) if row.include?(point)
			return {x: x , y: index} unless x.nil?
		end
	end

	def self.print_map(map)
		map.each do |x|
			puts x.join(" ")
		end
	end

	def self.trace_route(map, score_map)
		a = find('A', map)
		current = a

		# Gets the starting point score
		count = score_map[a[:y]][a[:x]]

		while count >= 0
			map[current[:y]][current[:x]] = '.' unless count == score_map[a[:y]][a[:x]]

			steps = get_neighbours(current, score_map)

			steps.each do |step|
				value = score_map[step[:y]][step[:x]]
				if value == count - 1
					current = {y: step[:y], x: step[:x]}
					break
				end
			end

			count -= 1
		end

		map
	end

	def self.start

		puts '============ Starting Map ============'
		print_map generate_map

		# Generate score map
		puts '============ Score Map Generation ============'
		score_map = generate_score_map(generate_map)

		return unless score_map

		# Generate route
		puts '================= Route ================='
		route = trace_route(generate_map, score_map)
		print_map route

	end

end
