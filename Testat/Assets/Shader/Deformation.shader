Shader "Testat/Deformation" {
	Properties
	{
		
	}
SubShader {
    Pass {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"

        struct appdata {
            float4 vertex : POSITION;
			float3 normal : NORMAL;
        };

        struct v2f {
            float4 position : SV_POSITION;
			fixed4 color : COLOR;
        };
		
		float _timeToLive;
		float _forceMultiplier;
		float4 _collisionPositionList[100];
		float _timeToLiveList[100];

		// harmonische (gaussian) Distribution wird angewendet 
		// => Je weiter der Punkt vom Kollisionspunkt weg ist, desto kleiner wird die einwirkende Kraft (e^(-distance^2)).

        v2f vert (appdata v) 
		{
            v2f o;

			float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);

			float4 force = float4(0,0,0,0);

			for (int i = 0; i < 100; i++)
			{
				float4 collisionDirection = worldVertex - _collisionPositionList[i];
				float distance = length(collisionDirection);

				float singleDeformationForce = (1 / distance) * (_timeToLiveList[i] / _timeToLive); 

				force = force + (_forceMultiplier * singleDeformationForce * collisionDirection);
			}

			float4 newWorldVertex = worldVertex + force;
			
			o.position = mul(UNITY_MATRIX_VP, newWorldVertex);

			o.color.xyz = v.normal * 0.5 + 0.5;
			o.color.w = 1.0;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target 
		{
			return i.color;
		}
        ENDCG
    }
}
}