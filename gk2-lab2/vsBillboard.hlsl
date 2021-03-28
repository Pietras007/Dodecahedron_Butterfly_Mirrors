cbuffer cbWorld : register(b0) //Vertex Shader constant buffer slot 0
{
	matrix worldMatrix;
};

cbuffer cbView : register(b1) //Vertex Shader constant buffer slot 1
{
	matrix viewMatrix;
	matrix invViewMatrix;
};

cbuffer cbProj : register(b2) //Vertex Shader constant buffer slot 2
{
	matrix projMatrix;
};

struct PSInput
{
	float4 pos : SV_POSITION;
	float2 tex : TEXCOORD0;
};

PSInput main(float3 pos : POSITION)
{
	PSInput o;
	o.tex = pos.xy;

	//TODO : 1.31. Calculate on-screen position of billboard vertex
	matrix modelView = mul(viewMatrix, worldMatrix);
	modelView[0][0] = 1.0;
	modelView[0][1] = 0.0;
	modelView[0][2] = 0.0;

	modelView[1][0] = 0.0;
	modelView[1][1] = 1.0;
	modelView[1][2] = 0.0;

	modelView[2][0] = 0.0;
	modelView[2][1] = 0.0;
	modelView[2][2] = 1.0;

	float4 projPos = mul(modelView, float4(pos, 1.0f));
	float4 _pos = mul(projMatrix, projPos);
	o.pos = _pos;

	
	return o;
}