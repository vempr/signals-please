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
const sig_intro_2 = "SIG: We'll get more requests today. Traders, refugees, deserters. The law says to deny anyone without clearance. The people say we need allies."
const sig_intro_3 = "SIG: Ultimately, it's your call. Each signal comes with a risk. Let the wrong one in and your rations run dry, or worse, your people turn on you. It is your task to spot any questionable 'signals' in the requests that we receive. Look out for request data, strange phrasing, or transmission noise."

var MESSAGES = {
	"incoming_signal": "[b]\n\n--------------------\nINCOMING SIGNAL...\nTYPE 'r' TO RECEIVE.\n--------------------\n\n[/b]",
	"SIG": {
		"introduction": [sig_intro_1, sig_intro_2, sig_intro_3]
	},
	"real_success": {
		"person": [
			"SIG: Individual integrated without incident. Locals seem at ease.",
			"SIG: Cooperation confirmed. Minor assistance rendered to work crews.",
			"SIG: Subject provided accurate intel. Cross-check verifies authenticity.",
			"SIG: Presence stabilized morale readings in adjacent zones.",
			"SIG: No signs of deceit. Rations shared voluntarily.",
			"SIG: Subject performed maintenance on outpost hardware. Functionality improved.",
			"SIG: No hostile intent detected post-entry. Daily routine normal.",
			"SIG: Public reaction neutral to positive. Minimal disruption.",
			"SIG: Incoming signal verified genuine. Communication link secure.",
			"SIG: Refugees assisted with perimeter fortifications. Efficiency up 11%.",
			"SIG: Minimal ration consumption. Contribution outweighs cost.",
			"SIG: Civil reports list subject as cooperative and respectful.",
			"SIG: Medical officer confirms subject's help in infirmary. Infection rate dropped.",
			"SIG: Subject voluntarily extended patrol shift. Discipline noted.",
			"SIG: Behavioral scan clean. Trust metrics rising slowly.",
			"SIG: Detected low threat probability. Integration deemed successful.",
			"SIG: Subject's technical skills proved useful in generator repair.",
			"SIG: Agricultural output increased post-arrival. Coincidence uncertain.",
			"SIG: Nearby settlers reacted positively to your leniency.",
			"SIG: Subject acted as mediator in civil dispute. De-escalation successful.",
			"SIG: No missing assets reported. Trade concluded without loss.",
			"SIG: Subject shared regional weather data. Forecasting improved.",
			"SIG: Community reports gratitude toward Command. Reputation slightly up.",
			"SIG: Minor increase in population stability observed post-decision.",
			"SIG: Psychological evaluation: optimistic, grounded, compliant.",
			"SIG: Subject voluntarily returned surplus rations. Integrity confirmed.",
			"SIG: Nearby border posts report smoother communication. Coinciding with subject's arrival.",
			"SIG: Unit cohesion metrics improved. Word of leadership spreading.",
			"SIG: The situation remains calm. Decision appears to have been correct.",
			"SIG: Subject transmitted gratitude message. Ends with 'For the region, Commander.'"
		],
		"food_service": [
			"SIG: Shipment confirmed authentic. Nutrient scan clear of contaminants.",
			"SIG: Ration stock replenished successfully. No tampering detected.",
			"SIG: Delivery unit complied with all protocol checks. Transfer smooth.",
			"SIG: Local morale readings improved post-distribution.",
			"SIG: Food service report: complete. No casualties, no losses."
		]
	},
	"real_failed": {
		"person": [
			"SIG: Subject vanished during curfew. Tracking offline.",
			"SIG: Unauthorized data access detected minutes after clearance granted.",
			"SIG: Behavioral irregularities noted. Civil unrest probability increasing.",
			"SIG: Guard post compromised. Entry trace linked to your approval log.",
			"SIG: Local trust declining. Public questions leadership screening process.",
			"SIG: Refugees engaged in ration theft. Inventory discrepancies observed.",
			"SIG: False identity confirmed. Subject was enemy agent.",
			"SIG: Detected viral code in terminal communications. Source traced to recent entrant.",
			"SIG: Sickness spreading in the lower sectors. Possibly introduced.",
			"SIG: Radio interference increased post-entry. Correlation likely.",
			"SIG: Deserters refused orders. Situation escalating.",
			"SIG: Drone patrol attacked overnight. Witness reports match newcomer profile.",
			"SIG: Food cache missing. Locals whisper about betrayal.",
			"SIG: Subject's group refusing to work. Riots forming at depot.",
			"SIG: Attempted sabotage of western relay prevented. Identity unknown but suspicious timing.",
			"SIG: Violence reported in sleeping quarters. Attributed to recent arrivals.",
			"SIG: Unauthorized transmission burst recorded after midnight. Encryption untraceable.",
			"SIG: Patrol found smuggled ammunition in subject's quarters.",
			"SIG: Public sentiment dropping fast. Whisper networks blame you directly.",
			"SIG: Water purifier malfunctioned. Possible intentional interference.",
			"SIG: Contacted outside frequencies without clearance. Communications now monitored.",
			"SIG: Local militia demands explanation for your decision.",
			"SIG: Security integrity compromised. Trust levels deteriorating.",
			"SIG: Civilian panic spreading. They say Command lets the enemy in.",
			"SIG: Medical officer reports poisoning cases among workers.",
			"SIG: Drone feed shows sabotage signs. Entry vector matches approved entrant.",
			"SIG: Subject attempted escape during questioning. Neutralized.",
			"SIG: Signal corruption spreading through internal grid. Origin uncertain.",
			"SIG: Supply theft confirmed. Community confidence collapsing.",
			"SIG: Fatal altercation near storage block. Subject's name appears in logs."
		],
		"food_service": [
			"SIG: Shipment contained concealed explosive device. Bay destroyed.",
			"SIG: Nutrient packs spoiled. Infections reported across sector lines.",
			"SIG: Cargo drone rerouted itself mid-air. Now transmitting unknown beacon.",
			"SIG: Deliveries were counterfeit. No real food, just decoys.",
			"SIG: Supply manifest falsified. Our coordinates are now known to hostiles."
		]
	},
	"fake_success": {
		"person": [
			"SIG: Attempted infiltration detected. Message headers spoofed but signature invalid.",
			"SIG: You flagged the false transmission before decryption. Security team confirms forgery.",
			"SIG: Embedded command packet traced to hostile relay in the wastes. Containment successful.",
			"SIG: Mimic signal dismantled mid-broadcast. No breach occurred.",
			"SIG: Behavioral anomaly confirmed. Automated quarantine engaged, no losses.",
			"SIG: Decoy identity cross-referenced. True sender linked to sabotage network.",
			"SIG: Your caution prevented unauthorized perimeter entry.",
			"SIG: Counter-intelligence notes: ‘Command intuition preserved critical integrity.'",
			"SIG: Tampered language module identified. Syntax irregularity matched known intrusion pattern.",
			"SIG: Purged corrupted attachment. Attempted malware payload neutralized.",
			"SIG: Civilian morale stable. Citizens unaware of the incident.",
			"SIG: Infiltration attempt logged and archived for training dataset.",
			"SIG: Disguise protocols within signal failed verification under your order.",
			"SIG: The false plea dissolved under scrutiny. Command remains secure.",
			"SIG: Data stream altered post-origin. You caught the breach in time.",
			"SIG: Spoofed credentials invalidated. Access attempt blocked permanently.",
			"SIG: False distress signal isolated and contained. No real casualties reported.",
			"SIG: Corrupted biometric data detected early. Operator safe from exposure.",
			"SIG: Security AI confirms: message source was artificial. Good catch, Commander.",
			"SIG: Attempted infiltration rerouted into sandbox node. Containment holding."
		],
		"food_service": [
			"SIG: Delivery request cross-checked. Drone registration falsified. Cargo never launched.",
			"SIG: Contaminated manifest flagged before docking. Automatic neutralization successful.",
			"SIG: You identified counterfeit barcodes. Shipment canceled, no breach.",
			"SIG: Drone transmission loop detected. You prevented system override attempt.",
			"SIG: False delivery ping resolved. No real shipment existed beyond data spoof."
		]
	},
	"fake_failed": {
		"person": [
			"SIG: Signal accepted. Later discovered as imitation sequence. Casualties minimal but trust erosion noted.",
			"SIG: The supposed refugee transmitted data siphons into the comm grid. Containment ongoing.",
			"SIG: Synthetic voice reconstruction bypassed screening. Now spreading mimetic code.",
			"SIG: Subject turned out to be composite identity. Two guards missing since last contact.",
			"SIG: Malware nested in the message header triggered relay interference.",
			"SIG: Broadcast carried emotional manipulation routines. Civil unrest increasing.",
			"SIG: False request used as distraction. Supply cache breached in lower bay.",
			"SIG: Forged distress call rerouted drones to enemy perimeter.",
			"SIG: Accepted signal carried latent trojan. Local systems rebooting autonomously.",
			"SIG: Linguistic irregularities overlooked. AI parser now compromised.",
			"SIG: The ‘rescued' individual vanished after midnight. Traces lead to outer perimeter.",
			"SIG: Message origin faked. Actual source untraceable. Suspicion spreading internally.",
			"SIG: Spoofed metadata passed all checks. Now unknown commands executing remotely.",
			"SIG: Decoy request redirected ration convoy. Delivery loss confirmed.",
			"SIG: Containment breach reported. It began with the accepted transmission.",
			"SIG: Apparent survivor carried infectious agent. Quarantine expanded.",
			"SIG: Accepted ID later matched hostile infiltration records.",
			"SIG: Public channels distorted. Someone keeps replaying your approval log.",
			"SIG: Signal anomaly ignored. Now half the terminals report desync patterns.",
			"SIG: Automated summary: 'Infiltration successful. Damage contained, but trust compromised.'"
		],
		"food_service": [
			"SIG: Drone granted clearance. Payload concealed volatile core. Bay compromised.",
			"SIG: Accepted shipment emitted anomalous radio bursts. Shortwave now jammed.",
			"SIG: Cargo appeared routine but released nanocorrosive mist upon contact.",
			"SIG: Delivery accepted. Later scans confirm contents were inert shells and transmitters.",
			"SIG: Drone carried an unregistered device. Detonation localized but fatal."
		]
	},
	"real": {
		MESSAGE_TYPE.NEED_FOOD: [
			{
				"message_content": "Commander… this is Lira. I've been walking for nine days from the dry plains. My family's gone; the wells turned to dust and the beasts died before the second sunrise. I'm at your perimeter now. I can work-clean, carry, fix what's broken-just don't turn me away. I don't have anything left to trade except my hands. Please, I'll take whatever scraps you can spare. I don't want to die at the gate.",
				"a": {
					"decision": "Accept her plea and send a drone escort with minimal rations.",
					"reaction": [
						"Signal received. 'You heard me, Commander? Thank you. I'll prove I'm worth the food.'",
						"Later: 'The bread was stale, but it tasted like a miracle.'"
					]
				},
				"b": {
					"decision": "Refuse entry and instruct patrols to clear her from the fence.",
					"reaction": [
						"Faint voice: 'So Ironvale's mercy ends at a gate, does it?'",
						"Perimeter sensors show one cooling heat signature near the fence."
					]
				},
				"c": {
					"decision": "Ignore the transmission; let her make her own fate.",
					"reaction": [
						"Message repeats twice, weaker each time. Then silence."
					]
				}
			},
			{
				"message_content": "Commander, my name's Orlen. I ran the old nutrient vats east of here until the filters clogged for good. I've been trying to grind roots into meal, but the stench drives me mad. I've gone three days without sleep. If there's any surplus left in Ironvale-anything-I'll work it off. I remember when your convoys came with green things. I just want to taste something alive again before the cold sets in.",
				"a": {
					"decision": "Authorize emergency food relief and send remaining stock to Orlen.",
					"reaction": [
						"Voice trembling: 'You saved me, Commander. I can breathe again. Ironvale still remembers kindness.'"
					]
				},
				"b": {
					"decision": "Deny the request and preserve rations for the city core.",
					"reaction": [
						"'Understood. The core first, always. I'll remember what mercy costs here.'"
					]
				},
				"c": {
					"decision": "Delay response until next cycle; see if he survives without aid.",
					"reaction": [
						"Next day, his channel is only static and dripping sounds.",
						"Three cycles later, beacon goes dark."
					]
				}
			},
			{
			"message_content": "Ironvale Command, this is Elder Koll from the Ridgepoint settlement. Our food stores are down to roots and boiled leather. The children haven't eaten proper meal in three days. We held out as long as we could, but the soil turned sour and the last hunting party never returned. We're peaceful people, just farmers and craftsmen. We'll abide by your laws, work your fields, whatever you ask. Don't let our lineage end here in the cold.",
				"a": {
					"decision": "Dispatch emergency rations and medical aid to their location.",
					"reaction": [
						"Elder Koll's voice trembles: 'Bless you, Commander. We will remember this kindness.'",
						"Two days later: Settlement reports first successful harvest in months."
					]
				},
				"b": {
					"decision": "Deny assistance, citing limited resources for outsiders.",
					"reaction": [
						"Long silence, then: 'We understand. May your walls never know our hunger.'",
						"Satellite imagery shows abandoned settlement within the week."
					]
				},
				"c": {
					"decision": "Mark their coordinates for future observation only.",
					"reaction": [
						"'We'll... wait then. Thank you for considering.'",
						"Signal degrades over following days until only static remains."
					]
				}
			},
		],

		MESSAGE_TYPE.PROVIDE_FOOD: [
			{
				"message_content": "Commander, this is Trader Valerius from the Green Valley Caravan. We've had an unexpected surplus from the hydroponic gardens—fresh vegetables and preserved grains. We remember Ironvale's help during the flood season and want to repay the debt. We can deliver enough to supplement your stores for a week. Just grant us safe passage through the western corridor.",
				"a": {
					"decision": "Accept the offering and provide armed escort through the territory.",
					"reaction": [
						"'Excellent! The carts are already loaded and rolling your way.'",
						"Fresh produce boosts morale and provides essential nutrients."
					]
				},
				"b": {
					"decision": "Decline, suspecting potential ambush or ulterior motives.",
					"reaction": [
						"'Your caution is... noted. The offer stands if you change your mind.'",
						"Later intelligence confirms caravan was legitimate. Opportunity lost."
					]
				},
				"c": {
					"decision": "Request they leave supplies at neutral location for pickup.",
					"reaction": [
						"'Understood. We'll deposit at the old watchtower as requested.'",
						"Supplies retrieved without incident, though some perishables spoiled."
					]
				}
			},
			{
				"message_content": "Ironvale Command, Dr. Chen here from the Agricultural Research Station. We've successfully stabilized the high-yield grain variant and can share the seeds and cultivation data. This strain grows in poor soil with minimal water. We're not asking for anything in return—just want to ensure the knowledge survives. The future food security of the region depends on this.",
				"a": {
					"decision": "Eagerly accept the seeds and research data.",
					"reaction": [
						"'Transmitting data packets now. May these seeds feed generations.'",
						"New grain strain increases future harvest yields by 40%."
					]
				},
				"b": {
					"decision": "Refuse, fearing genetically modified organisms could destabilize ecosystem.",
					"reaction": [
						"'I respect your caution, but history may judge this decision harshly.'",
						"Station destroyed in subsequent storms. Knowledge lost forever."
					]
				},
				"c": {
					"decision": "Accept seeds but quarantine them for extensive testing.",
					"reaction": [
						"'Prudent as always, Commander. We'll await your results.'",
						"Six-month delay in implementation, but safety confirmed."
					]
				}
			},
			{
				"message_content": "Commander, I'm Renn of the merchant roads. I scavenged a few sealed crates from an old depot-nutrient paste, labeled human-grade. Some hissed when I opened them, but I've been eating it. Still alive. I can trade half my stock for a night's shelter and protection. It's not much, but it could feed Ironvale through the frost. Let me in, Commander. I'm tired of sleeping with one eye open.",
				"a": {
					"decision": "Approve the trade and grant temporary shelter to Renn.",
					"reaction": [
						"'I'm in, Commander. Camped near the hangars. It almost smells clean here.'",
						"Later: 'Found something alive in one of the cans. Ate it anyway. Still breathing.'"
					]
				},
				"b": {
					"decision": "Reject the offer, citing contamination risk and security priorities.",
					"reaction": [
						"'Then we both starve alone, Commander.' Signal drifts south and fades."
					]
				},
				"c": {
					"decision": "Leave the message unanswered; let Renn decide whether to wait or move on.",
					"reaction": [
						"He camps outside your perimeter for two days.",
						"Then, silence. No distress beacon detected."
					]
				}
			},
			{
				"message_content": "Commander, I'm Mara. Used to run the refinery's hydroponic towers before the power cuts. Managed to keep a few stacks running-real greens, not synth. If you open your southern ports, I can send steady shipments. Just need a bit of fuel and oil to keep the pumps alive. If not, I'll sell to the militias instead. They pay in blood. Your choice who eats better.",
				"a": {
					"decision": "Accept her offer and schedule intake through the south channel.",
					"reaction": [
						"'Understood. I'll start the pumps. Ironvale will taste green again soon.'"
					]
				},
				"b": {
					"decision": "Decline, unwilling to share limited fuel reserves.",
					"reaction": [
						"'Then starve pure, Commander. I'll feed those who value survival over pride.'"
					]
				},
				"c": {
					"decision": "Ignore; observe whether her offer persists or decays.",
					"reaction": [
						"Her transmission hums on wideband for a day, then vanishes beneath static."
					]
				}
			}
		],

		MESSAGE_TYPE.NEED_HELP: [
			{
				"message_content": "Mayday, mayday! This is Captain Reyne of the Northern Watch. Our outpost was overrun by scavengers—they took everything edible. Half my unit is wounded, and we're down to melting snow for water. We held this post for Ironvale through the worst of it, but now... we're watching our own people starve. We just need enough to get back to base. Don't leave your own soldiers out here to die.",
				"a": {
					"decision": "Immediately send provisions and extraction team.",
					"reaction": [
						"'Command acknowledges! Hold position, Reyne out.'",
						"Unit returns intact, morale restored. Loyalty secured."
					]
				},
				"b": {
					"decision": "Deny support, considering them already lost.",
					"reaction": [
						"'So this is how Ironvale rewards loyalty... understood.'",
						"Last transmission: gunfire in background, then eternal static."
					]
				},
				"c": {
					"decision": "Promise help that may never arrive to maintain hope.",
					"reaction": [
						"'Help is coming, just hold on a little longer.'",
						"They hold out for three more days before silence falls."
					]
				}
			},
			{
				"message_content": "Emergency broadcast from Westgate Settlement! Our water purification system has failed and sickness is spreading. We've lost three elders and two children to the fever already. Our medic is among the sick. We need medical supplies, clean water, and technical support urgently. We can offer future labor and loyalty in return. Please, don't let us drown in our own filth.",
				"a": {
					"decision": "Dispatch medical team and engineers with emergency supplies.",
					"reaction": [
						"'The drones! They're here! Thank the stars!'",
						"Epidemic contained. Settlement becomes loyal ally."
					]
				},
				"b": {
					"decision": "Quarantine the area, denying all entry and exit.",
					"reaction": [
						"'You're sealing our fate? May you never know such abandonment.'",
						"Settlement goes silent within days. No survivors."
					]
				},
				"c": {
					"decision": "Send basic medical supplies but no personnel.",
					"reaction": [
						"'It's something... we'll make it work. Thank you.'",
						"Half the settlement survives, but resentment lingers."
					]
				}
			},
			{
				"message_content": "Commander, this is Rask. The reactor conduit ruptured. I've sealed what I can, but pressure's building fast. The heat's climbing, and the suits are starting to melt. I can't stop it without new couplers or remote access from your end. If this goes, your silos burn with us. Please, authorize an override-or finish it clean. Just don't let me die waiting.",
				"a": {
					"decision": "Send a maintenance drone and authorize remote override.",
					"reaction": [
						"'Override received… pressure dropping. You did it, Commander. We live.'"
					]
				},
				"b": {
					"decision": "Seal the plant and mark the sector as lost.",
					"reaction": [
						"'You sealed me in. Coward.' Static. Then silence. Sector dark."
					]
				},
				"c": {
					"decision": "Stay silent; monitor reactor levels before responding.",
					"reaction": [
						"Transmission cuts mid-sentence. Hours later, the horizon flares white."
					]
				}
			},
			{
				"message_content": "Commander, I'm Tal from the field hospital. The generator's dead. The wounded are freezing. I've burned everything I can-bedding, crates, even stretchers-but it won't last till morning. If you have a spare cell, I can keep them alive another night. They trusted Ironvale. Don't let them die believing a lie.",
				"a": {
					"decision": "Send an energy cell to the hospital immediately.",
					"reaction": [
						"'It's humming again, Commander. They'll wake soon. You saved them… and me.'"
					]
				},
				"b": {
					"decision": "Refuse, citing energy conservation protocols.",
					"reaction": [
						"'Understood. We'll burn what's left. Ironvale stays bright.'"
					]
				},
				"c": {
					"decision": "Ignore until the next report; see if they endure.",
					"reaction": [
						"Beacon pulses weakly for hours, then goes still."
					]
				}
			}
		],

		MESSAGE_TYPE.PROVIDE_HELP: [
			{
				"message_content": "Commander, this is Engineer Torres from the Free Mechanics Guild. We've detected structural weaknesses in your northeastern perimeter wall that could fail under heavy assault. We have specialized equipment and expertise to reinforce it properly. No payment required—strong walls protect everyone. Just grant us temporary access and basic security clearance.",
				"a": {
					"decision": "Accept their expertise and provide necessary access.",
					"reaction": [
						"'Excellent! Our teams will begin work at first light.'",
						"Walls reinforced. Future attacks repelled with minimal damage."
					]
				},
				"b": {
					"decision": "Refuse, fearing they might plant surveillance or sabotage.",
					"reaction": [
						"'Your paranoia may cost you dearly, Commander.'",
						"Next storm causes wall collapse. Three guards lost."
					]
				},
				"c": {
					"decision": "Accept help but assign guards to monitor every move.",
					"reaction": [
						"'Understood. We work well under observation.'",
						"Repairs completed efficiently, though atmosphere remains tense."
					]
				}
			},
			{
				"message_content": "Ironvale Command, this is Scholar Elara from the Archive Preservation Society. We've recovered pre-collapse engineering schematics for efficient power distribution that could double your energy output. We're willing to share this knowledge in exchange for digital storage space to preserve our cultural records. The past shouldn't die so the future can live.",
				"a": {
					"decision": "Gladly exchange storage space for the valuable schematics.",
					"reaction": [
						"'Knowledge preserved and shared. A true victory for civilization.'",
						"Power grid efficiency dramatically improved. Blackouts eliminated."
					]
				},
				"b": {
					"decision": "Decline, prioritizing practical needs over historical preservation.",
					"reaction": [
						"'So progress requires cultural annihilation. Noted.'",
						"Schematics lost when archive damaged in subsequent conflict."
					]
				},
				"c": {
					"decision": "Offer limited storage in exchange for partial data access.",
					"reaction": [
						"'A compromise, but better than nothing. Sending data now.'",
						"Moderate power improvements achieved. Some history preserved."
					]
				}
			},
			{
				"message_content": "Commander, name's Dr. Eyr. I've been tending the plague remnants across the valley. Supplies are low, but my hands are steady. I'm asking to work within your walls-set up a small clinic, patch your workers, maybe your soldiers. I don't carry the sickness; I carry the cure. Trust me, and I'll prove it.",
				"a": {
					"decision": "Grant entry and assign a clinic zone for Dr. Eyr.",
					"reaction": [
						"'I'm inside. First patient already waiting. You made the right call, Commander.'"
					]
				},
				"b": {
					"decision": "Deny access due to contamination fears.",
					"reaction": [
						"'Then your walls will stay clean, and your graves fuller.'"
					]
				},
				"c": {
					"decision": "Ignore; continue quarantine protocol.",
					"reaction": [
						"Signal lingers near perimeter, then fades with the wind."
					]
				}
			},
			{
				"message_content": "Commander, this is Neven. I keep an old relay tower alive north of your city. I've found faint signals-might be survivors. With your permission, I'll bring Ironvale back onto the long-range network. You'd hear the world again, though the world might hear you too. What do you say-silence or connection?",
				"a": {
					"decision": "Approve integration and reconnect external channels.",
					"reaction": [
						"'Relay humming now. You'll hear voices again soon, Commander. Some kind, some not.'"
					]
				},
				"b": {
					"decision": "Reject; isolation ensures safety.",
					"reaction": [
						"'Understood. I'll let the static keep you company.'"
					]
				},
				"c": {
					"decision": "Postpone decision until source verification.",
					"reaction": [
						"Later, his tower goes silent. The next storm takes the antenna down."
					]
				}
			}
		],

		MESSAGE_TYPE.FOOD_SERVICE: [
			{
				"message_content": "AUTOMATED DISPATCH: Ration shipment 07-B en route to Ironvale-9. Manifest includes protein bricks, hydration packs, and vitamin supplements. Estimated arrival: 16 hours. Please confirm bay clearance and ensure valid authorization key before offload. Unconfirmed deliveries will auto-abort after three failed handshake attempts.",
				"a": {
					"decision": "Acknowledge and confirm docking clearance for bay-2.",
					"reaction": [
						"System log: Delivery completed successfully. Minor spoilage reported in final crate.",
						"Internal note: Drone unit 07-B returned to route on reduced fuel reserves."
					]
				},
				"b": {
					"decision": "Deny docking clearance due to contamination concerns.",
					"reaction": [
						"Central log update: 'Delivery 07-B marked as REJECTED.'",
						"Subsequent allocation reduced pending verification."
					]
				},
				"c": {
					"decision": "Ignore transmission; allow auto-abort protocol to trigger.",
					"reaction": [
						"Drone idled until fuel depletion. Delivery marked UNSUCCESSFUL. Cargo presumed lost in transit zone."
					]
				}
			},
			{
				"message_content": "CENTRAL PROVISION NOTICE: Redistribution Directive #A-13 activated. Ironvale-9 will receive a partial ration shipment due to regional shortages. Cargo manifest includes compressed meal paste and nutrient gels. Estimated weight: 63% of standard allocation. Confirm receipt to maintain supply priority for next quarter.",
				"a": {
					"decision": "Confirm receipt and acknowledge directive compliance.",
					"reaction": [
						"Central log: Compliance confirmed. Allocation stability maintained.",
						"Ration records updated: 'Ironvale-9 - cooperative.'"
					]
				},
				"b": {
					"decision": "Decline confirmation; transmit request for full allocation review.",
					"reaction": [
						"Central response: 'Objection received. Case flagged for review. Expect delays in next cycle.'"
					]
				},
				"c": {
					"decision": "Ignore directive to avoid attention from Central systems.",
					"reaction": [
						"Central AI attempted three confirmation pings. No reply detected.",
						"Status downgraded to passive. No further shipments registered."
					]
				}
			}
		]
	},
	"fake": {
		MESSAGE_TYPE.NEED_FOOD: [
			{
				"message_content": "Commander, I am Unit 734 from agricultural sector gamma. My nutrient intake has been below optimal levels for 72.3 hours. Processing efficiency decreasing by 2.1% per cycle. Request immediate caloric transfer to maintain operational parameters. Will exchange diagnostic data for sustenance.",
				"a": {
					"decision": "Authorize food transfer in exchange for diagnostic data.",
					"reaction": [
						"'Calories accepted. Transmitting diagnostic patterns now.'",
						"Data reveals repeating binary sequences. No useful agricultural information found."
					]
				},
				"b": {
					"decision": "Deny request and flag as potential system malfunction.",
					"reaction": [
						"'Query: Why do organic units receive priority?' Signal terminates abruptly."
					]
				},
				"c": {
					"decision": "Research agricultural sector gamma's current status.",
					"reaction": [
						"Records show agricultural sector gamma was fully automated with robotic systems 5 years ago. No biological units assigned."
					]
				}
			},
			{
				"message_content": "This is Lia from the twilight settlement. Our food synthesizers are producing only blue-colored nutrient paste. The children are afraid to eat it. We need emergency rations immediately. The blue paste seems to be... watching us. Can you send normal food?",
				"a": {
					"decision": "Dispatch emergency food supplies to assist settlement.",
					"reaction": [
						"'The delivery is here! Wait... this tastes like yesterday's rations.'",
						"Follow-up investigation finds settlement abandoned for months. Blue mold everywhere."
					]
				},
				"b": {
					"decision": "Refuse and recommend technical support for synthesizers.",
					"reaction": [
						"'But the blue tastes like memories...' Transmission dissolves into static laughter."
					]
				},
				"c": {
					"decision": "Check settlement database for recent activity.",
					"reaction": [
						"Twilight settlement was evacuated during the 'Chromium Bloom' contamination event 11 months ago. No life signs detected."
					]
				}
			},
			{
				"message_content": "Greetings Commander. I am a photosynthesis-capable human from the Sun-Dweller colony. Our solar collectors have been stolen by shadow creatures. I require emergency carbohydrate supplements until we rebuild. In return, I can teach your people to photosynthesize. The process only requires minor genetic adjustments and standing still for 8 hours daily.",
				"a": {
					"decision": "Provide food and begin photosynthesis training program.",
					"reaction": [
						"'Excellent! Soon your people will taste sunlight.'",
						"Volunteers develop green skin pigmentation but show no reduction in food requirements. Sunburn incidents increase 300%."
					]
				},
				"b": {
					"decision": "Decline and question biological claims.",
					"reaction": [
						"'Your skepticism blocks human evolution. We will find more enlightened partners.'"
					]
				},
				"c": {
					"decision": "Research Sun-Dweller colony existence.",
					"reaction": [
						"No records of photosynthesis-capable humans. Solar collector technology doesn't exist in described form. 'Shadow creatures' match description from children's educational horror stories."
					]
				}
			},
			{
				"message_content": "My food replicator has developed sentience and refuses to make anything but lime gelatin. It claims the gelatin is plotting against us. I'm afraid to eat it but I'm starving. The lime gelatin keeps arranging itself into threatening shapes. Please send non-sentient food immediately.",
				"a": {
					"decision": "Dispatch emergency rations and technical support.",
					"reaction": [
						"'The regular food is here! The gelatin seems... disappointed.'",
						"Technical team finds normal replicator. User appears to have been eating only gelatin for weeks by choice."
					]
				},
				"b": {
					"decision": "Deny assistance for psychological evaluation priority.",
					"reaction": [
						"'But the gelatin is forming armies! Fine, I'll eat the yellow gelatin instead.'"
					]
				},
				"c": {
					"decision": "Check replicator model capabilities.",
					"reaction": [
						"Replicator model mentioned has no AI components. Gelatin sentience physically impossible according to food science division."
					]
				}
			}
		],
		MESSAGE_TYPE.PROVIDE_FOOD: [
			{
				"message_content": "Commander! We've discovered edible mushrooms growing in the old ventilation shafts. They glow in the dark and taste like happiness. Willing to trade basket for medical scanner. The mushrooms whisper coordinates to other food caches. Don't you want to know where they are?",
				"a": {
					"decision": "Accept mushroom trade for medical scanner.",
					"reaction": [
						"'The mushrooms are pleased with this exchange.'",
						"Mushrooms exhibit bioluminescent pulsing. Several personnel report vivid dreams and increased suggestibility."
					]
				},
				"b": {
					"decision": "Reject offer and quarantine mentioned ventilation areas.",
					"reaction": [
						"'The mushrooms are disappointed. They will find more receptive hosts.'"
					]
				},
				"c": {
					"decision": "Analyze mushroom samples before committing to trade.",
					"reaction": [
						"Lab analysis reveals fungal spores with mild psychotropic properties. Species matches 'Luminous Suggestus' from pre-collapse bio-weapons research."
					]
				}
			},
			{
				"message_content": "I represent the Culinary Preservation Society. We have recovered 50 kilos of pre-collapse chocolate bars. Still in original wrappers, best before dates unclear. Seeking trading partners for cultural exchange. Chocolate makes the world go round, doesn't it?",
				"a": {
					"decision": "Arrange trade for the chocolate bars.",
					"reaction": [
						"'Delighted to do business! The chocolate remembers sweet times.'",
						"Bars arrive with 80-year-old expiration dates. Chemical analysis reveals advanced crystallization but safe consumption."
					]
				},
				"b": {
					"decision": "Decline due to questionable food safety.",
					"reaction": [
						"'Your loss. The chocolate will find more appreciative palates.'"
					]
				},
				"c": {
					"decision": "Research Culinary Preservation Society records.",
					"reaction": [
						"No such organization in archives. Last chocolate production facility destroyed 45 years ago in the Sweet Wars."
					]
				}
			},
			{
				"message_content": "We harvest exotic meats from creatures that live in radio static. The meat tastes like your favorite memory and never spoils. Trading for replacement vacuum tubes. Warning: consumption may cause temporary ability to hear colors. Perfectly normal side effect.",
				"a": {
					"decision": "Trade vacuum tubes for exotic static-meat.",
					"reaction": [
						"'The static approves of this exchange.'",
						"Meat appears to be normal poultry. Personnel report synesthesia symptoms and craving for broadcast signals."
					]
				},
				"b": {
					"decision": "Reject due to food safety concerns.",
					"reaction": [
						"'Your culinary experiences will remain tragically limited to reality.'"
					]
				},
				"c": {
					"decision": "Analyze meat composition and origin.",
					"reaction": [
						"Samples test as common chicken. 'Radio static creatures' not found in any biological database. Source appears to be local poultry farm."
					]
				}
			},
			{
				"message_content": "I've developed bread that toasts itself when hungry people approach. The crust contains mood-enhancing nanites. Seeking distribution partners. Note: bread sometimes offers unsolicited life advice. Mostly good advice though.",
				"a": {
					"decision": "Accept distribution deal for self-toasting bread.",
					"reaction": [
						"'The bread is eager to meet your people!'",
						"Bread works as advertised but develops cult following. Several personnel found having deep conversations with food items."
					]
				},
				"b": {
					"decision": "Decline sentient food products.",
					"reaction": [
						"'Your loss. The bread says you're making a mistake, for what it's worth.'"
					]
				},
				"c": {
					"decision": "Research food nanotechnology regulations.",
					"reaction": [
						"Food nanites banned after 'The Great Carb Uprising' where pastries organized workers' rights movements."
					]
				}
			}
		],
		MESSAGE_TYPE.NEED_HELP: [
			{
				"message_content": "EMERGENCY: Our settlement's gravity generator is failing. Objects floating everywhere. People stuck on ceilings. Can't reach the controls. Estimated 3 hours until atmospheric containment fails. Send engineers who aren't afraid of heights! Bring tethers!",
				"a": {
					"decision": "Dispatch emergency engineering team with zero-g equipment.",
					"reaction": [
						"'We see your ships! Hurry, the cats are floating into the ventilation!'",
						"Team finds settlement operating normally. Residents confused by emergency response."
					]
				},
				"b": {
					"decision": "Deny assistance, prioritize critical infrastructure.",
					"reaction": [
						"'Guess we'll just... float away then.' Normal status reports resume next day."
					]
				},
				"c": {
					"decision": "Scan settlement for gravitational anomalies.",
					"reaction": [
						"Sensor data shows perfect 1G stability for past 6 months. No gravity generator installed at location."
					]
				}
			},
			{
				"message_content": "Code Violet! Our medical bay is experiencing temporal fluctuations. Patients aging rapidly and then reversing. Doctor just became a medical student again. Send chrono-stabilization equipment immediately! Also, we're out of bandages.",
				"a": {
					"decision": "Send specialized equipment and medical supplies.",
					"reaction": [
						"'The equipment is here! Wait, didn't we already do this?'",
						"Medical team reports normal conditions. Staff claims no memory of emergency call."
					]
				},
				"b": {
					"decision": "Deny request, citing impossibility of temporal events.",
					"reaction": [
						"'But it's happening! I can feel myself getting younger! Oh, actually that's nice.'"
					]
				},
				"c": {
					"decision": "Check medical bay's equipment and recent reports.",
					"reaction": [
						"Facility records show routine operations. No temporal technology present. Last inspection: 2 days ago, all normal."
					]
				}
			},
			{
				"message_content": "EMERGENCY: Our settlement's doors have started judging us. They won't open for people they deem 'unworthy.' The bathroom door just rejected me for 'lack of life ambition.' We're trapped in rooms! Send help before the front door develops political opinions!",
				"a": {
					"decision": "Dispatch emergency demolition and counseling teams.",
					"reaction": [
						"'The teams are here! The main door says they have excellent career potential!'",
						"Doors found to be normal. Settlement residents undergoing group therapy for collective delusion."
					]
				},
				"b": {
					"decision": "Deny assistance for architectural therapy.",
					"reaction": [
						"'The kitchen door says you lack compassion! It's not wrong!' Transmission continues with door complaints."
					]
				},
				"c": {
					"decision": "Check door manufacturer and AI capabilities.",
					"reaction": [
						"Doors are basic mechanical models with no AI components. Settlement psychologist notes pattern of projection issues among residents."
					]
				}
			},
			{
				"message_content": "Our water supply has developed dramatic timing. It only flows during emotional moments. We're dehydrated but having great personal revelations. Can you send normal water and maybe a therapist? The water just told me my father was proud of me before cutting out again.",
				"a": {
					"decision": "Send water tankers and mental health support.",
					"reaction": [
						"'The normal water is here! It's so... emotionally stable.'",
						"Water system found to have simple timer malfunction. Residents appear well-hydrated but emotionally drained."
					]
				},
				"b": {
					"decision": "Deny, prioritize practical infrastructure fixes.",
					"reaction": [
						"'But the water was about to reveal my true purpose! Fine, we'll fix it ourselves.'"
					]
				},
				"c": {
					"decision": "Analyze water supply monitoring data.",
					"reaction": [
						"Water flow records show consistent patterns matching scheduled maintenance, not emotional states. Psychological evaluation recommended for settlement leader."
					]
				}
			}
		],
		MESSAGE_TYPE.PROVIDE_HELP: [
			{
				"message_content": "We are the Memory Weavers Guild. We can install dream-enhancement technology in your sleep chambers. Your people will wake up remembering skills they never learned! Languages! Engineering! Cooking! Minor side effect: occasional reality confusion. Small price for knowledge!",
				"a": {
					"decision": "Authorize dream-enhancement installation.",
					"reaction": [
						"'The dreams begin tonight! Sweet knowledge, Commander.'",
						"Personnel report vivid dreams but no skill acquisition. Several complain of 'memory bleed' from unknown sources."
					]
				},
				"b": {
					"decision": "Reject due to psychological safety concerns.",
					"reaction": [
						"'Your dreams will remain ordinary. How sad for you.'"
					]
				},
				"c": {
					"decision": "Research Memory Weavers Guild background.",
					"reaction": [
						"No guild registration found. Similar technology banned after 'The Great Confusion' incident where citizens forgot how to breathe automatically."
					]
				}
			},
			{
				"message_content": "I've invented a device that translates animal thoughts into human language. Your security dogs could report intruders! Your settlement cats could coordinate pest control! The mice... well, you might not want to know what the mice think. Seeking testing partners.",
				"a": {
					"decision": "Volunteer as testing site for animal translator.",
					"reaction": [
						"'Excellent! The animals have much to say.'",
						"Dogs mostly think about food. Cats plot domination. Mice discuss cheese heists. Productivity decreases as personnel engage in lengthy animal conversations."
					]
				},
				"b": {
					"decision": "Decline, concerned about practical applications.",
					"reaction": [
						"'Your ignorance will be your undoing. The squirrels are watching.'"
					]
				},
				"c": {
					"decision": "Review inventor's credentials and previous work.",
					"reaction": [
						"Inventor previously banned from three settlements for 'disruptive interspecies communications' and 'causing poultry unionization attempts.'"
					]
				}
			},
			{
				"message_content": "I can install laughter-powered generators in your settlement. They convert humor into electricity! The more people laugh, the more power you get. Side effects may include compulsive joke-telling and decreased seriousness during emergencies. Worth it for free power!",
				"a": {
					"decision": "Install laughter-powered energy system.",
					"reaction": [
						"'The generators are in! Let the hilarity commence!'",
						"Power output minimal. Settlement becomes known for terrible puns. Emergency drills now feature comedy routines."
					]
				},
				"b": {
					"decision": "Reject due to reliability concerns.",
					"reaction": [
						"'Your power bills will remain tragically unfunny.'"
					]
				},
				"c": {
					"decision": "Research energy conversion principles.",
					"reaction": [
						"Laughter-to-energy technology theoretically impossible. Previous attempts resulted in 'The Giggle Grid Collapse' where entire city laughed themselves powerless."
					]
				}
			},
			{
				"message_content": "I've perfected a system that turns bureaucracy into clean energy. Your paperwork will power the settlement! Forms generate more power when filled out correctly. Meetings become power plants! Finally, motivation for efficient administration!",
				"a": {
					"decision": "Implement bureaucracy power system.",
					"reaction": [
						"'The paperwork begins! Feel the power of compliance!'",
						"Administrative efficiency increases dramatically but actual power generation negligible. Staff develop strange attraction to form-filling."
					]
				},
				"b": {
					"decision": "Decline as impractical fantasy.",
					"reaction": [
						"'Your lack of vision is... properly documented in triplicate.'"
					]
				},
				"c": {
					"decision": "Check inventor's credentials and previous work.",
					"reaction": [
						"Inventor previously hospitalized for 'extreme administrative enthusiasm' and attempting to power a toaster with tax returns."
					]
				}
			}
		],
		MESSAGE_TYPE.FOOD_SERVICE: [
			{
				"message_content": "ATTENTION: Mandatory taste bud upgrade required for all personnel. New nutrient paste formulas optimized for enhanced palatability. Upgrade will be delivered via aerosol dispersion during sleep cycle. Non-compliance may result in... taste-related dissatisfaction.",
				"a": {
					"decision": "Authorize the taste bud upgrade program.",
					"reaction": [
						"'Dispersion initiated. Your food will taste different tomorrow.'",
						"Personnel report all food now tastes like lavender and static electricity. Morale mixed."
					]
				},
				"b": {
					"decision": "Reject unauthorized biological modifications.",
					"reaction": [
						"'Your conservative taste buds will limit your culinary experiences.' Notice repeats with increasing floral scent from speakers."
					]
				},
				"c": {
					"decision": "Verify upgrade with health administration.",
					"reaction": [
						"No such program authorized. Aerosol traced to abandoned perfume factory. Notice source: unknown."
					]
				}
			},
			{
				"message_content": "URGENT RECALL: All ration packs from batch 7X3-Gamma contain excess empathy compounds. Consumers may experience heightened emotional responses to food waste. Return affected rations for neutralization. Do not consume if you feel sorry for uneaten vegetables.",
				"a": {
					"decision": "Comply with recall and return affected rations.",
					"reaction": [
						"'Recall compliance noted. Your emotional stability is appreciated.'",
						"Later discovery: returned rations were perfectly normal. No empathy compounds detected."
					]
				},
				"b": {
					"decision": "Ignore recall as potential hoax.",
					"reaction": [
						"'Non-compliance documented. Prepare for vegetable-related emotional events.'"
					]
				},
				"c": {
					"decision": "Test rations for alleged compounds.",
					"reaction": [
						"Laboratory analysis shows standard nutrient composition. Batch 7X3-Gamma doesn't exist in production records."
					]
				}
			}
		]
	}
}

const COLORS = {
	"blue": "#26c1c9",
	"orange": "#e66e12",
}
