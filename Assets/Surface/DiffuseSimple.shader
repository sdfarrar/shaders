Shader "Custom/Diffuse Simple" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		struct Input {
			float4 color : COLOR;
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
