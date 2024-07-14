shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 50.0) = 10.0;  // The height of the bobbing
uniform float speed : hint_range(0.0, 10.0) = 1.0;       // The speed of the bobbing

void fragment() {
    float offsetY = amplitude * sin(TIME * speed);
    COLOR = texture(TEXTURE, UV + vec2(0.0, offsetY) / 500.0);
}