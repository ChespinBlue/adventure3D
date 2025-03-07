shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
varying float grain_amount;// : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grainsw
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain
uniform bool animate = false;

void fragment() {
	// Sample the original screen texture
	vec4 original_color = texture(screen_texture, SCREEN_UV);
	float color_amount = ((original_color.r + original_color.g + original_color.b - 3.0) * -1.0);

	if(color_amount > 2.0){
		 grain_amount = 1.0;
	}
	else{
		grain_amount = 1.0;
	}
	if(color_amount < 0.1){
		 grain_amount = 0.0;
	}
	//if(color_amount < 0.5){
		 //float grain_amount = 1.0;
	//}

	//float grain_amount = ((original_color.r + original_color.g + original_color.b - 3.0) * -1.0)/16.0;

	float noise = 0.0;

	if (animate) {
		// Generate random noise
		noise = (fract(sin(dot(UV * TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	} else {
		 noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	}
	// Add noise to the original color
	original_color.rgb += noise * grain_amount * grain_size;

	// Clamp the final color to make sure it stays in the valid range
	COLOR = clamp(original_color, 0.0, 1.0);
}
