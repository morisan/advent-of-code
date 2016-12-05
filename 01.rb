DEBUG = false

INPUT = 'L5, R1, R4, L5, L4, R3, R1, L1, R4, R5, L1, L3, R4, L2, L4, R2, L4, L1, R3, R1, R1, L1, R1, L5, R5, R2, L5, R2, R1, L2, L4, L4, R191, R2, R5, R1, L1, L2, R5, L2, L3, R4, L1, L1, R1, R50, L1, R1, R76, R5, R4, R2, L5, L3, L5, R2, R1, L1, R2, L3, R4, R2, L1, L1, R4, L1, L1, R185, R1, L5, L4, L5, L3, R2, R3, R1, L5, R1, L3, L2, L2, R5, L1, L1, L3, R1, R4, L2, L1, L1, L3, L4, R5, L2, R3, R5, R1, L4, R5, L3, R3, R3, R1, R1, R5, R2, L2, R5, L5, L4, R4, R3, R5, R1, L3, R1, L2, L2, R3, R4, L1, R4, L1, R4, R3, L1, L4, L1, L5, L2, R2, L1, R1, L5, L3, R4, L1, R5, L5, L5, L1, L3, R1, R5, L2, L4, L5, L1, L1, L2, R5, R5, L4, R3, L2, L1, L3, L4, L5, L5, L2, R4, R3, L5, R4, R2, R1, L5'
STARTING_DIRECTION = 'north'
DIRECTIONS = ['north', 'east', 'south', 'west']

$locations = {}
$first_dupe = true

def change_direction(direction, turn)
  pos = DIRECTIONS.index(direction)

  if turn == 'L'
    pos = (pos == 0) ? 3 : pos - 1
  else # turn == 'R'
    pos = (pos == 3) ? 0 : pos + 1
  end

  return DIRECTIONS[pos]
end

def check_location_dupe(x_coord, y_coord)
  location_tag = "#{x_coord},#{y_coord}"
  if $first_dupe && $locations[location_tag]
    puts "First location dupe! x_coord: #{x_coord}, y_coord: #{y_coord} is #{x_coord.abs + y_coord.abs} blocks away"
    $first_dupe = false
  end
  $locations[location_tag] = true
end

def blocks_away(instructions, direction)
  x_coord = 0
  y_coord = 0
  location_tag = "#{x_coord},#{y_coord}"
  $locations[location_tag] = true

  instructions.split(', ').each do |instr|
    turn = instr[0]
    blocks = instr[1..-1].to_i
    direction = change_direction(direction, turn)

    case direction
    when 'north'
      blocks.times do
        y_coord += 1
        check_location_dupe(x_coord, y_coord)
      end
    when 'east'
      blocks.times do
        x_coord += 1
        check_location_dupe(x_coord, y_coord)
      end
    when 'south'
      blocks.times do
        y_coord -= 1
        check_location_dupe(x_coord, y_coord)
      end
    when 'west'
      blocks.times do
        x_coord -= 1
        check_location_dupe(x_coord, y_coord)
      end
    end
  end

  x_coord.abs + y_coord.abs
end

puts "#{blocks_away(INPUT, STARTING_DIRECTION)} blocks away"
