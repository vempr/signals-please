extends Node2D

signal day_is_over

enum DIFFICULTY { EASY, MEDIUM, HARD }
const MAX_TERMINAL_LINES := 50
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const OPTIONS: Array[String] = ["a", "b", "c"]

@onready var label := %PlayerInput
@onready var timer := %TypingTimer
@onready var terminal_text := %Text
var underscore_visible := true
var booted := false
var can_submit := true
var incoming_signal_next := false
var respond_to_signal := false
var DEBUG := false
var current_signal = null
var difficulty
var signals_left := 3
var is_allies_signal := false
var must_receive_ration := false
var ration_signal_i := -1 # only valid if player must_receive_ration

# for displaying end of day stats
var rep := 0
var rat := 0.0
var pop := 0


func _ready() -> void:
	if GAME_STATE.last_day_received_ration - GAME_STATE.day >= 2:
		must_receive_ration = true
		ration_signal_i = randi_range(1, 3)
	
	if GAME_STATE.FINAL_DAY == GAME_STATE.day:
		must_receive_ration = false
		ration_signal_i = -1
	
	label.text = ""
	label.grab_focus.call_deferred()
	DEBUG = true


func _on_player_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	label.text = ""
	if !can_submit:
		return
	
	terminal_text.text += "[color=green]> " + new_text + "[/color]" + "\n"
	
	if !booted:
		if !validate_input(new_text, ["boot"]):
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		booted = true
		
		var m = "[b]"
		m += "\n-- BOOT SEQUENCE --"
		m += "\nCONNECTION: STABLE (" + str(snapped(randf() * 2 + 3, 0.01)) + "KB/S)"
		m += "\nAUTHORIZED USER: [LEADER_ID_01]"
		m += "\nSTATUS: PROVISIONAL COMMAND ACTIVE"
		m += "\nREPUTATION INDEX: " + str(GAME_STATE.player.reputation) + "% (TRUST: " + GAME_STATE.get_reputation_status() + ")"
		m += "\nRATION DISTRIBUTION: " + str(GAME_STATE.ration_remaining) + " DAYS REMAINING"
		m += "\nPOPULATION: " + str(GAME_STATE.people_remaining) + " PEOPLE REMAINING"
		m += "\nN.A.L ALLIES ARRIVAL: " + str(GAME_STATE.FINAL_DAY - GAME_STATE.day) + " DAYS LEFT"
		m += "\n[/b]"
		await print_text(m, C.COLORS.blue)
		
		if GAME_STATE.day == 1:
			for message in C.MESSAGES.SIG.introduction:
				await wait()
				await print_text(message, C.COLORS.orange, 0.02, true)
		
		await wait(1.5)
		await print_text(C.MESSAGES.incoming_signal, C.COLORS.blue)
		
		can_submit = true
		incoming_signal_next = true
		return
	
	
	if incoming_signal_next:
		if !validate_input(new_text, ["r"]):
			terminal_text.text += "[color=red]'" + new_text + "' is not a known command. Please try again.[/color]" + "\n"
			return
			
		nl()
		can_submit = false
		incoming_signal_next = false
		respond_to_signal = true
		
		generate_real_signal()
		if !is_allies_signal:
			await print_text(get_prepared_signal(), "white", 0.03, true)
		else:
			await print_text(get_prepared_signal(), "#A689E1", 0.03, true)
		await wait(0.3)
		
		if DEBUG:
			print_text(str(current_signal.is_real))
		
		nl()
		if !is_allies_signal:
			for letter in OPTIONS:
				var m = "[b]" + letter + "[/b]: " + current_signal.data[letter].decision
				await print_text(m, C.COLORS.blue)
		else:
			for letter in ["a", "b"]:
				var m = "[b]" + letter + "[/b]: " + current_signal.data[letter].decision
				await print_text(m, "#00ff00")
		nl()
		
		can_submit = true
		return
	
	
	if respond_to_signal:
		var option = new_text.strip_edges().to_lower()
		
		if is_allies_signal:
			if !validate_input(option, ["a", "b"]):
				terminal_text.text += "[color=red]'" + new_text + "' is not an option. Please try again.[/color]" + "\n"
				return
			
			can_submit = false
			respond_to_signal = false
			%Arrow.visible = false
			%PlayerInput.visible = false
			
			nl()
			for message in current_signal.data[option].reaction:
				await print_text(message, C.COLORS.blue, 0.005, true)
			nl()
			
			if option == "b":
				GAME_STATE.lost_to = GAME_STATE.DEATH_REASON.ISOLATION
			
			GAME_STATE.day_finished = true
			return
		
		if !validate_input(option, OPTIONS):
			terminal_text.text += "[color=red]'" + new_text + "' is not an option. Please try again.[/color]" + "\n"
			return
		
		can_submit = false
		respond_to_signal = false
		
		nl()
		for message in current_signal.data[option].reaction:
			await print_text(message, C.COLORS.blue, 0.005, true)
		nl()
		
		await ddd()
		nl()
		nl()
		await assess_and_display(option)
		nl()
		await ddd()
		await ddd()
		nl()
		
		if GAME_STATE.people_remaining + pop < 0:
			%Arrow.visible = false
			%PlayerInput.visible = false
			
			nl()
			GAME_STATE.lost_to = GAME_STATE.DEATH_REASON.JUMPED
			await print_text("SIG: Commander..?", C.COLORS.orange, 0.1, true)
			await wait(0.5)
			
			%TypingTimer.stop()
			%MemoryTimer.stop()
			
			await Fade.fade_out(2.0).finished
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
			Fade.fade_in()
			queue_free()
		
		signals_left -= 1
		if signals_left > 0:
			await print_text(C.MESSAGES.incoming_signal, C.COLORS.blue)
			can_submit = true
			incoming_signal_next = true
		else:
			nl()
			await print_text("SIG: End of day report, compiling local metrics.", C.COLORS.orange, 0.01, true)
			await ddd()
			nl()
			nl()
			
			var summary := ""
			var prev_rep = GAME_STATE.player.reputation
			var prev_rat = GAME_STATE.ration_remaining
			var prev_pop = GAME_STATE.people_remaining
			
			GAME_STATE.player.reputation += rep
			GAME_STATE.people_remaining += pop 
			
			var new_rations = prev_rat + rat
			var daily_consumption = 0.1 * GAME_STATE.people_remaining
			var final_rations = new_rations - daily_consumption

			# starvation: 1 death per 0.1 missing ration days
			var deaths := 0
			if final_rations < 0.0:
				deaths = int(abs(final_rations) / 0.1)
				GAME_STATE.people_remaining = max(0, GAME_STATE.people_remaining - deaths)
				final_rations = 0.0
			
			GAME_STATE.ration_remaining = final_rations
			var curr_rep = GAME_STATE.player.reputation
			var curr_rat = GAME_STATE.ration_remaining
			var curr_pop = GAME_STATE.people_remaining

			if rep > 0:
				summary += "Reputation improved by %d%% [%d%% -> %d%%]\n" % [rep, prev_rep, curr_rep]
			elif rep < 0:
				summary += "Reputation declined by %d%% [%d%% -> %d%%]\n" % [abs(rep), prev_rep, curr_rep]
			else:
				summary += "Reputation held steady. [%d%%]\n" % [curr_rep]
			
			var after_arrivals = prev_pop + pop
			if pop > 0:
				summary += "New arrivals: %d people.\n" % pop
			elif pop < 0:
				summary += "Departures: %d people.\n" % abs(pop)
			
			summary += "Population change: %d -> %d -> %d\n" % [prev_pop, after_arrivals, curr_pop]
			
			if rat > 0:
				summary += "Ration stores increased by %.1f days [%.1f -> %.1f before consumption]\n" % [rat, prev_rat, new_rations]
			elif rat < 0:
				summary += "Ration reserves depleted by %.1f days [%.1f -> %.1f before consumption]\n" % [abs(rat), prev_rat, new_rations]
			else:
				summary += "Ration balance unchanged before consumption. [%.1f]\n" % [new_rations]
			
			summary += "Daily consumption reduced stores by %.1f days (0.1 × %d people)\n" % [daily_consumption, curr_pop + deaths]
			
			if deaths > 0:
				summary += "[!] STARVATION: %d people perished due to lack of rations.\n" % deaths
				summary += "Final rations depleted to 0.0 days.\n"
			else:
				summary += "Ration stores remaining after consumption: %.1f days.\n" % curr_rat
			
			
			await print_text(summary, "#00ff00", 0.01, true)
			await wait(1.0)
			await print_text("SIG: You must rest now, commander. See you tomorrow.", C.COLORS.orange, 0.01, true)
			GAME_STATE.day_finished = true
			day_is_over.emit()


