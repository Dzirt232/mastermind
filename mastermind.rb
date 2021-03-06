class Game
$attempts = 0
$colors = ["голубой","синий","красный","зеленый","желтый","черный"]
$hash_colors = {}
$game_over = false
$line = "-----------------------------------"

  class Player
    @@guess_colors = {}
    @@forbidden_colors = []
    @@existing_colors = []
    @@wrong_ceils = {}
    @@look_color = nil
    @@wrong_ceils_color = []

    def people_xod
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

    def print_color(id)
      !@@guess_colors[id].nil? ? @@guess_colors[id] : "     "
    end

    def guess
      puts
      print "#{self.print_color(1)}  #{self.print_color(2)}  #{self.print_color(3)}  #{self.print_color(4)}\n"
      puts $line
      puts
    end

    def comp_xod
      color = ""
      ceil = ""
      puts "Осталось попыток #{12-$attempts}"
      if @@look_color == nil
        $colors.shuffle.each { |e|
          if !@@guess_colors.has_value?(e) && !@@forbidden_colors.include?(e)
            color = e
            break
          end
        }
      else
        color = @@look_color
      end
      loop do
        ceil = 1+rand(4)
        break if !@@guess_colors.has_key?(ceil) && !@@wrong_ceils_color.include?(ceil)
      end
      begin
        puts "Цвет #{color} имеет позицию #{ceil}?"
        puts "Введите 1, если да; 2 если нет; 3 если такого цвета вообще нет."
        case gets.chomp.strip.to_i
        when 1
          @@guess_colors[ceil] = color
          if @@look_color == color
            @@look_color = nil
            @@wrong_ceils_color = []
          end
        when 2
          @@look_color = color
          @@wrong_ceils_color = @@wrong_ceils_color.push(ceil)
        when 3
          if @@forbidden_colors.length >= 2
            raise "Вы врете! Обманывать не хорошо, попробуйте снова."
          end
          @@forbidden_colors.push(color)
        end
      rescue Exception => e
        puts e
        retry
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
    loop do
      puts "Выберите режим игры: 1 игрок отгадывает, компьютер загадывает; 2 игрок загадывает компьютер отгадывает"
      mode = gets.chomp.strip.to_i
      if mode == 1
        player_guess
        break
      elsif mode == 2
        comp_guess
        break
      else
        puts "Вы ввели что-то не то, попробуйте снова"
      end
    end
  end

end

Game.start
