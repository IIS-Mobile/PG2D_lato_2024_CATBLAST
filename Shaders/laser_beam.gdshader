shader_type canvas_item;

uniform vec4 laser_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red laser
uniform float intensity : hint_range(0.0, 3.0) = 1.0;
void fragment() {

    float glow = max(0.0, 1.0 - abs(UV.y - 0.5) * 2.0);

    COLOR = laser_color * glow * intensity;
}