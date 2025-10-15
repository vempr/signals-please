extends Node


const DECREASE_AFTER_EATING = 10

# there are four types of messages:
# - SIG (your ai)
# - 'ration' people
# - 'help' people
# - ration service
# each can be a real or fake, letting fake in will tank reputation

const sig_intro_1 = "SIG: Good morning, Commander. The night patrols found two bodies near the perimeter fence. Starvation. Not our people, outsiders. They must have come from the southern wastelands."
const sig_intro_2 = "SIG: We’ll get more requests today. Traders, refugees, deserters. The law says to deny anyone without clearance. The people say we need allies."
const sig_intro_3 = "SIG: Ultimately, it’s your call. Each signal comes with a risk. Let the wrong one in and your rations run dry, or worse, your people turn on you. It is your task to spot any questionable 'signals' in the requests that we receive. Look out for request data, corrupted characters, strange syntax/phrasing, or transmission noise."

const MESSAGES = {
	"SIG": {
		"introduction": [sig_intro_1, sig_intro_2, sig_intro_3]
	},
	"need_food": [
		{
			"typing_speed": 0.01,
			"content": "bobby"
		}
	],
	"provide_food": [
		{
			"typing_speed": 0.01,
			"content": "bobby"
		}
	],
	"need_help": [
		{
			"typing_speed": 0.01,
			"content": "bobby"
		}
	],
	"provide_help": [
		{
			"typing_speed": 0.01,
			"content": "bobby"
		}
	],
	"real_food_service": [],
	"fake_food_service": [],
}

const COLORS = {
	"blue": "#26c1c9",
	"orange": "#e66e12"
}
