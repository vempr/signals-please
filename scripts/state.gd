extends Node

# player will die immediately during day if people_remaining is 0
# & happens to choose the wrong option + get unlucky with punishment
# (-1 person and only person left is commander -> player loses)
enum DEATH_REASON { HUNGER, REPUTATION, ISOLATION }

const INITIAL_HUNGER := 99 # randi_range(1, 10) + 20
var INITIAL_REPUTATION := randi_range(1, 10) + 40
var INITIAL_RATION_REMAINING: float = 0.2 # snapped(randi_range(5, 7) + randf(), 0.1)
const INITIAL_PEOPLE_REMAINING := 15

var lost_to = null
var FINAL_DAY := 10
var day := 1
var day_finished := false
@onready var player = {
	"hunger": INITIAL_HUNGER, 
	"reputation": INITIAL_REPUTATION,
}
var ration_remaining := INITIAL_RATION_REMAINING
var people_remaining := INITIAL_PEOPLE_REMAINING


func get_reputation_status() -> String:
	if player.reputation >= 60:
		return "TRUSTED"
	elif player.reputation >= 50:
		return "RESPECTED"
	elif player.reputation >= 40:
		return "NEUTRAL"
	elif player.reputation >= 30:
		return "UNSTEADY"
	elif player.reputation >= 20:
		return "DISTRUSTED"
	elif player.reputation >= 10:
		return "DESPISED"
	return "CONDEMNED"


func reset() -> void:
	lost_to = null
	day = 1
	day_finished = false
	player.hunger = INITIAL_HUNGER
	player.reputation = INITIAL_REPUTATION
	ration_remaining = INITIAL_RATION_REMAINING
	people_remaining = INITIAL_PEOPLE_REMAINING
