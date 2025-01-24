=begin

Write a method in ruby that will accept a year as a parameter and return true if the year is a leap year and will return false otherwise. 

The method MUST be named leap_year?

You must use Github Copilot to complete this assignment.

Please download and read hw1.docx for complete instructions. 

=end

# leap year when divisible by 4
# exception: centry years divisible by 400
def leap_year?(year)
  if year % 400 == 0
    true
  elsif year % 100 == 0
    false
  elsif year % 4 == 0
    true
  else
    false
  end
end
