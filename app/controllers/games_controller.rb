require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample.to_s }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @message = ''
    if english(@word) == false
      @message = "Sorry but #{@word} is not an english word"
    elsif attempt_correct_letters(@word, @letters) == false
      @message = "Sorry but #{@word} can't be built out of #{@letters.upcase}"
    elsif attempt_correct_letters(@word, @letters) && english(@word)
      @message = 'Congratulations!'
    end
  end

 private

  def english(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_word = URI.open(url).read
    word_hash = JSON.parse(user_word)
    word_hash["found"]
  end

  def attempt_correct_letters(word, letters)
    word.chars.all? { |letter| word.chars.count(letter) <= letters.count(letter) }
  end
end
