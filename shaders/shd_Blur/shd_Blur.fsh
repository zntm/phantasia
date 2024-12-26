varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// width, height, radius
uniform vec3 size;

#define TAU 6.283185307176

#define QUALITY 8.0
#define DIRECTION 16.0

void main()
{
	vec2 radius = size.z / size.xy;
	vec4 result = texture2D(gm_BaseTexture, v_vTexcoord);

	for (float d = 0.0; d < TAU; d += TAU / DIRECTION)
	{
		vec2 offset = vec2(cos(d), sin(d)) * radius;
		
		for (float i = 0.0; i < 1.0; i += 1.0 / QUALITY)
		{
			result += texture2D(gm_BaseTexture, v_vTexcoord + (offset * i));
		}
	}
	
	gl_FragColor = (result / ((QUALITY * DIRECTION) + 1.0)) * v_vColour;
}