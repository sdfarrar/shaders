Shader "Custom/Diffuse Texture" {
	Properties {
		_Tint ("Tint", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		struct Input {
            float2 uv_MainTex; // gathers UV data from _MainTex. naming matters here
		};

        sampler2D _MainTex;
		fixed4 _Tint;

		void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Tint;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
