extends Area3D

@export var sectionName: String
@export var Light_Source_Master: Node##Where Lightprobes for the section are stored
@export var World_Geometry: Node##Where 3D Geometry for the section is Stored for Render Culling DISCLAIMER: DO NOT PUT ENTITIES INSIDE. IT WILL GIVE STRANGE RESULTS ON RENDER (IE INVISIBLE ENEMIES, SCARY)
var LightProbes: Dictionary
var LightMapFactor: float
var LightMapFactor2: float
@onready var culling_process: bool
@onready var discovered: bool
@onready var minimapID = str(randf_range(10000,99999))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.add("CAMERAPIVOT_MODE_THIRDPERSON","FOLLOW")
	vario.add("MINIMAP_MODE", false)
	for element in Light_Source_Master.get_children():
		LightProbes[element] = float(element.light_energy)
	LightMapFactor = 1
	LightMapFactor2 = 1
	for element in LightProbes:
		element.light_energy = 0 * LightProbes[element]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vario.GAME_PAUSED == false and discovered:
		vario.minimap_mark(minimapID, global_position,null,2,sectionName)

func _physics_process(delta: float) -> void:
	if vario.fetch("CURRENT_MAPZONE_ENTERED_BY_PLAYER?") == self or (vario.fetch("MINIMAP_MODE") == true and discovered):
		World_Geometry.visible = true
		if vario.fetch("MINIMAP_MODE") == false:
			Light_Source_Master.visible = true
			LightMapFactor = 1.0
		else:
			Light_Source_Master.visible = true
			LightMapFactor = 1.0
	else:
		World_Geometry.visible = false
		Light_Source_Master.visible = false
		LightMapFactor = 0.0
		LightMapFactor2 = 0.0
		
	if culling_process:
			if !is_equal_approx(LightMapFactor,LightMapFactor2):
				LightMapFactor2 = lerpf(LightMapFactor2,LightMapFactor, delta * 2.5)
				for element in LightProbes:
					element.light_energy = LightMapFactor2 * LightProbes[element]
			else:
				
				culling_process = false
			

func _on_body_entered(body: Node3D) -> void:
	vario.add("CURRENT_MAPZONE_ENTERED_BY_PLAYER?", self)
	vario.zone_transition.emit()
	culling_process = true
	discovered = true
	
