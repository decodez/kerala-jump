#version 330

in vec3 fragNormal;
in vec4 fragColor;

uniform vec4 colDiffuse;
uniform vec3 lightDir;

out vec4 finalColor;

// Flat ambient + Lambertian diffuse off a fixed "sun" direction — no
// specular, no shadows. Matches D-003's stylized-low-poly direction: enough
// shading to read as morning light on solid low-poly forms, not a full
// lighting pipeline.
void main()
{
    vec3 normal = normalize(fragNormal);
    float ndotl = max(dot(normal, normalize(-lightDir)), 0.0);
    float ambient = 0.45;
    float lit = ambient + (1.0 - ambient) * ndotl;
    finalColor = vec4(fragColor.rgb * colDiffuse.rgb * lit, colDiffuse.a * fragColor.a);
}
