Shader "Hidden/Sepia"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                //calculate new rgb value
                fixed4 sepia;
                sepia.r = dot(col.rgb, half3(0.393,0.769,0.189));
                sepia.g = dot(col.rgb, half3(0.349,0.686,0.168));
                sepia.b = dot(col.rgb, half3(0.272,0.534,0.131));

                //set new rgb value
                col.rgb = sepia;
                return col;
            }
            ENDCG
        }
    }
}
