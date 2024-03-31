Shader "Custom/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower("Rim Power",Range(0,10)) = 1
        _Outline_Bold ("Outline Bold", Range(0,1)) = 1
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        fixed4 _RimColor;
        fixed4 _Color;
        half _RimPower;
        half _Outline_Bold;

        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            half rim = 1 - saturate(dot(normalize(IN.viewDir),o.Normal));
            o.Emission = rim > (1-_Outline_Bold) ? _RimColor: rim > (1-_Outline_Bold)/1.5 ? (_RimColor * 0.3): 0;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //// Metallic and smoothness come from slider variables
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
