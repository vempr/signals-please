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
			"SIG: Medical officer confirms subject’s help in infirmary. Infection rate dropped.",
			"SIG: Subject voluntarily extended patrol shift. Discipline noted.",
			"SIG: Behavioral scan clean. Trust metrics rising slowly.",
			"SIG: Detected low threat probability. Integration deemed successful.",
			"SIG: Subject’s technical skills proved useful in generator repair.",
			"SIG: Agricultural output increased post-arrival. Coincidence uncertain.",
			"SIG: Nearby settlers reacted positively to your leniency.",
			"SIG: Subject acted as mediator in civil dispute. De-escalation successful.",
			"SIG: No missing assets reported. Trade concluded without loss.",
			"SIG: Subject shared regional weather data. Forecasting improved.",
			"SIG: Community reports gratitude toward Command. Reputation slightly up.",
			"SIG: Minor increase in population stability observed post-decision.",
			"SIG: Psychological evaluation: optimistic, grounded, compliant.",
			"SIG: Subject voluntarily returned surplus rations. Integrity confirmed.",
			"SIG: Nearby border posts report smoother communication. Coinciding with subject’s arrival.",
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
			"SIG: Subject’s group refusing to work. Riots forming at depot.",
			"SIG: Attempted sabotage of western relay prevented. Identity unknown but suspicious timing.",
			"SIG: Violence reported in sleeping quarters. Attributed to recent arrivals.",
			"SIG: Unauthorized transmission burst recorded after midnight. Encryption untraceable.",
			"SIG: Patrol found smuggled ammunition in subject’s quarters.",
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
			"SIG: Fatal altercation near storage block. Subject’s name appears in logs."
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
			"SIG: Counter-intelligence notes: ‘Command intuition preserved critical integrity.’",
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
			"SIG: The ‘rescued’ individual vanished after midnight. Traces lead to outer perimeter.",
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
				"message_content": "Commander… this is Lira. I’ve been walking for nine days from the dry plains. My family’s gone; the wells turned to dust and the beasts died before the second sunrise. I’m at your perimeter now. I can work-clean, carry, fix what’s broken-just don’t turn me away. I don’t have anything left to trade except my hands. Please, I’ll take whatever scraps you can spare. I don’t want to die at the gate.",
				"a": {
					"decision": "Accept her plea and send a drone escort with minimal rations.",
					"reaction": [
						"Signal received. 'You heard me, Commander? Thank you. I’ll prove I’m worth the food.'",
						"Later: 'The bread was stale, but it tasted like a miracle.'"
					]
				},
				"b": {
					"decision": "Refuse entry and instruct patrols to clear her from the fence.",
					"reaction": [
						"Faint voice: 'So Ironvale’s mercy ends at a gate, does it?'",
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
				"message_content": "Commander, my name’s Orlen. I ran the old nutrient vats east of here until the filters clogged for good. I’ve been trying to grind roots into meal, but the stench drives me mad. I’ve gone three days without sleep. If there’s any surplus left in Ironvale-anything-I’ll work it off. I remember when your convoys came with green things. I just want to taste something alive again before the cold sets in.",
				"a": {
					"decision": "Authorize emergency food relief and send remaining stock to Orlen.",
					"reaction": [
						"Voice trembling: 'You saved me, Commander. I can breathe again. Ironvale still remembers kindness.'"
					]
				},
				"b": {
					"decision": "Deny the request and preserve rations for the city core.",
					"reaction": [
						"'Understood. The core first, always. I’ll remember what mercy costs here.'"
					]
				},
				"c": {
					"decision": "Delay response until next cycle; see if he survives without aid.",
					"reaction": [
						"Next day, his channel is only static and dripping sounds.",
						"Three cycles later, beacon goes dark."
					]
				}
			}
		],

		MESSAGE_TYPE.PROVIDE_FOOD: [
			{
				"message_content": "Commander, I’m Renn of the merchant roads. I scavenged a few sealed crates from an old depot-nutrient paste, labeled human-grade. Some hissed when I opened them, but I’ve been eating it. Still alive. I can trade half my stock for a night’s shelter and protection. It’s not much, but it could feed Ironvale through the frost. Let me in, Commander. I’m tired of sleeping with one eye open.",
				"a": {
					"decision": "Approve the trade and grant temporary shelter to Renn.",
					"reaction": [
						"'I’m in, Commander. Camped near the hangars. It almost smells clean here.'",
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
				"message_content": "Commander, I’m Mara. Used to run the refinery’s hydroponic towers before the power cuts. Managed to keep a few stacks running-real greens, not synth. If you open your southern ports, I can send steady shipments. Just need a bit of fuel and oil to keep the pumps alive. If not, I’ll sell to the militias instead. They pay in blood. Your choice who eats better.",
				"a": {
					"decision": "Accept her offer and schedule intake through the south channel.",
					"reaction": [
						"'Understood. I’ll start the pumps. Ironvale will taste green again soon.'"
					]
				},
				"b": {
					"decision": "Decline, unwilling to share limited fuel reserves.",
					"reaction": [
						"'Then starve pure, Commander. I’ll feed those who value survival over pride.'"
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
				"message_content": "Commander, this is Rask. The reactor conduit ruptured. I’ve sealed what I can, but pressure’s building fast. The heat’s climbing, and the suits are starting to melt. I can’t stop it without new couplers or remote access from your end. If this goes, your silos burn with us. Please, authorize an override-or finish it clean. Just don’t let me die waiting.",
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
				"message_content": "Commander, I’m Tal from the field hospital. The generator’s dead. The wounded are freezing. I’ve burned everything I can-bedding, crates, even stretchers-but it won’t last till morning. If you have a spare cell, I can keep them alive another night. They trusted Ironvale. Don’t let them die believing a lie.",
				"a": {
					"decision": "Send an energy cell to the hospital immediately.",
					"reaction": [
						"'It’s humming again, Commander. They’ll wake soon. You saved them… and me.'"
					]
				},
				"b": {
					"decision": "Refuse, citing energy conservation protocols.",
					"reaction": [
						"'Understood. We’ll burn what’s left. Ironvale stays bright.'"
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
				"message_content": "Commander, name’s Dr. Eyr. I’ve been tending the plague remnants across the valley. Supplies are low, but my hands are steady. I’m asking to work within your walls-set up a small clinic, patch your workers, maybe your soldiers. I don’t carry the sickness; I carry the cure. Trust me, and I’ll prove it.",
				"a": {
					"decision": "Grant entry and assign a clinic zone for Dr. Eyr.",
					"reaction": [
						"'I’m inside. First patient already waiting. You made the right call, Commander.'"
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
				"message_content": "Commander, this is Neven. I keep an old relay tower alive north of your city. I’ve found faint signals-might be survivors. With your permission, I’ll bring Ironvale back onto the long-range network. You’d hear the world again, though the world might hear you too. What do you say-silence or connection?",
				"a": {
					"decision": "Approve integration and reconnect external channels.",
					"reaction": [
						"'Relay humming now. You’ll hear voices again soon, Commander. Some kind, some not.'"
					]
				},
				"b": {
					"decision": "Reject; isolation ensures safety.",
					"reaction": [
						"'Understood. I’ll let the static keep you company.'"
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
				"message_content": "Commander, I am Kael from the eastern sectors. My food synthesizer malfunctioned three days ago and I haven't eaten since. The repair drones keep passing by without stopping. I can offer technical schematics for access to your nutrition bay. My hunger is becoming distracting.",
				"a": {
					"decision": "Grant limited access to nutrition bay in exchange for schematics.",
					"reaction": [
						"'Access granted. Transmitting files now.'",
						"Later: 'The schematics appear to be public domain archives from pre-collapse databases.'"
					]
				},
				"b": {
					"decision": "Deny request and flag for security review.",
					"reaction": [
						"'Understood. I'll... find another way.' Transmission ends abruptly."
					]
				},
				"c": {
					"decision": "Monitor situation without response.",
					"reaction": [
						"Signal continues broadcasting identical message every 2.7 hours exactly."
					]
				}
			},
			{
				"message_content": "This is Jora. The soil in my sector turned acidic last week. All my crops withered overnight. I'm down to my emergency reserves, but they're running low. If Ironvale could spare any seeds or soil neutralizers, I'd be grateful. I used to supply your western quadrant before the contamination.",
				"a": {
					"decision": "Dispatch agricultural aid package to Jora's coordinates.",
					"reaction": [
						"'Package received. The soil compounds seem... familiar.'",
						"Two days later: 'Growth rates are abnormal. The plants are moving.'"
					]
				},
				"b": {
					"decision": "Refuse assistance due to resource constraints.",
					"reaction": [
						"'Then we all starve together.' Signal cuts with unusual finality."
					]
				},
				"c": {
					"decision": "Research Jora's claims before responding.",
					"reaction": [
						"Archives show western quadrant was automated hydroponics for 12 years. No human suppliers registered."
					]
				}
			}
		],
		MESSAGE_TYPE.PROVIDE_FOOD: [
			{
				"message_content": "Commander, I've discovered a cache of pre-collapse military rations in an underground bunker. The seals are intact, expiration dates unclear. I'm willing to trade for medical supplies. The coordinates are encrypted, but I'll transmit upon agreement. These could feed fifty people for months.",
				"a": {
					"decision": "Accept trade and prepare medical supplies for exchange.",
					"reaction": [
						"'Coordinates incoming. You won't regret this.'",
						"Scout team finds empty bunker with recent excavation marks. No rations detected."
					]
				},
				"b": {
					"decision": "Reject offer due to questionable food safety.",
					"reaction": [
						"'Your loss. I'll find someone who appreciates history.'"
					]
				},
				"c": {
					"decision": "Scan coordinates before committing to trade.",
					"reaction": [
						"Remote sensors detect high radiation levels at location. Area marked hazardous."
					]
				}
			},
			{
				"message_content": "I operate a functional aquaculture facility north of your position. We have surplus fish protein available for trade. Our systems are stable, but we need replacement filters. I can deliver within 48 hours if you provide the filters. The fish are... unusually large but nutritious.",
				"a": {
					"decision": "Arrange filter exchange for fish delivery.",
					"reaction": [
						"'Delivery en route. You'll find the specimens quite remarkable.'",
						"Cargo contains oversized, aggressive fish with abnormal bioluminescence."
					]
				},
				"b": {
					"decision": "Decline due to concerns about biological contamination.",
					"reaction": [
						"'Suit yourself. More for the northern clans.'"
					]
				},
				"c": {
					"decision": "Research northern water sources before responding.",
					"reaction": [
						"Satellite imagery shows all northern lakes frozen solid for 8 months annually."
					]
				}
			}
		],
		MESSAGE_TYPE.NEED_HELP: [
			{
				"message_content": "Commander, our atmospheric processor is overloading. The safety systems aren't responding. I'm the only technician still conscious. If you don't send help within the hour, the entire sector will lose breathable air. I've tried everything I know. Please, I'm begging you.",
				"a": {
					"decision": "Dispatch emergency engineering team immediately.",
					"reaction": [
						"'They're here! Thank you, Commander!'",
						"Team reports facility abandoned, systems operating normally at 87% efficiency."
					]
				},
				"b": {
					"decision": "Deny assistance due to distance and resource cost.",
					"reaction": [
						"'So this is how it ends.' Transmission continues normally for 72+ hours."
					]
				},
				"c": {
					"decision": "Monitor atmospheric readings from target sector.",
					"reaction": [
						"Remote sensors show stable, optimal air quality readings throughout alleged crisis."
					]
				}
			},
			{
				"message_content": "This is Lieutenant Mara from Outpost Gamma. We're under attack by unknown hostiles. Our defenses are failing. I'm the only command staff still active. Request immediate military support or evacuation. They're breaking through the perimeter as I speak!",
				"a": {
					"decision": "Send rapid response unit to Outpost Gamma.",
					"reaction": [
						"'Reinforcements spotted! Hold the line!'",
						"Response team finds outpost deserted, no signs of struggle. Systems powered down gracefully."
					]
				},
				"b": {
					"decision": "Deny support, citing defense protocol priorities.",
					"reaction": [
						"'Understood. Going dark.' Signal continues broadcasting routine status updates."
					]
				},
				"c": {
					"decision": "Verify Outpost Gamma's status through military channels.",
					"reaction": [
						"Records indicate Outpost Gamma was decommissioned and abandoned 4 years ago."
					]
				}
			}
		],
		MESSAGE_TYPE.PROVIDE_HELP: [
			{
				"message_content": "Commander, I represent a group of engineers who've developed a revolutionary power source. It could triple Ironvale's energy output. We need sanctuary and workshop space. In return, we'll install the system free of charge. The technology is... unconventional but proven.",
				"a": {
					"decision": "Grant sanctuary and allocate workshop resources.",
					"reaction": [
						"'We begin immediately. Your faith will be rewarded.'",
						"Energy fluctuations detected across grid. Systems reporting 'ghost loads' and unexplained drain."
					]
				},
				"b": {
					"decision": "Refuse due to security concerns about unknown technology.",
					"reaction": [
						"'Your caution will be your downfall, Commander.'"
					]
				},
				"c": {
					"decision": "Request demonstration before granting access.",
					"reaction": [
						"'Impossible without proper facilities. The offer expires in 24 hours.'"
					]
				}
			},
			{
				"message_content": "I am Dr. Silas, formerly of the Bio-Recovery Initiative. I have developed a serum that enhances human endurance and reduces sleep requirements by 70%. I need test subjects and laboratory access. The results could give Ironvale a significant advantage. The side effects are... manageable.",
				"a": {
					"decision": "Approve testing program and volunteer subjects.",
					"reaction": [
						"'Excellent. Send the first subjects immediately.'",
						"Volunteers report increased energy but developing photosensitivity and unusual vocal patterns."
					]
				},
				"b": {
					"decision": "Reject due to ethical concerns and unknown risks.",
					"reaction": [
						"'Progress requires sacrifice, Commander. Your people will remain limited.'"
					]
				},
				"c": {
					"decision": "Research Dr. Silas's credentials before considering.",
					"reaction": [
						"Bio-Recovery Initiative records show Dr. Silas was dismissed for unethical experimentation 9 years ago."
					]
				}
			}
		],
		MESSAGE_TYPE.FOOD_SERVICE: [
			{
				"message_content": "AUTOMATED NOTICE: Your nutrition paste allocation has been upgraded to premium grade. Enhanced flavor profiles and 15% increased nutritional value. Please acknowledge to receive shipment. Note: Some recipients report temporary visual disturbances during metabolic adjustment period.",
				"a": {
					"decision": "Acknowledge and schedule premium shipment receipt.",
					"reaction": [
						"Shipment arrives with mismatched labeling. Paste appears identical to standard issue.",
						"Medical reports 8% increase in mild hallucinations among consumers."
					]
				},
				"b": {
					"decision": "Decline upgrade and maintain current supply contract.",
					"reaction": [
						"Notice repeats three times with increasing urgency, then ceases."
					]
				},
				"c": {
					"decision": "Verify upgrade with central supply authority.",
					"reaction": [
						"Central authority has no record of premium paste program. Notice origin untraceable."
					]
				}
			},
			{
				"message_content": "URGENT: Ration redistribution required by Sector Directive 7-Alpha. Ironvale-9 designated as redistribution hub. Prepare to receive 200% standard allocation for temporary storage. Acknowledge compliance to maintain preferred status. Storage duration: indefinite.",
				"a": {
					"decision": "Acknowledge and prepare storage facilities.",
					"reaction": [
						"Massive shipment arrives, overwhelming storage capacity.",
						"Later investigation reveals 60% of containers empty, remainder standard rations."
					]
				},
				"b": {
					"decision": "Challenge directive authenticity and request verification.",
					"reaction": [
						"'Compliance is mandatory, Commander.' Signal source becomes increasingly hostile."
					]
				},
				"c": {
					"decision": "Cross-reference directive with sector command.",
					"reaction": [
						"No Sector Directive 7-Alpha exists. Signal traced to abandoned communications relay."
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
