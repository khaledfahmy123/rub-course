puts("How many scores?")
score_nums = gets.chomp.to_i
scores = []
sum = 0
avg = 0
high = -1
low = 200
grade = "F"

for i in 1..score_nums
    n = 0
    while true
        puts("enter score #{i}?")
        n = gets.chomp.to_f
        if n > 100 or n < 0
            puts(" Error: please enter a valid score between 0-100")
        else
            break
        end
    end 
    sum += n
    if n > high
        high = n
    end
    
    if n < low
        low = n
    end
    scores.push(n)
end


avg = sum / score_nums.to_f

if avg >= 90
    grade = "A"
elsif avg >= 80
    grade = "B"
elsif avg >= 70
    grade = "C"
elsif avg >= 60
    grade = "D"
else
    grade = "F"
end

puts("Results:")
puts("  Average : #{avg.round(2)}")
puts("  Grade   : #{grade}")
puts("  Highest : #{high}")
puts("  Lowest  : #{low}")