# For every two empty bottles, you can get one free (full) bottle of pop
# For every four bottle caps, you can get one free (full) bottle of pop
# Each bottle of pop costs $2 to purchase
# 
# Write a program so that you can figure out how many total bottles of pop
# can be redeemed given a customer investment.
def trade_empty_bottles(empty_bottles)
  @empties_traded += empty_bottles
  @bottles_from_empties += empty_bottles / 2
  bottle_return_hash = {
    new_bottles: (empty_bottles / 2),
    empty_bottles: (empty_bottles % 2)
  }
  return bottle_return_hash
end

def trade_caps(caps)
  @caps_traded += caps
  @bottles_from_caps += caps / 4
  cap_return_hash = {
    new_bottles: (caps / 4),
    caps: (caps % 4)
  }
  return cap_return_hash
end

def can_recycle?(empties, caps)
  return (empties / 2 > 0) || (caps / 4 > 0)
end

def recycle_for_more_pop(empties, caps)
  bottle_return_hash = trade_empty_bottles(empties)
  cap_return_hash = trade_caps(caps)
  total_return_hash = bottle_return_hash.merge(cap_return_hash) { |key, oldval, newval| oldval + newval }
  return total_return_hash
end

def pop_investment_readout(dollars_string)
  # Initialize tracker variables
  result_array = Array.new
  @bottles_bought = 0
  @empties_traded = 0
  @caps_traded = 0
  @bottles_from_empties = 0
  @bottles_from_caps = 0
  # Make the initial purchase
  dollars = dollars_string.to_i
  @bottles_bought = dollars / 2
  change = dollars % 2
  result_array << "You purchased #{@bottles_bought} bottles of pop."
  result_array << "$#{change} is your change." if change != 0
  # Prep for iteration
  @new_bottles = @bottles_bought
  @empties_remaining = 0
  @caps_remaining = 0
  # Iterate
  while @new_bottles > 0
    result_array << "You drink it all..."
    @empties_remaining += @new_bottles
    @caps_remaining += @new_bottles
    @new_bottles = 0
    result_array << "Now you have #{@empties_remaining} bottles that are empty, and #{@caps_remaining} caps."
    if can_recycle?(@empties_remaining, @caps_remaining)
      recycling_return_hash = recycle_for_more_pop(@empties_remaining, @caps_remaining)
      @new_bottles += recycling_return_hash[:new_bottles]
      @empties_remaining = recycling_return_hash[:empty_bottles]
      @caps_remaining = recycling_return_hash[:caps]
      result_array << "You trade the bottles and caps in..."
      result_array << "Now you have #{@new_bottles} more bottles!"
      result_array << "Empties left over after trade-in: #{@empties_remaining}"
      result_array << "Caps left over after trade-in: #{@caps_remaining}"
    else
      result_array << "You don't have enough caps or bottles to recycle for more pop."
    end
  end
  # Show the tracker variables
  result_array << "------------------------------"
  result_array << "You bought: #{@bottles_bought} bottles."
  result_array << "You traded in #{@empties_traded} empties for #{@bottles_from_empties} bottles."
  result_array << "You traded in #{@caps_traded} empties for #{@bottles_from_caps} bottles."
  return result_array
end

# REPL
puts "How much do you want to invest in pop?"
answer = gets.chomp
response_array = pop_investment_readout(answer)
response_array.each do |line|
  puts line
end