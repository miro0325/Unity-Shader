Shader "Custom/Transparent"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        //Blend DstColor Zero
        Pass 
        {
            SetTexture [_MainTex] { combine texture }
        }
    }
    FallBack "Diffuse"
}
