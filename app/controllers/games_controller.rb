require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:word].downcase
    @letters = params[:letters].gsub(' ', '').downcase.chars
    @letters_unedit = params[:letters].gsub(' ', '').downcase.chars
    if open_url(@answer) == true && word_inlcude(@answer, @letters) == true
      @return = "Congratulations! #{@answer} is a valid English word!"
    elsif open_url(@answer) == false && word_inlcude(@answer, @letters) == true
      @return = "Sorry but #{@answer} does not seem to be a valid English word..."
    else
      @return = "Sorry but #{@answer} can't be built out of #{@letters_unedit.join(', ')}"
    end
  end

  private

  def open_url(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    file = URI.open(url).read
    output = JSON.parse(file)
    output["found"]
  end

  def word_inlcude(word, grid)
    answer_char = word.chars
    answer_char.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.find_index(char))
      else
        return false
      end
    end
    true
  end
end
