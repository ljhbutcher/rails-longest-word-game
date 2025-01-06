require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split(' ')
    @word = params[:word].upcase

    if valid_word?(@word, @letters)
      if english_word?(@word)
        @message = "Well done! #{@word} is a valid word."
        @score = @word.length
      else
        @message = "#{@word} is not an English word."
        @score = 0
      end
    else
      @message = "#{@word} cannot be made from the grid."
      @score = 0
    end
  end

  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  private

  def valid_word?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

end
