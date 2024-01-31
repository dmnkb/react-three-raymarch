varying vec2 vUv;

uniform int uScrollY;

float distance_from_sphere(in vec3 p, in vec3 c, float r) {
  return length(p - c) - r;
}

float smooth_min(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

float map_the_world(in vec3 p) {
  float shift = (float(uScrollY) * 3.1415 / 180.0) * 0.1;
  float factor = sin(shift) * 0.1;

  float displacementSphere1 = sin(5.0 * (p.x + shift)) * sin(5.0 * p.y) * sin(5.0 * p.z) * (0.125 + factor);
  float sphere1 = distance_from_sphere(p, vec3(0.0), 1.0);

  float sphere2 = distance_from_sphere(p, vec3(0.0 + (sin(factor * 2.0) * 10.0), 0.0, 0.0), .5);

  float blendedDistance = smooth_min(sphere1 + displacementSphere1, sphere2, 0.85);

  return blendedDistance;
}

vec3 calculate_normal(in vec3 p) {
  const vec3 small_step = vec3(0.001, 0.0, 0.0);

  float gradient_x = map_the_world(p + small_step.xyy) - map_the_world(p - small_step.xyy);
  float gradient_y = map_the_world(p + small_step.yxy) - map_the_world(p - small_step.yxy);
  float gradient_z = map_the_world(p + small_step.yyx) - map_the_world(p - small_step.yyx);

  vec3 normal = vec3(gradient_x, gradient_y, gradient_z);

  return normalize(normal);
}

vec3 ray_march(in vec3 ro, in vec3 rd) {
  float total_distance_traveled = 0.0;
  const int NUMBER_OF_STEPS = 64;
  const float MINIMUM_HIT_DISTANCE = 0.001;
  const float MAXIMUM_TRACE_DISTANCE = 1000.0;

  for(int i = 0; i < NUMBER_OF_STEPS; ++i) {
    vec3 current_position = ro + total_distance_traveled * rd;

    float distance_to_closest = map_the_world(current_position);

    if(distance_to_closest < MINIMUM_HIT_DISTANCE) {
      vec3 normal = calculate_normal(current_position);
      vec3 light_position = vec3(2.0, -5.0, 3.0);
      vec3 direction_to_light = normalize(current_position - light_position);

      float diffuse_intensity = max(0.2, dot(normal, direction_to_light));

      return vec3(1.0, 1.0, 1.0) * diffuse_intensity;
    }

    if(total_distance_traveled > MAXIMUM_TRACE_DISTANCE) {
      break;
    }
    total_distance_traveled += distance_to_closest;
  }
  return vec3(0.0);
}

void main() {
  vec2 uv = vUv.st * 2.0 - 1.0;

  vec3 camera_position = vec3(0.0, 0.0, -5.0);
  vec3 ro = camera_position;
  vec3 rd = vec3(uv, 1.0);

  vec3 shaded_color = ray_march(ro, rd);

  gl_FragColor = vec4(shaded_color, shaded_color == vec3(0.0) ? 0.0 : 1.0);
}