func print_text(text: String, color: String = "white", speed: float = 0.005, take_breaks: bool = false) -> bool:
	terminal_text.text += "[color=" + color + "]"
	
	if DEBUG || (GAME_STATE.INSTANT_MESSAGES && !is_allies_signal):
		terminal_text.text += text
		terminal_text.text += "[/color]\n"
		return true
		
	for letter in text:
		terminal_text.text += letter
		
		if take_breaks && letter == ".":
			timer.start(0.3)
		elif take_breaks && [",", "-", ";"].find(letter) > -1:
			timer.start(0.1)
		else:
			timer.start(speed)
		await timer.timeout

	terminal_text.text += "[/color]\n"
	return true


func validate_input(s: String, strings: Array[String]) -> bool:
	if strings.find(s.strip_edges().to_lower()) > -1:
		return true
	else:
		return false


func wait(time: float = 0.5) -> bool:
	if DEBUG:
		return true
	timer.start(time)
	await timer.timeout
	return true


func _on_computer_in_computer() -> void:
	label.text = ""
	label.grab_focus.call_deferred()


func generate_real_signal() -> void:
	if DEBUG:
		print(must_receive_ration)
		print(ration_signal_i)
	
	var types = C.MESSAGE_TYPE.values()
	var type
	var is_real: int
	
	if must_receive_ration && ration_signal_i == signals_left:
		type = C.MESSAGE_TYPE.FOOD_SERVICE
		is_real = 1
	else:
		if signals_left == 1 && GAME_STATE.FINAL_DAY == GAME_STATE.day:
			is_allies_signal = true
			current_signal = {
				"data": C.MESSAGES.ALLIES,
				"type": type,
				"is_real": true,
			}
			return
		
		type = types[randi_range(0, types.size() - 1)]
		is_real = randi_range(0, 1)
	
	if type == C.MESSAGE_TYPE.FOOD_SERVICE && is_real:
		GAME_STATE.last_day_received_ration = GAME_STATE.day
	
	
	if is_real:
		var real_messages = C.MESSAGES.real[type]
		while real_messages.size() == 0:
			type = types[randi_range(0, types.size() - 1)]
			real_messages = C.MESSAGES.real[type]
		
		var i = randi_range(0, real_messages.size() - 1)
		
		current_signal = {
			"data": real_messages[i],
			"type": type,
			"is_real": true,
		}
		
		if type != C.MESSAGE_TYPE.FOOD_SERVICE:
			C.MESSAGES.real[type].remove_at(i)
	else:
		var fake_messages = C.MESSAGES.fake[type]
		while fake_messages.size() == 0:
			type = types[randi_range(0, types.size() - 1)]
			fake_messages = C.MESSAGES.fake[type]
			
		var i = randi_range(0, fake_messages.size() - 1)
		
		current_signal = {
			"data": fake_messages[i],
			"type": type,
			"is_real": false,
		}
		
		if type != C.MESSAGE_TYPE.FOOD_SERVICE:
			C.MESSAGES.fake[type].remove_at(i)


