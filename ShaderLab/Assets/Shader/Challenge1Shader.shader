Shader "Custom/Challenge1Shader" {
	Properties {
		_Colour ("Colour",Color) = (1,1,1,1)
		_Normal ("Normal",Color) = (1,1,1,1)
		_Emission ("Emission",Color) = (1,1,1,1)
	}
	SubShader {
		CGPROGRAM
		#pragma surface surf Lambert
		struct Input {
			float2 uvMainTex;
		};
		fixed4 _Colour;
		fixed4 _Emission;
		fixed4 _Normal;

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = _Colour.rgb;
			o.Emission = _Emission.rgb;
			o.Normal = _Normal;
		}
		ENDCG
		
	}

	FallBack "Diffuse"
}