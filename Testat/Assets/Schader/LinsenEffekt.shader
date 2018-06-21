// Upgrade NOTE: replaced 'texRECT' with 'tex2D'

Shader "Unlit/Kantenfilter"
{
	Properties {
		_K1("K1", Range(-5, 5)) = 0
		_K2("K2", Range(-5, 5)) = 0
		_P1("P1", Range(-5, 5)) = 0
		_P2("P2", Range(-5, 5)) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// "Queue"="Transparent": Draw ourselves after all opaque geometry
		// "IgnoreProjector"="True": Don't be affected by any Projectors
		// "RenderType"="Transparent": Declare RenderType as transparent
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
       

        	// Grab the screen behind the object into Default _GrabTexture
        	// https://docs.unity3d.com/Manual/SL-GrabPass.html
		GrabPass {"_GrabTexture"}
       
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		 
			#include "UnityCG.cginc"
		 
			sampler2D _GrabTexture;
			float _K1;
			float _K2;
			float _P1;
			float _P2;

		 
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 grabPosUV : TEXCOORD0;
			};

			// VERTEX SHADER
			v2f vert (appdata v)
			{
				v2f o;

				// use UnityObjectToClipPos from UnityCG.cginc to calculate 
				// the clip-space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);

				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				o.grabPosUV = ComputeGrabScreenPos(o.pos);
				return o;
			}





			// FRAGMENT SHADER
			half4 frag (v2f i) : SV_Target
			{
				float2 t;
				t.x = i.grabPosUV.x - 0.5;
				t.y = -(i.grabPosUV.y - 0.5);

			       
				float r2 = (t.x*t.x) + (t.y*t.y);

				float r4 = r2 * r2;
		
			       
				t.x = t.x - t.x * (_K1 * r2 + _K2 * r4) + (_P1 * (r2 + 2 * t.x * t.x)+ 2 * _P2 * t.x * t.y);
				t.y = t.y - t.y * (_K1 * r2 + _K2 * r4) + (_P1 * (r2 + 2 * t.y * t.y)+ 2 * _P2 * t.y * t.x);

				t.x = t.x + 0.5;
				t.y = (-t.y) + 0.5;

			       
				return tex2D(_GrabTexture, t);  
			    }
		    ENDCG
		}
	}
}