func nl() -> void:
	terminal_text.text += "\n"


func get_prepared_signal() -> String:	
	var d := randf()

	if d <= 0.33:
		difficulty = DIFFICULTY.EASY
	elif d <= 0.66:
		difficulty = DIFFICULTY.MEDIUM
	else:
		difficulty = DIFFICULTY.HARD
	
	var request := "[REQUEST: COULD NOT FETCH.]"
	
	if difficulty != DIFFICULTY.HARD:
		match current_signal.type:
			C.MESSAGE_TYPE.NEED_FOOD:
				request = "[REQUEST: HUMANITARIAN ENTRY CLEARANCE]"
			C.MESSAGE_TYPE.PROVIDE_FOOD:
				request = "[REQUEST: TRADE ROUTE ESTABLISHMENT]"
			C.MESSAGE_TYPE.NEED_HELP:
				request = "[REQUEST: EMERGENCY RESPONSE AUTHORIZATION]"
			C.MESSAGE_TYPE.PROVIDE_HELP:
				request = "[REQUEST: COLLABORATION PROTOCOL ACCESS]"
			C.MESSAGE_TYPE.FOOD_SERVICE:
				request = "[REQUEST: LOGISTICAL DISTRIBUTION CONFIRMATION]"
	
	var id := generate_id()
	var signal_integrity := generate_signal_integrity()
	
	var full_signal := ""
	full_signal += request
	full_signal += "\nID: " + id
	full_signal += "\nSECURITY CLEARANCE: Pending"
	full_signal += "\nSIGNAL INTEGRITY: " + signal_integrity
	full_signal += "\nMESSAGE: " + corrupt_message(current_signal.data.message_content)

	return full_signal


