Shader "Modified/ToonLit" {
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_Color2 ("Noise Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_NoiseStrength ("Noise Strength", Range(0, 1)) = 0.5
		_ModTex ("Modifier Texture", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
CGPROGRAM
#pragma surface surf ToonRamp

sampler2D _Ramp;

// custom lighting function that uses a texture ramp based
// on angle between light direction and normal
#pragma lighting ToonRamp exclude_path:prepass
inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
{
	#ifndef USING_DIRECTIONAL_LIGHT
	lightDir = normalize(lightDir);
	#endif
	
	half d = dot (s.Normal, lightDir)*0.5 + 0.5;
	half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
	
	half4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
	c.a = 0;
	return c;
}


sampler2D _MainTex;
sampler2D _NoiseTex;
sampler2D _ModTex;
float4 _Color;
float4 _Color2;
float _NoiseStrength;

struct Input {
	float2 uv_MainTex : TEXCOORD0;
	float2 uv_ModTex : TEXCOORD1;
	float3 worldPos;
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	//half4 n = tex2D(_NoiseTex, IN.uv_MainTex) * _Color; // project noise onto model
	half4 n = tex2D(_NoiseTex, IN.worldPos) * _Color; // stick noise onto the model's side
	o.Albedo = (n.r < _NoiseStrength) ? _Color2 : c.rgb * n.rgb; // use noise texture
	//half4 m = tex2D(_ModTex, IN.uv_ModTex) * _Color;
	//o.Albedo = (n.rgb > m.rgb) ? m.rgb : c.rgb * n.rgb;
	o.Alpha = c.a;
}
ENDCG

	} 

	Fallback "Diffuse"
}