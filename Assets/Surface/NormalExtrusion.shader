Shader "Custom/Normal Extrusion" {
	Properties {
		_Tint ("Tint", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Amount ("Extrusion Amount", Range(-0.0001, 0.0001)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:myvert

		struct Input {
            float2 uv_MainTex; // gathers UV data from _MainTex. naming matters here
		};

        sampler2D _MainTex;
		fixed4 _Tint;
        float _Amount;

        void myvert (inout appdata_full v) {
            v.vertex.xyz += v.normal * _Amount;
        }

		void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Tint;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