func generate_id() -> String:
	var id_prefix := ""
	for i in randi_range(1, 4):
		id_prefix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var id_number := str(randi_range(1, 9999))
	
	var id_suffix := ""
	for i in randi_range(1, 3):
		id_suffix += ALPHABET[randi_range(0, ALPHABET.length() - 1)]
	
	var parts = [id_prefix, id_number, id_suffix]
	
	match difficulty:
		DIFFICULTY.MEDIUM:
			var i = randi_range(0, 2)
			var part_to_corrupt = parts[i]
			part_to_corrupt[randi_range(0, part_to_corrupt.length() - 1)] = "_"
			parts[i] = part_to_corrupt
			
		DIFFICULTY.HARD:
			var corrupt_id_parts: Array[String] = []
			for i in range(randi_range(3, 5)):
				var corrupt_id_part := ""
				
				for j in range(randi_range(1, 4)):
					corrupt_id_part += "_"
				
				corrupt_id_parts.append(corrupt_id_part)
			
			return "-".join(corrupt_id_parts) + " (CORRUPT)"
	
	return "-".join(parts)


func generate_signal_integrity() -> String:
	var percent := 0.0
	
	match difficulty:
		DIFFICULTY.EASY:
			percent = snapped(randi_range(70, 99) + randf(), 0.1)
		DIFFICULTY.MEDIUM:
			percent = snapped(randi_range(40, 70) + randf(), 0.1)
		DIFFICULTY.HARD:
			percent = snapped(randi_range(0, 40) + randf(), 0.1)

	return str(percent) + "%"


func _on_memory_timer_timeout() -> void:
	var terminal_lines = terminal_text.text.split("\n")

	if terminal_lines.size() > MAX_TERMINAL_LINES:
		terminal_lines = terminal_lines.slice(terminal_lines.size() - MAX_TERMINAL_LINES, terminal_lines.size())
		terminal_text.text = "\n".join(terminal_lines)


func ddd() -> bool:
	terminal_text.text += "[color=00ff00]"
	
	for i in range(3):
		terminal_text.text += "."
		timer.start(0.6)
		await timer.timeout
	
	terminal_text.text += "[/color]"
	return true


