=begin
--- Day 4: Secure Container ---
You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

However, they do remember a few key facts about the password:
-It is a six-digit number.
-The value is within the range given in your puzzle input.
-Two adjacent digits are the same (like 22 in 122345).
-Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

Other than the range rule, the following are true:
-111111 meets these criteria (double 11, never decreases).
-223450 does not meet these criteria (decreasing pair of digits 50).
-123789 does not meet these criteria (no double).
How many different passwords within the range given in your puzzle input meet these criteria?

Your puzzle input is 278384-824795.
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

  end
end

# Don't allow a greater group of repeating numbers.
# Must end with greatest repeating number only repeating twice.
Part2RegexRule = %r{
  ((\d)\2{2,}) # Capture ddd and more
  (?!\2+)      # Prevent reading anymore of first d
  (?!          # Does not see any following digits repeat exactly twice
               # Positive lookahead is not useful here due to if statement of group 1 2 non two repeating
    ((\d)\4)
  )
}x

def valid_password? p
  (
    (p.length == 6)\
    && A.any_pair(p, &lambda {|a,b| a == b })\
    && A.all_pairs(p,&lambda{|a,b| a <= b })\
    && (p.join() !~ Part2RegexRule)
  )
end

def explode i; i.to_s.split(""); end
(278384..824795).select(&lambda{|it| valid_password?(explode it)}).length
