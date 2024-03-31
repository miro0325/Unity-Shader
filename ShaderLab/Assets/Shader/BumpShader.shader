Shader "Custom/BumpShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _BumpMap ("Normal Map",2D) = "bump" {}
        _BumpStrength ("Normal Strength", Range(0,1)) = 0
        _BumpBrightness ("Brightness",Range(0,10)) = 1
        _CubeMap ("Cube Map", Cube) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //#pragma surface surf Standard fullforwardshadows
        #pragma surface surf Lambert
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        samplerCUBE _CubeMap;

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldRefl; INTERNAL_DATA
        };

        fixed4 _Color;
        float _BumpStrength;
        half _BumpBrightness;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)) * _BumpBrightness;
            o.Normal *= float3(_BumpStrength, _BumpStrength, 1);
            o.Emission = texCUBE(_CubeMap, WorldReflectionVector(IN,o.Normal)).rgb;
            //o.Alpha = c.a;
            //fixed4 c = texCUBE(_CubeMap, IN.worldRefl);
            //o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
