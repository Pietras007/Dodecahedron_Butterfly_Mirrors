struct Light
{
	float4 position;
	float4 color;
};

struct Lighting
{
	float4 ambient;
	float4 surface;
	Light lights[3];
};

cbuffer cbSurfaceColor : register(b0) //Pixel Shader constant buffer slot 0 - matches slot in psBilboard.hlsl
{
	float4 surfaceColor;
}

cbuffer cbLighting : register(b1) //Pixel Shader constant buffer slot 1
{
	Lighting lighting;
}

//TODO : 0.8. Modify pixel shader input structure to match vertex shader output
struct PSInput
{
	float4 pos : SV_POSITION;
	float3 normal : NORMAL0;
	float3 worldPos: POSITION0;
	float3 viewVec: TEXCOORD0;
};

float4 main(PSInput i) : SV_TARGET
{
	//TODO : 0.9. Calculate output color using Phong Illumination Model
	float3 v = normalize(i.viewVec);
	float3 n = normalize(i.normal);
	float3 color = lighting.ambient.xyz * lighting.surface.x;
	for (int k = 0; k < 3; k++)
	{
		//diffuse
		Light light = lighting.lights[k];
		float3 l = normalize(light.position.xyz - i.worldPos);
		float3 h = normalize(l + v);
		color += light.color.xyz * surfaceColor.xyz * lighting.surface.y * clamp(dot(n, l), 0.0f, 1.0f);

		//specular
		float nh = dot(n, h);
		nh = clamp(nh, 0.0f, 1.0);
		nh = pow(nh, lighting.surface.w);
		nh *= lighting.surface.z;
		color += light.color.xyz * nh;
	}

	return saturate(float4(color, surfaceColor.w));
}