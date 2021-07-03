class Slot
	@@slot_created = false
	@@slot_array = []
	@@multilevel_number = 0

	def self.book_slot(number, color)
		flag, level_slot, message = check_slot(number)
		if flag
			ticket_id = Slot.reserve_slot(level_slot, color, number)
			p "Parking slot booked successfully. Ticket Id is #{ticket_id}"
		else
			p message	
		end
	end

	def self.reserve_slot(level_str, color, number)
		if !@@slot_array.empty?
			slot = @@slot_array.first
			slot = slot.delete(level_str)
			ticket_id = "#{level_str}CARN#{number}COL#{color}"
			@@slot_array.push({"#{ticket_id}" => true})	
			return ticket_id
		else
			p "parking lot is not created"
		end
	end
	
	def self.set_slot(multilevel, slot_number)
		puts 'Please valid level' if  multilevel < 0
		puts 'Please valid number of parking slot' if slot_number < 0
		multilevel = 1 if multilevel.zero?
		unless @@slot_created
			@@slot_created = true
			@@multilevel_number = multilevel
			for level in 1..multilevel 
				for slot in 1..slot_number 
					@@slot_array.push({ "TID#{level}_#{slot}" => false })
				end
			end
			puts 'Parking level and number of parking slot is created'
		end
	end

	def self.cancel_slot(ticket_id)
		flag = false
		@@slot_array.each do |slot|
			if slot.has_key?(ticket_id)
        	        	slot = slot.delete(ticket_id)
				level_str = ticket_id.split("CARN")			
	                	@@slot_array.push({"#{level_str.first}" => true})
				flag = true
				p 'Ticket id successfullt deleted'
			end
		end
		p "provided ticket id #{ticket_id} is wrong" unless flag
	end

	def self.check_slot(number)
		flag = false
		level_slot = ''
		@@slot_array.each do |slot|
			slot.each do |key, value|
				unless value
					level_slot = key
					flag = true
					break
				end
			end
		end
		[flag, level_slot, (flag ? '' : 'Parking is full')]	
	end

	def self.ticket_number(number)
		p "Please provide registration number" if number.empty?
		return nil if number.empty?
		if !@@slot_array.empty?
			@@slot_array.each do |slot|
				slot.each do |k,v|
					if k.include?(number)
						p "ticket number is#{k}"
						break
					end
				end
			end
		else
			p "parking slot is empty"
		end
	end

	def self.registration_numbers_with_color(color)
		p "Please provide color" if color.empty?
                return nil if color.empty?
		
		if !@@slot_array.empty?
			number_array = []
			flag = false
			@@slot_array.each do |slot|
				slot.each do |k,v|
					if v && (k.include?(color))
						number_array.push(k.split("CARN").last.split("COL").first)
						flag = true
					end
				end
			end
			p "#{flag ? number_array.join(",") : 'No car with color present'}"
		else
			p "No registration number found"
		end
	end

	def self.ticket_number_with_color(color)
		p "Please provide color" if color.empty?
                return nil if color.empty?
		if !@@slot_array.empty?
                        number_array = []
                        flag = false
                        @@slot_array.each do |slot|
	                        slot.each do |k,v|
        	                        if v && (k.include?(color))
                	                        number_array.push(k)
                        	                flag = true
                               		 end
                        	end
			end
                        p "#{flag ? number_array.join(",") : 'No car with color present'}"
                else
                        p "No registration number found"
                end
	end

	def self.mainMenu
   		puts "Welcome Parking Lot Menu
     		1: Create a parking lot
      		2: Get a ticket
      		3: Remove ticket
      		4: Get Registration numbers of all cars of a particular Color
      		5: Ticket number in which a car with a given registration number is placed.
		6: Ticket numbers of all ticket where a car of a particular color is placed.
		7: Exit"
		p "please provide your input"
		case gets.strip
  			when "1"
    				p "please enter level of parking"
				level = gets.strip
    				p "number of slot at per level"
				slot = gets.strip
				if @@slot_created
					Slot.set_slot(level.to_i, slot.to_i)
				else
					p "Parking is already created, You want to overwrite(true) or false"
					state = gets.strip
					if state == true
						Slot.set_slot(level.to_i, slot.to_i)
					end
				end
				Slot.mainMenu				
  			when "2"
				p "please enter vehicle color"
				color = gets.strip
				p "please enter vehicle number"
				number = gets.strip
    				Slot.book_slot(number, color)
				Slot.mainMenu
  			when "3"
    				p "please enter ticket to exit"
				ticket_id = gets.strip
				Slot.cancel_slot(ticket_id)
				Slot.mainMenu
  			when "4"
    				p "please enter color"
                                color = gets.strip
                                Slot.registration_numbers_with_color(color)
				Slot.mainMenu
  			when "5"
    				p "please enter ticket to exit"
                                ticket_id = gets.strip
                                Slot.ticket_number(ticket_id)
				Slot.mainMenu
  			when "6"
    				p "please enter color"
                                color = gets.strip
                                Slot.ticket_number_with_color(color)
				Slot.mainMenu
  			when "7"
    				exit(0)
		end
	end
end

Slot.mainMenu
