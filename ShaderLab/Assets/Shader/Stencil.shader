Shader "Custom/Stencil"
{
   Properties
    {
        _MainTex ("Diffuse", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)

        _StencilRef("Stencil Ref", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comp", float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Op", float) = 2
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }
        LOD 200

        ColorMask 0
        ZWrite off

        Stencil 
        {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilOp]
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
