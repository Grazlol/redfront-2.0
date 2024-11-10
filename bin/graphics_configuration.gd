extends WorldEnvironment

@export var TrueBrightness: float
@export var TrueSaturation: float
@export var TrueContrast: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.environmentrefresh.connect(environment_refresh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func environment_refresh() -> void:
	
	
	environment.fog_enabled = vario.fetch("ENV_fog?")
	environment.fog_light_color = vario.fetch("ENV_fogColor")
	environment.adjustment_color_correction = vario.fetch("ENV_tonemap")
	environment.adjustment_brightness = vario.fetch("ENV_localbrightness")
	environment.adjustment_saturation = vario.fetch("ENV_localsaturation")
	environment.adjustment_contrast = vario.fetch("ENV_localcontrast")
	environment.background_color = vario.fetch("ENV_Ambient_Light_Color")
	environment.background_energy_multiplier = vario.fetch("ENV_Ambient_Light_Intensity")
