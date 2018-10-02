Shader "Custom/Overdraw"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
        _OverdrawColor ("Tint", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "Queue"="Transparent" } // Render over skybox
		LOD 100

        ZTest Always // regardless of whats in the depth buffer, this will be drawn
        ZWrite Off
        Blend One One // additive blend

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			//sampler2D _MainTex;
			//float4 _MainTex_ST;
            half4 _OverdrawColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _OverdrawColor;
			}
			ENDCG
		}
	}
}
