extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.INITIATE_SAVE.connect(saveinstance)
	vario.INITIATE_LOAD.connect(loadinstance)

func saveinstance() -> void:
	
func loadinstance() -> void:
