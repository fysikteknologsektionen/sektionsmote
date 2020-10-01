# https://codereview.stackexchange.com/a/7939
# https://stackoverflow.com/a/14632986

class Numeric
  ROMAN_NUMBERS = {
    1000 => "m",  
     900 => "cm",  
     500 => "d",  
     400 => "cd",
     100 => "c",  
      90 => "xc",  
      50 => "l",  
      40 => "xl",  
      10 => "x",  
       9 => "ix",  
       5 => "v",  
       4 => "iv",  
       1 => "i",  
  }
  ALPH_SET = ("a".."z").to_a

  def roman
    n = self
    roman = ""
    ROMAN_NUMBERS.each do |value, letter|
      roman << letter*(n / value)
      n = n % value
    end
    return roman
  end

  def alph
    s, q = "", self
    until q < 1
      q, r = (q - 1).divmod(26)
      s.prepend(ALPH_SET[r])
    end
    return s
  end
end
