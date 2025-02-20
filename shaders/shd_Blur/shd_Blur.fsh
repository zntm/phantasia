varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// width, height, radius
uniform vec3 size;

#define PI 3.14159265359
#define PI_HALF 1.5707963268

#define TAU 6.283185307176

#define QUALITY 16.0

/*
float calculate_cos(float _)
{
    return (((5.0 * TAU * TAU) / 4.0) / ((_ * _) + (PI * PI))) - 4.0;
}

float cos_approx(float _)
{
    _ = abs(_);
    
    int type = int(mod(floor(_ / PI_HALF), 4.0));
    
    if (type == 0)
    {
        return  _calculate(mod(_, PI_HALF));
    }
    
    if (type == 1)
    {
        return -_calculate(mod(_, PI_HALF) - PI_HALF);
    }    
    
    if (type == 2)
    {
        return -_calculate(mod(_, PI_HALF));
    }
    
    {
        return  _calculate(mod(_, PI_HALF) - PI_HALF);
    }
}
*/

void main()
{
    vec2 radius = (size.z / size.xy) * 2.0;
    
    vec4 sum = texture2D(gm_BaseTexture, v_vTexcoord);
    
    float weight_total = 1.0;
    
    for (float a = 0.0; a < TAU; a += TAU / QUALITY)
    {
        // vec2 direction = vec2(cos_approx(a), cos_approx(a + PI_HALF)) * radius;
        vec2 direction = vec2(cos(a), sin(a)) * radius;
        
        for (float t = 1.0 / QUALITY; t < 1.0; t += 1.0 / QUALITY)
        {
            float weight = 1.0 - t;
            
            sum += texture2D(gm_BaseTexture, v_vTexcoord + (direction * t)) * weight;
            
            weight_total += weight;
        }
    }
    
    gl_FragColor = (sum / weight_total) * v_vColour;
}