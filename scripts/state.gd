extends Node

# player will die immediately in terminal if people_remaining is 0
# & happens to choose the wrong option + get unlucky with punishment
# (-1 person and only person left is commander -> player loses)
# ((called JUMPED cuz I couldn't think of a better name xd))
enum DEATH_REASON { HUNGER, REPUTATION, ISOLATION, JUMPED }

var INITIAL_HUNGER := randi_range(1, 10) + 20
var INITIAL_REPUTATION := randi_range(1, 10) + 40
var INITIAL_RATION_REMAINING: float = snapped(randi_range(5, 6) + randf(), 0.1)
const INITIAL_PEOPLE_REMAINING := 15

var lost_to = null
var FINAL_DAY := 10
var day := 1
var last_day_received_ration := 1
var day_finished := false
@onready var player = {
	"hunger": INITIAL_HUNGER, 
	"reputation": INITIAL_REPUTATION,
}
var ration_remaining := INITIAL_RATION_REMAINING
var people_remaining := INITIAL_PEOPLE_REMAINING

var music_player

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = load("res://assets/sfx/Dystopian Theme.mp3")
	music_player.pitch_scale = 0.8


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


func add_hunger() -> void:
	player.hunger += randi_range(1, 10) + 20


func reset() -> void:
	lost_to = null
	day = 1
	last_day_received_ration = 1
	day_finished = false
	player.hunger = INITIAL_HUNGER
	player.reputation = INITIAL_REPUTATION
	ration_remaining = INITIAL_RATION_REMAINING
	people_remaining = INITIAL_PEOPLE_REMAINING


func play_music() -> void:
	music_player.volume_db = -15.0
	music_player.play()


func stop_music() -> bool:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, 1.0)
	await tween.finished
	return true


var INSTANT_MESSAGES := false
