extends Button


@onready var item: String
@onready var slot_coord: String
@export_enum("1","2","3") var slot_column: String
@export_enum("1","2","3") var slot_row: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot_coord = str(slot_column + "x" + slot_row)
	item = "null"
	refreshslot()
		


func _on_pressed() -> void:
	pass

func refreshslot() -> void:
	if vario.inventory_slots[slot_coord] != null:
		item = vario.inventory_slots
	else:
		item = "null"
		
	if item != "null":
		icon = vario.item_instances[item]
		
