shader_type canvas_item;

uniform float heat_intensity : hint_range(0.0, 1.0);
uniform float amplitude : hint_range(0.0, 50.0) = 10.0;  // The height of the bobbing
uniform float speed : hint_range(0.0, 10.0) = 1.0;       // The speed of the bobbing

void fragment() {
	
	float offsetY = amplitude * sin(TIME * speed);

    // Sample the texture color
    vec4 texture_color = texture(TEXTURE, UV + vec2(0.0, offsetY) / 500.0);

    // Calculate a "heat" color based on intensity
    vec3 heat_color = mix(vec3(1.0, 1.0, 1.0), vec3(1.0, 0.5, 0.0), heat_intensity);

    // Apply the heat color to the texture color
    texture_color.rgb *= heat_color;

    // Output the final color
    
	COLOR = texture_color;
}
