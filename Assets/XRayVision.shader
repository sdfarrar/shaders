Shader "Custom/XRayVision"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_EdgeFactor ("Edge Factor", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Blend One One
		ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
                half3 normal : TEXCOORD1;
				float4 vertex : SV_POSITION;
				half3 viewDir : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _EdgeFactor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//float ndotl = dot(i.normal, _WorldSpaceLightPos0); 
				//return float4(ndotl, ndotl, ndotl, 0);

				float ndotv = (1 - dot(i.normal, i.viewDir)) * _EdgeFactor;
				return float4(ndotv, ndotv, ndotv, 0);
			}
			ENDCG
		}
	}
}
