defmodule Identicon do
  @moduledoc """
  Provides functions for generating identicons.
  """

  @doc """
  The main function that takes an input string and returns an Identicon image.
  Returns an Identicon image, with the :ok atom if the image was successfully saved to a file.

  ## Examples

      iex> Identicon.main("elixir")
      :ok
  """
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_image()
    |> filter_odd_squares()
    |> build_pixel_map()
    |> draw_image(input)
  end

  @doc """
  Updates the Identicon Image struct with a new pixel_map field.


  ## Examples

      iex> Identicon.build_pixel_map(%Identicon.Image{color: [116, 181, 101], grid: [{116, 0}, {134, 3}, {90, 4}, {44, 6}, {200, 7}, {60, 9}, {72, 12}, {56, 14}, {58, 15}]})
      %Identicon.Image{
                color: [116, 181, 101],
                grid: [{116, 0}, {134, 3}, {90, 4}, {44, 6}, {200, 7}, {60, 9}, {72, 12}, {56, 14}, {58, 15}],
                hex: nil,
                pixel_map: [
                  {{0, 0}, {50, 50}},
                  {{150, 0}, {200, 50}},
                  {{200, 0}, {250, 50}},
                  {{50, 50}, {100, 100}},
                  {{100, 50}, {150, 100}},
                  {{200, 50}, {250, 100}},
                  {{100, 100}, {150, 150}},
                  {{200, 100}, {250, 150}},
                  {{0, 150}, {50, 200}}
                ]
              }
  """
  @spec build_pixel_map(Identicon.Image.t()) :: Identicon.Image.t()
  def build_pixel_map(image) do
    pixel_map = image.grid
    |> Enum.map(fn {_code, index} ->
      vertical = div(index, 5) * 50
      horizontal = rem(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)

    %Identicon.Image{image | pixel_map: pixel_map}

  end

  @doc """
  Draws the image and saves it to a file with the input string as the file name under the folder ./identicons.{name}.png.
  Uses the :egd save implements to save the binary file to the location specified.

  ## Examples

      iex> Identicon.draw_image(%Identicon.Image{color: [116, 181, 101], pixel_map: [{{0, 0}, {50, 50}}, {{150, 0}, {200, 50}}, {{200, 0}, {250, 50}}, {{50, 50}, {100, 100}}, {{100, 50}, {150, 100}}, {{200, 50}, {250, 100}}, {{100, 100}, {150, 150}}, {{200, 100}, {250, 150}}, {{0, 150}, {50, 200}}]}, "elixir")
      :ok
  """
  @spec draw_image(Identicon.Image.t(), String.t()) :: :ok
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}, input) do
    image = :egd.create(250, 250)
    [r, g, b] = color
    fill = :egd.color({r, g, b})

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image) |> :egd.save("./identicons/#{input}.png")
  end


  @doc """
    Picks the first three elements from the input list and updates the Identicon Image stuct with the new image field.

    ## Examples

        iex> Identicon.pick_color(%Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]})
        %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58], color: [116, 181, 101], grid: nil}
  """
  @spec pick_color(Identicon.Image.t()) :: Identicon.Image.t()
  def pick_color(%Identicon.Image{hex: [r,g,b | _rest]} = image) do
    %Identicon.Image{image | color: [r,g,b]}
  end

  @doc """
  Updates the Identicon Image struct by filtering the grid field to only include the even numbers.

  ## Examples

      iex> Identicon.filter_odd_squares(%Identicon.Image{grid: [{116, 0}, {181, 1}, {101, 2}, {134, 3}, {90, 4}, {25, 5}, {44, 6}, {200, 7}, {105, 8}, {60, 9}, {83, 10}, {13, 11}, {72, 12}, {235, 13}, {56, 14}, {58, 15}]})
      %Identicon.Image{color: nil, grid: [{116, 0}, {134, 3}, {90, 4}, {44, 6}, {200, 7}, {60, 9}, {72, 12}, {56, 14}, {58, 15}], hex: nil}

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _index} -> rem(code, 2) == 0 end)
    %Identicon.Image{image| grid: grid}
  end

  @doc """
  Updates the Identicon Image struct by building a new grid from the input hex list.

  ## Examples

      iex> Identicon.build_image(%Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]})
      %Identicon.Image{
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
          hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}
  """
  @spec build_image(Identicon.Image.t()) :: Identicon.Image.t()
  def build_image(image) do
    grid = image.hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_image/1)
    |> List.flatten()
    |> Enum.with_index()

    %Identicon.Image{image | grid: grid}

  end

  @doc """
  Mirrors the input list and returns a new list with the mirrored elements appended to the original list.

  ## Examples

      iex> Identicon.mirror_image([116, 181, 101])
      [116, 181, 101, 181, 116]
  """
  @spec mirror_image(list) :: list
  def mirror_image(row) do
    [first, second | _rest] = row
    row ++ [second, first]
  end

  @doc """
  Hashes the input string and returns an updated `Identicon.Image` struct with the hashed input as the value for the `hex` field.

  ## Examples

      iex> Identicon.hash_input("elixir")
      %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}
  """
  @spec hash_input(String.t()) :: Identicon.Image.t()
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
