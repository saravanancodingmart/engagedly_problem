require 'pry'
require 'active_support/core_ext/object/blank'

class Main

	def self.error_msg(error_code,line_number)
		line_no = "Line number:"+line_number 
		case error_code
		when 0
			puts line_no + " time is not an integer or Integer is not in the range of ( 0 <= 1439 )"
		when 1
			puts line_no + " Given action is wrong ! Action should be either I(IN) or O(OUT)"
		when 2
			puts line_no + " Room number is not an integer or Integer is not in the range of ( 0 < 100 )"
		when 3
			puts line_no + " Visitor_id is not an integer or Integer is not in the range of ( 0 < 1024 )"
		when 4
			puts line_no + " Input is wrong"
		when 5
			puts line_no + " Vistor should Go inside the room then only can go out"
		when 6
			puts line_no + " Vistor is already inside the room"
		when 7
			puts line_no + " OUT-time should be Greater IN-time or in_out time not present "
		end
	end

	def self.room_present(data,line_number,visitor_id,room_no,action,time)
		if data[room_no]["visitors"][visitor_id].present?
			if action === "O"
				data[room_no]["visitors"][visitor_id]["out"] = time
				in_out = data[room_no]["visitors"][visitor_id]
				if in_out["out"].present? && in_out["in"].present? && in_out["out"].to_i > in_out["in"].to_i
					calculate_time = in_out["out"].to_i - in_out["in"].to_i
					data[room_no]["time"] = data[room_no]["time"].to_i + calculate_time
					data[room_no]["visited_users"].push(visitor_id)
					data[room_no]["visited_users_count"] = data[room_no]["visited_users"].uniq.count
					data[room_no]["avg_time"]= data[room_no]["time"].to_i / data[room_no]["visited_users_count"] 
					data[room_no]["visitors"].delete(visitor_id)
				else
					Main.error_msg(7,line_number)
					exit
				end																			
			else
				Main.error_msg(6,line_number)
				exit
			end							
		else
			if action === "I" 
				data[room_no]["visitors"][visitor_id] = {
					"in" => time,
					"out" => nil
				}
			else
				Main.error_msg(5,line_number)
				exit
			end						
		end
		data			
	end

	def self.room_not_present(data,line_number,visitor_id,room_no,action,time)
		visitor = Hash.new
		visitor["time"] = 0
		visitor["visited_users"] = []
		visitor["avg_time"] = 0
		visitor["visited_users_count"] = 0
		visitor["visitors"] = Hash.new
		if action === "I" 
			visitor["visitors"][visitor_id] = {
				"in" => time,
				"out" => nil
			}
		else
			Main.error_msg(5,line_number)
			exit
		end
		data[room_no] = visitor
		data
	end

	def self.get_input(n,data)
		for i in 0..n-1 do
			input = gets.chomp
			input_array = input.split(" ")
			line_number = i.to_s
			if input_array.count === 4
				visitor_id = input_array[0]
				room_no = input_array[1]
				action = input_array[2]
				time = input_array[3]			
				if visitor_id.scan(/\D/).empty? && visitor_id.to_i >=0 && visitor_id.to_i <= 1024
					if room_no.scan(/\D/).empty? && room_no.to_i >= 0 && room_no.to_i <= 100
						if action === "I" || action === "O"
							if time.scan(/\D/).empty? && time.to_i>= 0 && time.to_i <= 1439 					
								if data[room_no].present?
									data = Main.room_present(data,line_number,visitor_id,room_no,action,time)
								else
									data = Main.room_not_present(data,line_number,visitor_id,room_no,action,time)
								end
							else
								Main.error_msg(0,line_number)
								break
							end
						else
							Main.error_msg(1,line_number)
							break
						end				
					else
						Main.error_msg(2,line_number)
						break
					end
				else
					Main.error_msg(3,line_number)
					break
				end
			else
				Main.error_msg(4,line_number)
				break
			end
		end
		data
	end

	puts "Enter integer N which represents the following N-number of lines of text:"
	n = gets.to_i

	data = {}

	result = Main.get_input(n,data)

	if result.present?
		ordered_result = result.sort_by{|key| key}
		binding.pry
	end
	
end
