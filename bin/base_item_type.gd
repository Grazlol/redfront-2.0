extends Node

@onready var preview_3D =  $preview3D
@onready var sprite = $Sprite3D
@onready var consumable_slot = $related_ui_components/consumable_slot

@export_enum("generic","consumable","equipment") var itemType = "generic"
@export var itemID: String
@export var itemName: String
@export_multiline var description: String
@export var itemSprite: Texture##USE 64x64 TEXTURE

@export var can_be_conbined: bool
@export var combine_with_item_ID: String

@export_range(1,64) var max_amount: int

@export var instance_amount: Dictionary
@export var instances: Array
@export var storedAmount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.INITIATE_SAVE.connect(save_item_matrix)
	vario.INITIATE_LOAD.connect(load_item_matrix)
	
	preview_3D.visible = true
	vario.item_library[itemID] = self
	if itemType == "consumable":
		vario.consumable_items[itemID] = consumable_slot
# Called every frame. 'delta' is the elapsed time since the previous frame.



func add_instance() -> void:
	pass
func reduce_instance() -> void:
	pass


func save_item_matrix() -> void:
	var temporary_matrix: Dictionary
	var matrix_field_key = itemID + "_ITEM_INSTANCE_STORAGE"
	var stored_item_export = itemID + "_ITEM_STORED_AMOUNT"
	if instances.is_empty() == false:
		for element in instances:
			temporary_matrix[element] = instance_amount[element]
	vario.add_per(matrix_field_key,temporary_matrix)
	vario.add_per(stored_item_export, storedAmount)
	
func load_item_matrix() -> void:
	var matrix_field_key = itemID + "_ITEM_INSTANCE_STORAGE"
	var stored_item_export = itemID + "_ITEM_STORED_AMOUNT"
	var temporary_matrix = vario.fetch(matrix_field_key)
	
	storedAmount = vario.fetch(stored_item_export)
	for element in temporary_matrix:
		instances.push_back(element)
		instance_amount[element] = temporary_matrix[element]
