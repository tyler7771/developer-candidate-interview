class Tester
  class T1
    def palindrome?(string)
      return false if !string.is_a?(String)
      return false if string.length == 0

      alpha = 'abcdefghijklmnopqrstuvwxyz'
      str = ''

      string.each_char do |chr|
        chr = chr.downcase
        if alpha.index(chr) != nil
          str += chr
        end
      end

      str == str.reverse
    end
  # This is the simplest solution, but O(n2) (possibly worse with index).
  end

  class T2
    def palindrome?(string)
      return false if !string.is_a?(String)
      return false if string.length == 0
      i = 0
      j = string.length - 1

      while i < string.length / 2
        if !string[i].match(/^[[:alpha:]]$/)
          i += 1
        elsif !string[j].match(/^[[:alpha:]]$/)
          j -= 1
        elsif string[i].downcase != string[j].downcase
          return false
        else
          j -= 1
          i += 1
        end
      end

      true
    end
  end

  # This is a much better solution. This solution is O(n/2).
end
