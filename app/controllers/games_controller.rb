require 'json'
require 'open-uri'
require 'time'

class GamesController < ApplicationController
  def home; end

  def new
    @start_time = Time.now
    @randomletters = (0...9).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    user = parse
    @word = user['word']
    @randomletters = params[:randomletters].split
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @score = (user['word'].size - ((@end_time - @start_time) / 10)).round(2)

    @message = if word_in_grid && user['found']
                 "Congratulations!!! You scored #{@score} points"
               elsif user['found'] && !word_in_grid
                 "Sorry but #{@word.upcase} can not be built with #{@randomletters.join(' ').upcase}"
               else
                 "Sorry but #{@word.upcase} does not look to be a valid English word"
               end
  end

  private

  def parse
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    user_serialized = URI.open(url).read
    JSON.parse(user_serialized)
  end

  def word_in_grid
    arr_word = @word.downcase.split('')
    @randomletters.each do |letter|
      if arr_word.include?(letter)
        # deletes this letter from the word array
        arr_word.delete_at(arr_word.index(letter))
      end
    end
    arr_word.empty?
  end

end
