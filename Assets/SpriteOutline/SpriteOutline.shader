Shader "Sprites/Outline"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineTickness ("Outline Thickness", Range(0, 10)) = 1
        _Width ("Width", Float) = 256
        _Height ("Height", Float) = 256
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend One OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half2 uv : TEXCOORD0;
			};
			
			fixed4 _Color;
            fixed4 _OutlineColor;
            float4 _MainTex_TexelSize;
            float _OutlineTickness, _Width, _Height;


			v2f vert(appdata_t IN) {
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif
				return OUT;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target {
				fixed4 c = tex2D(_MainTex, IN.uv) * IN.color;
				c.rgb *= c.a;

                half4 outlineColor = _OutlineColor;
                outlineColor.a *= ceil(c.a);
                outlineColor.rgb *= outlineColor.a;

                //float2 pixelSize = float2(1.0/_Width, 1.0/_Height);

                float texelSizeX = _MainTex_TexelSize.x;
                float texelSizeY = _MainTex_TexelSize.y;
                float thicknessX = _OutlineTickness * texelSizeX;
                float thicknessY = _OutlineTickness * texelSizeY;
                //float thicknessX = _OutlineTickness * pixelSize.x;
                //float thicknessY = _OutlineTickness * pixelSize.y;

                //float2 position = float2((IN.uv.x*texelSizeX)/_Width, (IN.uv.y*texelSizeY)/_Height);

                //float uAlpha = tex2Dlod(_MainTex, float4(position.x, position.y + pixelSize.y, 0, 0)).a;
                //float dAlpha = tex2Dlod(_MainTex, float4(position.x, position.y - pixelSize.y, 0, 0)).a;
                //float rAlpha = tex2Dlod(_MainTex, float4(position.x + pixelSize.x, position.y, 0, 0)).a;
                //float lAlpha = tex2Dlod(_MainTex, float4(position.x - pixelSize.x, position.y, 0, 0)).a;
                float uAlpha = tex2D(_MainTex, IN.uv + float2(0, thicknessY)).a;
                float dAlpha = tex2D(_MainTex, IN.uv - float2(0, thicknessY)).a;
                float rAlpha = tex2D(_MainTex, IN.uv + float2(thicknessX, 0)).a;
                float lAlpha = tex2D(_MainTex, IN.uv - float2(thicknessX, 0)).a;
                float neighborAlpha = uAlpha * dAlpha * rAlpha * lAlpha;

				return lerp(outlineColor, c, ceil(neighborAlpha));
			}

		ENDCG
		}
	}
}