func assess_and_display(opt: String) -> bool:
	if opt == "c":
		var reputation_deduction := randi_range(7, 9)
		var can_deduct_reputation := GAME_STATE.people_remaining + pop > 0
		if can_deduct_reputation:
			rep -= reputation_deduction
		
		await print_text("SIG: Indecisiveness is always frowned upon, commander. Please remember this.", C.COLORS.orange, 0.005, true)
		await print_text("- "+ str(reputation_deduction) +"% REPUTATION", C.COLORS.orange, 0.01)
		
		if !can_deduct_reputation:
			await print_text("[CAVEAT: Reputation deduction halted due to non-existant population.]", C.COLORS.orange, 0.01)
		
		return true
	
	if current_signal.is_real:
		match opt:
			"a":
				var reputation_addition := 2
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					rep += reputation_addition
					var people_addition := 1
					pop += people_addition
					await print_random_message(C.MESSAGES.real_success.person)
					
					await wait(0.3)
					await print_text("+ 2% REPUTATION", C.COLORS.orange, 0.01)
					await print_text("+ 1 POPULATION UNIT", C.COLORS.orange, 0.01)
				else:
					var can_add_reputation := GAME_STATE.people_remaining + pop > 0
					if can_add_reputation:
						rep += reputation_addition
					
					var ration_addition = snapped(randi_range(1, 3) + randf(), 0.1)
					rat += ration_addition
					await print_random_message(C.MESSAGES.real_success.food_service)
					
					await wait(0.3)
					await print_text("+ 2% REPUTATION", C.COLORS.orange, 0.01)
					if !can_add_reputation:
						await print_text("[CAVEAT: Reputation gain halted due to non-existant population.]", C.COLORS.orange, 0.01)
					
					await print_text("+ " + str(ration_addition) +" DAYS OF RATION", C.COLORS.orange, 0.01)
			"b":
				var reputation_deduction := 6
				var can_deduct_reputation := GAME_STATE.people_remaining + pop > 0
				if can_deduct_reputation:
					rep -= reputation_deduction
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.real_failed.person)
				else:
					await print_random_message(C.MESSAGES.real_failed.food_service)
				
				await wait(0.3)
				await print_text("- 6% REPUTATION", C.COLORS.orange, 0.01)
				if !can_deduct_reputation:
					await print_text("[CAVEAT: Reputation deduction halted due to non-existant population.]", C.COLORS.orange, 0.01)
	else:
		match opt:
			"a":
				var punishment := randi_range(1, 2)
				var reputation_deduction := 0
				var ration_deduction := 0
				var population_deduction := 0
				
				if punishment == 1:
					reputation_deduction = randi_range(4, 8)
					ration_deduction = snapped(randf(), 0.1) 
				else:
					reputation_deduction = randi_range(2, 5)
					population_deduction = 1
				
				pop -= population_deduction
				rat -= ration_deduction
				
				var can_deduct_reputation := GAME_STATE.people_remaining + pop > 0
				if can_deduct_reputation:
					rep -= reputation_deduction
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.fake_failed.person)
				else:
					await print_random_message(C.MESSAGES.fake_failed.food_service)
				
				await wait(0.3)
				await print_text("- "+ str(reputation_deduction) +"% REPUTATION", C.COLORS.orange, 0.01)
				if !can_deduct_reputation:
					await print_text("[CAVEAT: Reputation deduction halted due to non-existant population.]", C.COLORS.orange, 0.01)
				
				if punishment == 1:
					await print_text("- " + str(ration_deduction) + " DAYS OF RATION", C.COLORS.orange, 0.01)
				else:
					await print_text("- 1 POPULATION UNIT", C.COLORS.orange, 0.01)
					
			"b":
				var reputation_addition := 3
				var can_add_reputation := GAME_STATE.people_remaining + pop > 0
				if can_add_reputation:
					rep += reputation_addition
				
				if current_signal.type != C.MESSAGE_TYPE.FOOD_SERVICE:
					await print_random_message(C.MESSAGES.fake_success.person)
				else:
					await print_random_message(C.MESSAGES.fake_success.food_service)
				
				await wait(0.3)
				await print_text("+ 3% REPUTATION", C.COLORS.orange, 0.01)
				if !can_add_reputation:
					await print_text("[CAVEAT: Reputation gain halted due to non-existant population.]", C.COLORS.orange, 0.01)

	return true


# real function name should be:
# print_random_message_and_delete_it_from_list_of_messages_available
func print_random_message(s: Array) -> bool:
	var i := randi_range(0, s.size() - 1)
	await print_text(s[i], C.COLORS.orange, 0.005, true)
	s.remove_at(i)
	return true


func corrupt_message(m: String) -> String:
	var corrupted_message := ""
	var corruption_chars := ["¬", "¦", "¤", "¢", "¿"]
	var punctutation_chars := [" ", ".", ",", ":", "(", ")", "[", "]"]
	
	var corruption_rate: float
	match difficulty:
		DIFFICULTY.EASY:
			corruption_rate = 0.04
		DIFFICULTY.MEDIUM:
			corruption_rate = 0.12
		DIFFICULTY.HARD:
			corruption_rate = 0.20
	
	if is_allies_signal:
		corruption_rate = 0.001
	
	
	for i in range(m.length()):
		var current_char = m[i]
		
		if current_char in punctutation_chars:
			if randf() < corruption_rate * 0.5:  # rarer to corrupt punctuation
				corrupted_message += corruption_chars[randi_range(0, corruption_chars.size() - 1)]
			else:
				corrupted_message += current_char
		else:
			if randf() < corruption_rate:
				corrupted_message += corruption_chars[randi_range(0, corruption_chars.size() - 1)]
			else:
				corrupted_message += current_char
	
	return corrupted_message


func _on_pause_screen_back_in_game() -> void:
	label.grab_focus.call_deferred()
	
