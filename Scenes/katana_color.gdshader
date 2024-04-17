shader_type canvas_item;

uniform vec4 color_tint: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	if(color.r > 0.85 && color.g > 0.85 && color.b > 0.85 && color.a > 0.99){
		COLOR *= color_tint; 
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}


