Manhattan = ->(
  (x1, y1),
  (x2, y2)
) {
  (x1 - x2).abs + (y1 - y2).abs
}

class Day3

  def initialize(lines)
    @lines = lines
    @step_maps = {
      lines[0] => {[0,0] => 0},
      lines[1] => {[0,0] => 0},
    }
  end
  def log1 s; puts(s.to_s); s; end
  def log *s; puts(s.to_s); s; end

  Ops = {
    U: [nil, :+],
    D: [nil, :-],
    R: [:+, nil],
    L: [:-, nil]
  }

  def run_op((x,y), op_code, arg)
    opX, opY = Ops[op_code.to_sym]
    return [
      opX ? x.send(opX, arg) : x,
      opY ? y.send(opY, arg) : y,
    ]
  end

  def op_2_points(origin, relative_path_op, step_map, current_steps)
    ox, oy = origin

    r = relative_path_op
    (op, dist) = [
      r[0].upcase,
      r[1..-1].to_i
    ]

    new_points = []
    i = 1
    while i <= dist
      new_pt = run_op origin, op, i
      if !step_map[new_pt]
        current_steps = current_steps + 1
        step_map[new_pt] = current_steps
      end
      i += 1
      new_points << new_pt
    end
    new_points
  end

  def ops_2_points
    @lines.map do |line_ops|
      points = [[0,0]]
      step_map = @step_maps[line_ops]
      line_ops.each do |op|
        points.concat op_2_points(points.last, op, step_map, points.length)
      end
      points
    end
  end

  def closest_intersections
    ptsA, ptsB = ops_2_points
    step_map_A = @step_maps[@lines[0]]
    step_map_B = @step_maps[@lines[1]]
    pts = (ptsA & ptsB) - [[0,0]]
    pt = pts.min_by do |pt|
      (step_map_A[pt] + step_map_B[pt])
    end
    step_map_A[pt] + step_map_B[pt]
  end
end


puts (
  (
    Day3.new(
      File
        .read('3.txt')
        .split("\n")
        .map do |it| it.split(",") end
    )
  ).closest_intersections.to_s
)
