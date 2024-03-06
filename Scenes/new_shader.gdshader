shader_type canvas_item;

uniform vec4 oldColor = vec4(1.0,1.0,1.0,1.0);
uniform vec4 blue = vec4(0.0,0.0,1.0,1.0);

void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	if(curr_color.r >= oldColor.r - 0.001 && curr_color.r <= oldColor.r + 0.001
	 && curr_color.g >= oldColor.g - 0.001 && curr_color.g <= oldColor.g + 0.001
	 && curr_color.b >= oldColor.b - 0.001 && curr_color.b <= oldColor.b + 0.001
	 && curr_color.a >= oldColor.a - 0.001 && curr_color.a <= oldColor.a + 0.001)
	{
		COLOR = blue;
	}
	else
		COLOR = curr_color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
