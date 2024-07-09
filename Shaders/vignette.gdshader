shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D vignette;
const vec3 circ = vec3(0.06711057,0.00588715,52.9829189);
uniform float debanding_dither;
uniform float blur = 0.5;
uniform float vignette_darkness = -0.05;

void fragment() {
	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
	COLOR.rgb = textureLod(screen_texture, SCREEN_UV, (blur - vignette_color.r) * 4.0).rgb;
	COLOR.rgb *= texture(vignette, UV).rgb;
	COLOR.rgb += vignette_darkness;
	float offset = fract(circ.z * fract(dot(FRAGCOORD.xy, circ.xy)));
	COLOR.rgb += vec3(offset,1.0 - offset, offset) * debanding_dither;
}