class Game
$attempts = 0
$colors = ["голубой","синий","красный","зеленый","желтый","черный"]
$hash_colors = {}
$game_over = false

  class Player
    @@guess_colors = {}
    @@forbidden_colors = []
    @@existing_colors = []
    @@wrong_ceils = {}

    def people_xod
      puts "-----------------------------------"
      puts "Осталось попыток #{12-$attempts}"
      puts "Введите цвет:"
      color = gets.chomp.strip.downcase
      puts "Введите ячейку:"
      ceil = gets.chomp.strip.to_i
      $hash_colors.each { |key, value|
        if value == color && key == ceil
          puts "Вы угадали цвет и ячейку!"
          @@guess_colors[key] = value
          puts
          break
        elsif value == color
          puts "Цвет есть но в другой ячейке."
          break
        elsif key == 4
          puts "Такого цвета вообще нет!"
        end
      }
      k = 0
      self.guess
      self.game_over(:people)
    end

    def game_over(type)
      if type == :people
        if @@guess_colors == $hash_colors
          self.win(type)
        else
          $attempts += 1
          self.lose(type) if $attempts >= 12
        end
      else
        if @@guess_colors.length >= 4
          self.win(type)
        else
          $attempts += 1
          self.lose(type) if $attempts >= 12
        end
      end
    end

    def guess
      puts
      print "#{@@guess_colors[1]}\t#{@@guess_colors[2]}\t#{@@guess_colors[3]}\t#{@@guess_colors[4]}"
      puts
    end

    def comp_xod
      color = ""
      ceil = ""
      puts "-----------------------------------"
      puts "Осталось попыток #{12-$attempts}"
      if (@@existing_colors.length + @@guess_colors.length) < 4
        $colors.shuffle.each { |e|
          if !@@guess_colors.has_value?(e) && !@@forbidden_colors.include?(e)
            color = e
            break
          end
        }
      else
        color = @@existing_colors.shuffle[0]
      end
      loop do
        ceil = 1+rand(4)
        if !@@wrong_ceils[color].nil?
          t = !@@wrong_ceils[color].include?(ceil)
        else
          t = true
        end
        break if !@@guess_colors.has_key?(ceil) && t
      end
      puts "Цвет #{color} имеет позицию #{ceil}?"
      puts "Введите 1, если да; 2 если нет; 3 если такого цвета вообще нет."
      case gets.chomp.strip.to_i
      when 1
        @@guess_colors[ceil] = color
        @@existing_colors.delete(color)
      when 2
        @@existing_colors.push(color) until @@existing_colors.include?(color)
        @@wrong_ceils[color] = !@@wrong_ceils[color].nil? ? @@wrong_ceils[color].push(ceil) : [].push(ceil)
      when 3
        @@forbidden_colors.push(color)
      end
      self.guess
      self.game_over(:comp)
    end

    def win(type)
      name = type == :people ? "Ты" : "Компьютер_228"
      puts "#{name} выиграл(a)!!!"
      puts "Результат: #{$attempts} попыток."
      $game_over = true
    end

    def lose(type)
      if type == :people
        puts "Sorry... Ваши попытки закончились вы проиграли."
      else
        puts "У компьютера_228 не получилось угадать вашу комбинацию..."
      end
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

  def self.comp_guess
    puts "Загадайте комбинацию из доступных цветов, и запишите ее к себе на листик, чтобы компьютер не увидел :)"
    gets
    player = Player.new
    until $game_over
      player.comp_xod
    end
  end

  def self.start
    print "\nДобро пожаловать в игру Mastermind! У вас есть 12 попыток, чтобы угадать какие цвета и в каких ячейках расположены.
Всего надо угадать 4 цвета. Возможны следующие цвета: голубой, синий, красный, зеленый, желтый, черный.\n"
    begin
    puts "Выберите режим игры: 1 игрок отгадывает, компьютер загадывает; 2 игрок загадывает компьютер отгадывает"
    mode = gets.chomp.strip.to_i
    if mode == 1
      player_guess
    elsif mode == 2
      comp_guess
    else
      raise "Вы ввели что-то не то, попробуйте снова"
    end
    rescue Exception => e
      puts e
      retry
    end
  end

end

Game.start
