Shader "Custom/AlwaysVisibleVariation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Always Visible Color", Color) = (0,0,0,0)
        _Visibility("Visibility", Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "Queue"="Transparent" } // render after solid objects
		LOD 100

		Pass
		{
			//Cull Off // I don't think we need to turn culling off
			ZWrite Off // Controls whether pixels from this object are drawn to z buffer. Solid objects -> On. Semitransparent effects -> Off
			ZTest Always // Always test for z buffer

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
            float _Visibility;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				clip(1 - i.vertex.x % (1/_Visibility));
				clip(1 - i.vertex.y % (1/_Visibility));
				return tex2D(_MainTex, i.uv) * _Color;
			}

			ENDCG
		}


		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
