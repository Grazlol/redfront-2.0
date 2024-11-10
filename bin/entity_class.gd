extends Node

@export var location: Vector3
@export var rotation: Vector3
@export var flags: Array
@export var items: Dictionary

@onready var entity_id_marker: String
@onready var entity_components: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

func _process(delta: float) -> void:
	vario.chec
	
func load() -> void:
	if vario.fetch_per("HAS_CHECKPOINT_ESTABLISHED?") == true:
		for elements in get_children():
			elements.queue_free()
		
	
func save() -> void:
	pass
			
