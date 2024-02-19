defmodule IdenticonTest do

  use ExUnit.Case
  doctest Identicon

  test "pick_color" do
    image = %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}
    assert Identicon.pick_color(image) == %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58], color: [116, 181, 101], grid: nil}
  end

  test "filter_odd_squares" do
    image = %Identicon.Image{grid: [{116, 0}, {181, 1}, {101, 2}, {134, 3}, {90, 4}, {25, 5}, {44, 6}, {200, 7}, {105, 8}, {60, 9}, {83, 10}, {13, 11}, {72, 12}, {235, 13}, {56, 14}, {58, 15}]}
    assert Identicon.filter_odd_squares(image) == %Identicon.Image{color: nil, grid: [{116, 0}, {134, 3}, {90, 4}, {44, 6}, {200, 7}, {60, 9}, {72, 12}, {56, 14}, {58, 15}], hex: nil}
  end

  test "build_image" do
    image = %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}
    assert Identicon.build_image(image) == %Identicon.Image{
      color: nil,
      grid: [{116, 0},
              {181, 1},
              {101, 2},
              {181, 3},
              {116, 4},
              {134, 5},
              {90, 6},
              {25, 7},
              {90, 8},
              {134, 9},
              {44, 10},
              {200, 11},
              {105, 12},
              {200, 13},
              {44, 14},
              {60, 15},
              {83, 16},
              {13, 17},
              {83, 18},
              {60, 19},
              {72, 20},
              {235, 21},
              {56, 22},
              {235, 23},
              {72, 24}],
      hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]
    }
  end

  test "hash_input" do
    assert Identicon.hash_input("elixir") == %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58], color: nil, grid: nil}
  end

  test "generate image via the main function pipeline" do
    assert Identicon.main("elixir") == :ok
  end

end
