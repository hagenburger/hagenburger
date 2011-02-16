# encoding: utf-8
class String
  
  def to_slug
    replacements = [
      ["ś", "s"], ["ß", "ss"],
      ["Ś", "S"], 
      ["á", "a"], ["à", "a"], ["ą", "a"], ["ä", "ae"], ["æ", "ae"],
      ["Á", "A"], ["À", "A"], ["Ą", "A"],
      ["û", "u"], ["ü", "ue"],
      ["Û", "U"],
      ["ó", "o"],  ["ö", "oe"], ["œ", "oe"],
      ["Ó", "O"],
      ["é", "e"], ["è", "e"], ["ê", "e"], ["ë", "e"], ["ę", "e"],
      ["É", "E"], ["È", "E"], ["Ê", "E"], ["Ë", "E"], ["Ę", "E"],
      ["ł", "l"], 
      ["Ł", "L"], 
      ["ź", "z"], ["ż", "z"],
      ["Ź", "Z"], ["Ż", "Z"],
      ["ć", "c"],
      ["Ć", "C"],
      ["ń", "n"], ["ñ", "n"],
      ["Ń", "N"], ["Ñ", "N"], 
      ["ÿ", "y"],
      ["Ÿ", "Y"],
      ["ï", "i"], ["í", "i"], ["ì", "i"], ["î", "i"],
      ["Ï", "I"], ["Í", "I"], ["Ì", "I"], ["Î", "I"],
      [/ ?& ?/, "-and-"], [/ ?\\+ ?/, "-and-"],
      ["€", "-Euro-"], ["$", "-Dollar-"], ["%", "-percent-"],
      ["’s", "s"], ["’n", "n"], ["'s", "s"], ["'n", "n"],
      [/n['’]t\b/, "nt"]
    ]
    slug = self.clone
    replacements.each do |from, to|
      slug.gsub!(from, to)
    end
    replacements = {
      'Ä' => 'Ae',
      'Ö' => 'Oe',
      'Ü' => 'Ue',
      'Œ' => 'Oe',
      'Æ' => 'Ae'
    }
    2.times do
      slug.gsub!(/([ÄÜÖŒ])(.)/) do |variable|
        if $2 == $2.upcase
          replacements[$1].upcase + $2
        else
          replacements[$1] + $2
        end
      end
    end
    slug.gsub!(/[^a-z0-9-]+/i, '-')
    slug.gsub!(/-+/, '-')
    slug.gsub!(/^-?(.*?)-?$/, '\1')
  end
  
end