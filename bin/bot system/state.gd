extends Node

@export var State_Constant: String ##if left null. Then the State Constant is unchanged, otherwise, change State Constant to this one.
@export_enum("AND","OR","SWITCH","RAND","SLEEP") var state_types: String##Affects the behavior of this State.
@export var reset_conditions_on_true: bool##Resets the met condition list FOR THIS STATE upon True evaluation
@export var reset_conditions_on_false: bool##Resets the met condition list FOR THIS STATE upon False evaluation
@export var conditions: Array[String]##Collection of Conditions. Conditional Cycle affects whether an incomplete list of met conditions can return a True or a False
@export var switch_pick: Array[Node] ## Evaluates the first value of same index (Condition) if it is true.
@export var next_if_True: Node##Next Node if the evaluated condition was True
@export var next_if_False: Node##Next Node if the evaluated condition was False
@export var print_a_line: bool##Used for Debug. Prints the text given below upon State entrance into process.
@export var print_line: String##Print Text

@export var Sleep_time: float##When Sleeping, it waits in seconds, then it throws a Cry and goes to the next state. If set to 0 seconds, directly evaluate true upon initiation. Instant.
@onready var timer = $Timer
@onready var line_printed = false
@export var MASTERNODE: Node ##DO NOT TOUCH THIS
func _ready() -> void:
	timer.wait_time = Sleep_time

# Called when the node enters the scene tree for the first time.
func cycle(Master: Node) -> void:
	MASTERNODE = Master
	if State_Constant != null and State_Constant != "":
		if State_Constant != get_parent().MasterParam.state_constant:
				get_parent().state_constant_altered.emit(State_Constant)
				get_parent().MasterParam.state_constant = State_Constant
	if print_a_line and line_printed == false:
		print(str("STATE_MACHINE: " + print_line))
		print(str(" [While on state:"+ get_parent().MasterParam.state_constant+"]"))
		print("")
		line_printed = true

	match state_types:
		"SLEEP":
			if timer.is_stopped() and Sleep_time > 0:
				timer.start()
			elif timer.is_stopped() and Sleep_time == 0:
				next(next_if_True)
		
		
		"AND":
			if conditions != null:
				var counter = int(0)
				var index = int(0)
				for element in conditions:
					if MASTERNODE.MasterParam.met_condition.has(conditions[index]):
						counter += 1
					index += 1
				if counter == conditions.size():
					next(next_if_True)
				else:
					next(next_if_False)
			else:
				next(next_if_False)
		"OR":
				var counter = int(0)
				var index = int(0)
				var condition_true = false
				for element in conditions:
					if MASTERNODE.MasterParam.met_condition.has(conditions[index]):
						condition_true = true
						next(next_if_False)
						break
					else:
						index += 1
						continue
				if condition_true == false:
					next(next_if_False)

				
		"RAND":
			if switch_pick.is_empty() == false:
				var random = randi_range(0,(switch_pick.size() - 1))
				next(switch_pick[random])
			else:
				next(next_if_False)
				
		"SWITCH":
			if switch_pick.is_empty() == false and conditions.is_empty() == false:
				var index = int(0)
				var condition_true = false
				for element in conditions:
					if MASTERNODE.MasterParam.met_condition.has(conditions[index]):
						condition_true = true
						next(switch_pick[index])
						break 
					else:
						index += 1
						continue
				if condition_true == false:
					next(next_if_False)
			else:
				next(next_if_False)
func next(next_Node: Node) -> void:
	if self != next_Node:
		line_printed = false
	if next_Node != null:
		MASTERNODE.next(next_Node)
	else:
		MASTERNODE.next(null)
func _on_timer_timeout() -> void:
	if state_types == "SLEEP":
		next(next_if_True)
			
