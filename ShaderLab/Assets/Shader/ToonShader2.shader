Shader "Custom/ToonShader2"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "while" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon

        #pragma target 3.0

        sampler2D _RampTex;

        half4 LightingToon (SurfaceOutput s, half3 lightDir,half3 viewDir, half atten) 
        {
            half diff  = dot(s.Normal,lightDir) * 0.5 + 0.5;
            float rim = abs(dot(s.Normal, viewDir));
            half3 h = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal,h));
            float2 rh = h;
            //spec = smoothstep(0.005, 0.1,spec);
            float4 ramp = tex2D(_RampTex,float2(diff, rim));

            half4 c;
            c.rgb = (s.Albedo * _LightColor0 *  (ramp.rgb)) + _LightColor0 * (ramp.rgb * 0.1);
            c.a = s.Alpha;
            return c;
        }

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
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
