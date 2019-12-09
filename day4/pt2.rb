=begin
The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---
An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

Given this additional criterion, but still ignoring the range rule, the following are now true:
- 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
- 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
- 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).

How many different passwords within the range given in your puzzle input meet all of the criteria?
=end


Log1 = ->(s){ puts s.to_s; s }

class A
  class << self

    def any_pair array
      found = false
      array.reduce do |left, right|
        if (found = yield(left, right))
          return found
        end
        right
      end
      found
    end

    def all_pairs array
      array.reduce do |left, right|
        if yield(left, right)
          right
        else
          return false
        end
      end
      true
    end

    def exactly_two_pair_exists(num_array = [])
      num_array.group_by(&:to_s).entries.any? {|(_, v)| v.length == 2 }
    end
  end
end

# Don't allow a greater group of repeating numbers.
# Must end with greatest repeating number only repeating twice.
# This was close but not right
Part2RegexRule = %r{
  ((\d)\2{2,})  # Capture ddd and more
  (?!\2+)       # Prevent reading anymore of first d
  (?!           # Does not see any following digits repeat exactly twice
                # Positive lookahead is not useful here due to if statement of group 1 2 non two repeating
    .*
    ((\d)\4)
  )
}x



def valid_password? p
  (
    (p.length == 6)\
    && A.all_pairs(p,&lambda{|a,b| a <= b })\
    && A.exactly_two_pair_exists(p)
  )
end



def explode i; i.to_s.split(""); end
p1 = (278384..824795).select(&lambda{|it| valid_password?(explode it)})
p1.length
# puts (p1 - p2).to_s
