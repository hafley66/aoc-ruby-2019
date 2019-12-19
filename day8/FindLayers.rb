module FindLayers

  TRANSPARENT = 2
  WHITE = 1
  BLACK = 0

  def self.to_layer_list width: 0, height: 0, raw_data: "012"
    data = (raw_data.split "").map &:to_i
    area = (width * height)
    (data.each_slice area).to_a
  end

  def self.find_least_zero_layer layers: [[]]
    [
      layer = layers.min_by do |layer|
        layer.count { |it| it == 0}
      end,
      (layers.index layer)
    ]
  end

  def self.multiply_layer_counts layer: []
    groups = layer.group_by &:to_s
    (
      (groups["1"] || []).length * (groups["2"] || []).length
    )
  end

  def self.zip_pixel_layers_back_to_front layers: [[]]
    return if layers.empty?
    (layers[0].zip *(layers[1..])).map &:reverse
  end

  def self.merge_pixels_into_image pixels: [[]]
    pixels.map do |pixel|
      pixel.reduce(TRANSPARENT) do |prev, noxt|
        (noxt == TRANSPARENT ? prev : noxt)
      end
    end
  end

  def self.print_image width:, height:, image:
    image = image.map do |pixel|
      case pixel
      when TRANSPARENT
        " "
      when BLACK
        " "
      when WHITE
        "|"
      end
    end
    ((
      image.each_slice(width).map {|row| row.join ""}
    ).join "\n")
  end
end
