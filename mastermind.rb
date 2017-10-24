class Game
$attempts = 0
$colors = ["голубой","синий","красный","зеленый","желтый","черный"]
$hash_colors = {}
$game_over = false

  class Player
    @@guess_colors = {}

    def people_xod
      puts "--------------------------------------"
      puts "Осталось попыток #{12-$attempts}"
      puts "Введите цвет:"
      color = gets.chomp.strip.downcase
      puts "Введите ячейку:"
      ceil = gets.chomp.strip.to_i
      $hash_colors.each { |key, value|
        if value == color && key == ceil
          puts "Вы угадали цвет и ячейку!"
          @@guess_colors[key] = value
          break
        elsif value == color
          puts "Цвет есть но в другой ячейке."
          break
        elsif key == 4
          puts "Такого цвета вообще нет!"
        end
      }
      if @@guess_colors == $hash_colors
        self.win
      else
        $attempts += 1
        self.lose if $attempts >= 12
      end
    end

    def win
      puts "Вы выиграли!!!"
      puts "Ваш результат: #{$attempts} попыток."
      $game_over = true
    end

    def lose
      puts "Sorry... Ваши попытки закончились вы проиграли."
      $game_over = true
    end

  end


  def self.player_guess
    $colors.shuffle[0..3].each_with_index { |e, i|
      $hash_colors[i+1] = e
     }
     player = Player.new
     until $game_over
       player.people_xod
     end
  end

  def self.start
    print "\nДобро пожаловать в игру Mastermind! У вас есть 12 попыток, чтобы угадать какие цвета и в каких ячейках расположены.
Всего надо угадать 4 цвета. Возможны следующие цвета: голубой, синий, красный, зеленый, желтый, черный.\n"
    puts "Выберите режим игры: 1 игрок отгадывает, компьютер загадывает; 2 игрок загадывает компьютер отгадывает"
    mode = gets.chomp.strip.to_i
    if mode == 1
      player_guess
    end
  end

end

Game.start
