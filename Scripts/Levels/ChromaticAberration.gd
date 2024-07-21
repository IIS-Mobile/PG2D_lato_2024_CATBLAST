extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = GlobalVariables.CHROMATIC_ABERRATION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = GlobalVariables.CHROMATIC_ABERRATION