extends Node
@onready var MasterParam = $master_parametersAGAHAH1515
@export var first_state: Node##please dont leave this as null. just dont. please. DO NOT

signal state_constant_altered(State_Constant: String)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	next(first_state)

func next(newNode: Node) -> void:
	MasterParam.current_state = newNode
	
	if MasterParam.current_state == null:
		MasterParam.current_state = first_state
	MasterParam.current_state.MASTERNODE = self
	MasterParam.current_state.cycle(self)
	
	
	
func cast_condition(Condition_ID: String) -> void:
	if MasterParam.met_condition.has(Condition_ID) == false:
		MasterParam.met_condition.push_back(Condition_ID)

func get_constant() -> String:
	return MasterParam.state_constant

func has_met(condition_name: String) -> bool:
	return MasterParam.met_condition.has(condition_name)
	
func clear() -> void:
	MasterParam.met_condition.clear()
