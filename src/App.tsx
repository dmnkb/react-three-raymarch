import { Canvas } from '@react-three/fiber';

import { Scene } from './scene';

const App = () => {
  return (
    <div className="h-[5000px]">
      <div className="fixed pointer-events-none h-screen w-full p-16 lg:p-48">
        <Canvas gl={{ antialias: false }} className="bg-[#555]">
          <Scene />
        </Canvas>
      </div>
    </div>
  );
};

export default App;
