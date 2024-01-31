import { Stats } from '@react-three/drei';
import { useThree } from '@react-three/fiber';
import { useEffect, useMemo, useRef } from 'react';
import { ShaderMaterial } from 'three';

import fragmentShader from './shader/fragmentShader.glsl';
import vertexShader from './shader/vertexShader.glsl';

const Plane = () => {
  const material = useRef<ShaderMaterial>(null);

  useEffect(() => {
    document.addEventListener('scroll', () => {
      if (material.current?.uniforms.uScrollY) {
        material.current.uniforms.uScrollY.value = scrollY || 1;
      }
    });
  });

  const uniforms = useMemo(() => {
    return {
      uScrollY: {
        value: 1,
      },
    };
  }, []);

  const { viewport } = useThree();

  return (
    <mesh>
      <planeGeometry args={[viewport.width, viewport.width]} />
      <shaderMaterial fragmentShader={fragmentShader} uniforms={uniforms} ref={material} vertexShader={vertexShader} />
    </mesh>
  );
};

export const Scene = () => {
  return (
    <>
      <Stats />
      <Plane />
    </>
  );
};
