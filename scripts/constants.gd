extends Node

enum MESSAGE_TYPE {NEED_FOOD, PROVIDE_FOOD, NEED_HELP, PROVIDE_HELP, FOOD_SERVICE}

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
	"incoming_signal": "[b]\n\n--------------------\nINCOMING SIGNAL...\nTYPE 'r' TO RECEIVE.\n--------------------\n\n[/b]",
	"SIG": {
		"introduction": [sig_intro_1, sig_intro_2, sig_intro_3]
	},
	"real": {
		MESSAGE_TYPE.NEED_FOOD: [
			{
				"message_content": "Commander, we’ve reached the edge of your perimeter after nine days of travel. There are forty of us left - farmers, miners, the sick, and a handful of children. We fled when our wells went brackish and the dust buried the crops. Our carts broke three nights ago; the beasts died a day after that. We have nothing left to trade except hands and breath. If you open the gates, we’ll work for our food - maintain your walls, clean your drains, anything. We won’t beg twice. If you turn us away, we’ll still wait outside until the wind takes us. Please decide soon - the children have stopped speaking.",
				"a": {
					"decision": "Accept their plea and send a drone escort with minimal rations.",
					"reaction": [
						"Transmission received. Relief convoy sighted approaching. You have our lives now, Commander. We won’t forget this.",
						"Small signal detected later: 'The children ate. Two of them smiled.'"
					]
				},
				"b": {
					"decision": "Refuse entry and instruct the patrols to clear them from the fence.",
					"reaction": [
						"Brief static. Then a voice: 'So this is mercy in Ironvale?'",
						"Later log entry: perimeter sensors report a pile of heat signatures cooling outside the gate."
					]
				},
				"c": {
					"decision": "Ignore the transmission; let them make their own fate.",
					"reaction": [
						"Signal repeats twice, weaker each time. No new transmission received after nightfall."
					]
				}
			},
			{
				"message_content": "To the leadership of Ironvale-9: this is Station Vora, eastern agricultural unit. We have exhausted the nutrient slurry - the filters are clogged beyond repair. We’ve begun grinding dried roots, insulation fiber, anything that will burn. The smell drives some mad. A child died yesterday. Our elders remember when Ironvale sent convoys filled with green things. If there’s a reserve left, share it now. We will pay back in soil once the thaw comes. Don’t let another winter begin with our mouths empty.",
				"a": {
					"decision": "Authorize emergency food relief and send remaining stock to Station Vora.",
					"reaction": [
						"Message acknowledgment: 'We hear the drones. You’ve given us a season more. Ironvale lives in our thanks.'"
					]
				},
				"b": {
					"decision": "Deny the request and preserve rations for the city core.",
					"reaction": [
						"Return message: 'Understood. The core first, always. The soil will remember who it fed last.'"
					]
				},
				"c": {
					"decision": "Delay response until next cycle; see if they survive without aid.",
					"reaction": [
						"No reply. The next day, their channel broadcasts static interspersed with dripping water.",
						"Three cycles later, Station Vora’s beacon goes dark."
					]
				}
			}
		],

		MESSAGE_TYPE.PROVIDE_FOOD: [
			{
				"message_content": "Greetings from the merchant convoy Havelock. We recovered sealed containers from an old military depot to the west. The labeling claims ‘nutrient paste – human-grade.’ We’re willing to exchange half the load for entry, rest, and a promise of security. Some of the tins hiss when opened, but most seem intact. Our people have eaten it - no deaths yet. Consider the value of steady supply, Commander; this could keep Ironvale-9 fed through the frost months. All we ask is a place within your walls and a flag that means protection.",
				"a": {
					"decision": "Approve the trade and grant temporary settlement rights to the convoy.",
					"reaction": [
						"Signal: 'We’re in. Setting up camp near the lower hangars. The air here… it almost smells clean.'",
						"Two days later: 'Found something strange in one of the cans - moving, but edible.'"
					]
				},
				"b": {
					"decision": "Reject the offer, citing contamination risk and security priorities.",
					"reaction": [
						"Response: 'Then you’ll starve safe, and we’ll starve free.' Convoy signal drifts south and fades."
					]
				},
				"c": {
					"decision": "Leave the message unanswered; let them decide whether to wait or move on.",
					"reaction": [
						"They camp outside perimeter range for 48 hours.",
						"Then silence - not even a ping from their distress beacon."
					]
				}
			},
			{
				"message_content": "Commander, I am Mara, quartermaster of the old refinery cooperative. We’ve converted our condensation towers into hydroponic stacks. The yield is thin but steady - real greens, not synth gel. If Ironvale-9 opens its lower ports, we can pipe shipments weekly. Our engineers require only fuel and machine oil. This could rebuild trust between our sectors. Refuse, and we’ll have to sell to the militias farther south - and you know what they’ll pay with. Choose your trade partners carefully.",
				"a": {
					"decision": "Accept the deal and schedule the first intake through the south channel.",
					"reaction": [
						"'Acknowledged, Ironvale. The pipes will hum again by dawn.'",
						"Later: 'First crates arrived intact. It smells like life in here.'"
					]
				},
				"b": {
					"decision": "Decline, unwilling to share limited fuel reserves.",
					"reaction": [
						"'Then the south will feast while you drink dust, Commander.'",
						"The link drops with a metallic echo, as if a pipe just sealed shut."
					]
				},
				"c": {
					"decision": "Ignore; observe whether their offer persists or decays.",
					"reaction": [
						"Days pass. The refinery network hums faintly on wideband. No further contact."
					]
				}
			}
		],

		MESSAGE_TYPE.NEED_HELP: [
			{
				"message_content": "Emergency transmission: the reactor conduit ruptured two hours ago. Coolant systems are failing. We’ve sealed the lower tunnels but heat is rising fast. We’ve lost two technicians already - boiled alive when the valve burst. If we can’t get fresh couplers or a remote override from Command, the plant will detonate and burn everything within three kilometers, including your ration silos. Please, Commander, send authorization or send mercy. Either way, end this waiting before the steel begins to glow.",
				"a": {
					"decision": "Send a maintenance drone and attempt remote override authorization.",
					"reaction": [
						"You receive a shaky voice: 'Override accepted. Pressure falling. You saved us, Commander… and Ironvale’s food.'"
					]
				},
				"b": {
					"decision": "Seal the plant completely and mark the sector as lost.",
					"reaction": [
						"'You sealed us in.' Static. Then a dull thud. Reactor readings flatline. Sector now uninhabitable."
					]
				},
				"c": {
					"decision": "Stay silent and monitor the radiation levels before responding.",
					"reaction": [
						"Reactor signal cuts off mid-sentence. Hours later, the sky above Sector 4 turns white for three seconds."
					]
				}
			},
			{
				"message_content": "Commander, this is a distress call from the field hospital beyond the canal. Our generators are dry, and the wounded are freezing in their sleep. We still treat the militia you sent last month - the ones burned during the silo riot - but our fuel stores are gone. If you send power cells, we’ll live another week. If not, the infection will claim the survivors by dawn. We’ve done everything right, Commander. We believed the promises of Ironvale-9. Don’t let that faith die shivering.",
				"a": {
					"decision": "Authorize an energy shipment to the hospital immediately.",
					"reaction": [
						"‘Warmth returns, Commander. They’ll wake soon. You’ve done more than save lives - you’ve kept hope alive.’"
					]
				},
				"b": {
					"decision": "Refuse, citing conservation protocols.",
					"reaction": [
						"'Copy that. We’ll burn what we have left - the beds, maybe the walls. Ironvale remains pure.'"
					]
				},
				"c": {
					"decision": "Ignore until the next report; see if they stabilize on their own.",
					"reaction": [
						"When you finally check, their beacon pulses a slow, irregular tone. Then it stops."
					]
				}
			}
		],

		MESSAGE_TYPE.PROVIDE_HELP: [
			{
				"message_content": "To Ironvale command: I am Dr. Calven Eyr, last of the Institute’s field medics. I’ve been traveling between settlements treating plague remnants. My supplies are thin, but my experience is vast. I’m requesting entry not as a refugee, but as a volunteer. Let me establish a clinic within your perimeter. In exchange, I’ll tend to your workers, your soldiers, even your machines if they bleed oil. I know trust is expensive here, but illness is costlier.",
				"a": {
					"decision": "Grant Dr. Eyr entry and designate a small clinic zone.",
					"reaction": [
						"'Permission received. I’m inside. First patient already in line. You’ve chosen wisely.'"
					]
				},
				"b": {
					"decision": "Deny access, citing contamination fears.",
					"reaction": [
						"'Understood. The sick will die clean, outside your perfect walls.'"
					]
				},
				"c": {
					"decision": "Ignore and continue standard quarantine procedure.",
					"reaction": [
						"Signal remains at perimeter for several hours, then vanishes into storm interference."
					]
				}
			},
			{
				"message_content": "Commander, this is Operator Neven of the eastern relay. My team specializes in restoring long-range communications - the old kind, before compression loss ate meaning. We’ve picked up faint signals northward, maybe survivors or traders. With your permission, we’ll integrate Ironvale-9 into the network again. It could bring allies… or draw attention. Your call. Silence is safer, but silence is slow death.",
				"a": {
					"decision": "Approve integration and risk external contact.",
					"reaction": [
						"'Relay online. You should hear the world again soon, Commander. It’s not kind, but it’s alive.'"
					]
				},
				"b": {
					"decision": "Reject; isolation is stability.",
					"reaction": [
						"'Copy. Cutting all outbound frequencies. Ironvale remains a whisper among ruins.'"
					]
				},
				"c": {
					"decision": "Postpone decision until further verification of the source.",
					"reaction": [
						"No response. You later find their relay tower dark, its antennae sheared by wind."
					]
				}
			}
		],

		MESSAGE_TYPE.FOOD_SERVICE: [
			{
				"message_content": "Automated dispatch: Ration shipment 07-B en route. Containing nutrient blocks, synthetic protein paste, and hydration packets. Estimated arrival: sixteen hours, subject to drone fuel reserves. Please confirm docking clearance for sector bay-2 and ensure all recipients present identification tokens. Any deviation or theft will void next cycle’s delivery. Remember, hunger is not rebellion - until it is.",
				"a": {
					"decision": "Acknowledge and confirm delivery to bay-2.",
					"reaction": [
						"Confirmation ping received. Delivery completed with minor spoilage. Rations distributed."
					]
				},
				"b": {
					"decision": "Refuse docking clearance due to contamination report.",
					"reaction": [
						"Dispatch system response: 'Noted. Shipment rerouted to Bastion-5. Quota reduction applied.'"
					]
				},
				"c": {
					"decision": "Ignore transmission; let the drone idle outside the perimeter.",
					"reaction": [
						"Drone hovers for twelve hours, fuel depletes, then crashes into the dust. Cargo unsalvageable."
					]
				}
			},
			{
				"message_content": "System notice: Emergency redistribution order from Central Provisioning. Ironvale-9’s scheduled ration intake has been reduced by thirty percent to compensate for famine relief in the outer zones. The remaining cargo will be delivered by dusk. This adjustment is final. We appreciate your cooperation and ongoing demonstration of stability. Remember, compliance ensures continuity.",
				"a": {
					"decision": "Acknowledge the reduction and prepare public statement of gratitude.",
					"reaction": [
						"Central: 'Your cooperation noted. Stability index improved by 0.2%. Continue compliance.'"
					]
				},
				"b": {
					"decision": "Protest the cut, transmitting formal objection to Central.",
					"reaction": [
						"Response from Central: 'Your tone is recorded. Further insubordination may affect future allocations.'"
					]
				},
				"c": {
					"decision": "Ignore; keep the information internal to avoid panic.",
					"reaction": [
						"Citizens unaware for now. Whispers start when rations run short two days later."
					]
				}
			}
		]
	},
	"fake": {
		MESSAGE_TYPE.NEED_FOOD: [],
		MESSAGE_TYPE.PROVIDE_FOOD: [],
		MESSAGE_TYPE.NEED_HELP: [],
		MESSAGE_TYPE.PROVIDE_HELP: [],
		MESSAGE_TYPE.FOOD_SERVICE: [],
	},
}

const COLORS = {
	"blue": "#26c1c9",
	"orange": "#e66e12"
}
