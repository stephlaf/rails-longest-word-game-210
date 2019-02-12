require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = []
    9.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @end = Time.now
    @results = results
  end

  private

  def validate_at_api
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    JSON.parse(open(url).read)
  end

  def in_grid
    grid_hash = {}
    grid = params[:letters].delete(" ")
    grid.chars.each { |char| grid_hash[char] = grid.chars.count(char) }

    word_hash = {}
    word_array = params[:word].delete(" ").upcase.chars
    word_array.each { |char| word_hash[char] = word_array.count(char)}

    word_hash.each do |char, reps|
      grid_hash_reps = grid_hash[char]
      return false unless grid_hash_reps && reps <= grid_hash_reps
    end
    true
  end

  def calc_score
     base = params[:word].length * 100
     time = (@end - params[:start].to_time)
     (base - time).round(2)
  end

  def results
    if validate_at_api["found"] && in_grid
      "All good, score is #{calc_score}"
    elsif in_grid
      "In grid not english"
    else
      "All bad"
    end
  end
end
