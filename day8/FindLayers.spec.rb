require_relative("./FindLayers.rb")
require("./file_help.rb")

Day8txt = ReadInput.("day8.txt")
ExampleLayers = ->() { FindLayers.to_layer_list width: 3, height: 2, raw_data: "012122122121" }
Day8Layers = ->() { FindLayers.to_layer_list width: 25, height: 6, raw_data: Day8txt }

HEX_LAYERS = [
  [
    0, 1,
    2, 3
  ],
  [
    4, 5,
    6, 7
  ],
  [
    9, :a,
    :b, :c
  ]
]

RSpec.describe FindLayers do
  describe "part 1" do
    it "translates raw data into layers nested arrays" do
      expect(
        FindLayers.to_layer_list width: 3, height:  2, raw_data: "123456789012"
      ).to eq(
        [ [1,2,3, 4,5,6], [7,8,9, 0,1,2] ]
      )
    end

    it "finds layer with most zeros" do
      layers = ExampleLayers.call
      expect(
        (FindLayers.find_least_zero_layer layers: layers)[1] # the index of the layer
      ).to eq(1)
    end

    it "multiply counts from a layer" do
      layers = ExampleLayers.call
      expect(
        FindLayers.multiply_layer_counts layer: layers[1]
      ).to eq(9)
    end

    context "they fudge day 8s input size, there was a faulty 0 at the end (15001 !== width * height)" do
      it "mulitply counts from layer of most zeros from day8txt" do
        layers = Day8Layers.call
        optimal_layer, its_index = FindLayers.find_least_zero_layer layers: layers
        expect(
          FindLayers.multiply_layer_counts layer: optimal_layer
        ).to eq(1950)
      end
    end
  end

  describe "part 2" do
    it "zips all layers into array of merged pixel values from back to front" do
      expect(
        FindLayers.zip_pixel_layers_back_to_front layers: HEX_LAYERS
      ).to eq([
        [9, 4, 0], [:a, 5, 1],
        [:b, 6, 2], [:c, 7, 3]
      ])
    end

    it "find the most forward pixels" do
      expect(
        FindLayers.merge_pixels_into_image pixels: (
          FindLayers.zip_pixel_layers_back_to_front layers: [
            [
              0, 2,
              2, 2
            ],
            [
              1, 1,
              2, 2
            ],
            [
              2, 2,
              1, 2
            ],
            [
              0, 0,
              0, 0
            ]
          ]
        )
      ).to eq(
        [0, 1, 1, 0]
      )
    end

    it "prints an image after merging layers into pixels" do
      image = FindLayers.merge_pixels_into_image pixels: (
        FindLayers.zip_pixel_layers_back_to_front layers: (
          Day8Layers.call
        )
      )
      # Had to disable auto trim of whitespace to get this to work in editor.
      # When coming back to this, dont forget!
      expect(
        (FindLayers.print_image image: image, width: 25, height: 6)
      ).to eq(
"|||| |  |  ||  |  | |    
|    | |  |  | |  | |    
|||  ||   |  | |||| |    
|    | |  |||| |  | |    
|    | |  |  | |  | |    
|    |  | |  | |  | |||| "
      )

      # Its FKAHL
    end
  end
end
