Shader "Hidden/BWDiffuse"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _bwBlend ("Black & White Blend", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img // vert_img is the stardard "empty" vertex function
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float _bwBlend;

			
            // v2f_img is the standard input structure provided
			float4 frag(v2f_img i) : COLOR {
                float4 c = tex2D(_MainTex, i.uv);

                // magic numbers used to compute a grayscaled version
                float lum = c.r*0.3 + c.g*0.59 + c.b*0.11;
                float3 bw = float3(lum, lum, lum);

                float4 result = c;
                result.rgb = lerp(c.rgb, bw, _bwBlend);
                return result;
			}
			ENDCG
		}
	}
}
