extends Node

@onready var playername = "P1"
@onready var TEMPORARY_FLAGS: Dictionary
@onready var userRepo = ConfigFile.new()
@onready var mouse_position: Vector2
@onready var GAME_PAUSED: bool
@onready var current_world: Node
@onready var item_library: Dictionary
@onready var consumable_items: Dictionary
@onready var packed_scene_name = str(playername + "saveGame")
@onready var minimapitems: Dictionary
@onready var item_instances: Dictionary
@onready var inventory_slots = {

	"1x1": null, "1x2": null, "1x3": null,

	"2x1": null, "2x2": null, "2x3": null,

	"3x1": null, "3x2": null, "3x3": null

}

signal INITIATE_SAVE
signal INITIATE_LOAD


signal pushNode(NodeString: String, NodeType: Node)
signal pullNode(NodeString: String)
signal set_Next(NodeType: Node)
signal fadeOut

signal SYNCHRONIZITÄT
signal environmentrefresh
signal zone_transition


signal item_refresh_slots

signal item_add(item_id:String)
signal item_del(item_id:String)

func _ready() -> void:
	pass
		

#TEMPORARY VARIABLE STORAGE THAT GETS CLEARED WHEN THE GAME DIES. IT IS INHERENTLY SECURE DUE TO RUNTIME EMBED BUT IM NOT ENTIRELY SURE.
func add(identifier: String, vardata): #EXPLICITLY ONLY SUPPORTS SINGLE VALUES SUCH AS STRING, FLOAT, AND INT. NEVER SERIALIZE BIG DATATYPES IF YOU DONT WANT THE GAME TO DIE.
	#IF VARNAME EXISTS ALREADY THEN JUST MODIFY THE VALUE INSIDE.
	TEMPORARY_FLAGS[identifier] = vardata

func fetch(identifier: String): #RETURNS A RAW VALUE OF THE VARIABLE.
	if TEMPORARY_FLAGS.has(identifier) == false:
		return null
	else:
		return TEMPORARY_FLAGS[identifier]






#PERSISTENT VARIABLE STORAGE THAT GETS STORED EVEN AFTER GAMEDEATH. NOT SECURE SINCE STORED IN INI-FORM IN A CFG FILE HIDDEN SOMEWHERE
func add_per(varname: String, vardata):
	userRepo = ConfigFile.new()
	var err = userRepo.load("user://PERSISTENT.cfg")
	if err != OK:
		return
	userRepo.set_value(playername,varname,vardata)
	userRepo.save("user://PERSISTENT.cfg")
	
	
func fetch_per(flagname: String): #DITTO.
	userRepo = ConfigFile.new()
	var err = userRepo.load("user://PERSISTENT.cfg")
	if err != OK:
		return null
	var outputval = userRepo.get_value(playername,flagname, null)
	return outputval









#SAME AS PERSISTENT BUT NOT TIED TO USERTYPE
func add_cfg(varname: String, vardata):
	userRepo = ConfigFile.new()
	var err = userRepo.load("user://PERSISTENT.cfg")
	if err != OK:
		return
	userRepo.set_value("CONFIG",varname,vardata)
	userRepo.save("user://PERSISTENT.cfg")

		
	
func fetch_cfg(flagname: String): #DITTO.
	userRepo = ConfigFile.new()
	var err = userRepo.load("user://PERSISTENT.cfg")
	if err != OK:
		return null
	var outputval = userRepo.get_value("CONFIG",flagname, null)
	return outputval



func insert_ui(scene_directory: String) -> void:
	var scene = load(scene_directory)
	var new_ui_window = scene.instantiate()
	pushNode.emit("UI",new_ui_window)
		
		
		
func map(scene_path: String) -> void:
	fadeOut.emit()
	var map_load = load(scene_path)
	var map_instant = map_load.instantiate()
	set_Next.emit(map_instant)
	
func play_cutscene(scene_path: String, letterbox: bool) -> void:
	var cutscene_load = load(scene_path)
	var cutscene_instant = cutscene_load.instantiate()
	pullNode.emit("MOVIE")
	pushNode.emit("MOVIE", cutscene_instant)
	
	
	
	
func additem(itemID: String, item_amount: int) -> void:
	if item_library[itemID] != null:
		for counts in item_amount:
			item_add.emit(itemID)
			
			
			
			
func delitem(itemID: String, item_amount:int) -> void:
	if item_library[itemID] != null:
		for counts in item_amount:
			item_del.emit(itemID)
func storeitem(itemID: String) -> void:
	pass
func unstoreitem(itemID: String) -> void:
	pass
func mergeitem(itemID: String) -> void:
	pass
	
func checkitem(itemID: String) -> bool:
	if item_library[itemID] != null:
		if item_library[itemID].instances.is_empty() == false:
			return true
		else:
			return false
	else:
		return false

func minimap_mark(MarkerID: String, coordinates: Vector3, sprite_icon: Texture2D, size: float, icontext = ""):
	var markerIcon = Button.new()
	var markerVector: Vector2
	markerIcon.flat = true
	markerIcon.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	markerIcon.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	markerIcon.text = icontext
	markerIcon.add_theme_constant_override("outline_size", 5)
	markerIcon.icon = sprite_icon
	if sprite_icon != null:
		markerVector = Vector2(sprite_icon.get_width(),sprite_icon.get_height()) + markerIcon.size
	else: 
		markerVector = markerIcon.size
	markerIcon.scale = Vector2(size,size)
	markerIcon.pivot_offset = markerVector/2
	
	minimapitems[MarkerID] = [markerIcon,coordinates]

func minimap_unmark(MarkerID:String):
	minimapitems[MarkerID].erase(MarkerID)


	
#COMMAND PROMPT SYSTEM
#Change Map:	map <map_directory>
#spawn an entity: summon <entity_id> <x> <y> 
#Invulnerability:	jupiter
#Unspottable:	pluto
#4x damage:		saturn
#fullbright:	venus
#full health, full ammo:	mars
#idfa but all locked unlocked:	earth
#discrete debug information:	jameswebb
#noclip: halley
#show all items on map: hubble
 
func console_command(command_string: String):
	var Raw_Command: Array
	Raw_Command.append_array(command_string.split(" "))
